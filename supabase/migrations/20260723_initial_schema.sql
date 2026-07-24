-- =====================================================
-- SHORI DIMSUM - INITIAL DATABASE SCHEMA
-- Migration: 20260723_initial_schema
-- Description: Buat tabel users, products, orders beserta
--              trigger, index, RLS policy, dan storage bucket
-- =====================================================

-- =====================================================
-- 1. TABLE: users
-- =====================================================
CREATE TABLE IF NOT EXISTS public.users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL PRIMARY KEY,
    email TEXT,
    name TEXT DEFAULT 'New User',
    phone_number TEXT DEFAULT '',
    address TEXT DEFAULT '',
    profile_img TEXT DEFAULT '',
    role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin')),
    created_at TIMESTAMPTZ DEFAULT now()
);

COMMENT ON TABLE public.users IS 'Profil pengguna, terhubung ke auth.users via id';
COMMENT ON COLUMN public.users.role IS 'Role: user (pelanggan) atau admin';

CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);

-- =====================================================
-- 2. TABLE: products
-- =====================================================
CREATE TABLE IF NOT EXISTS public.products (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    price BIGINT NOT NULL DEFAULT 0,
    description TEXT DEFAULT '',
    category TEXT DEFAULT 'General',
    unitpieces SMALLINT DEFAULT 1,
    image_path TEXT DEFAULT '',
    rating TEXT DEFAULT '0.0',
    created_at TIMESTAMPTZ DEFAULT now()
);

COMMENT ON TABLE public.products IS 'Daftar menu produk dimsum';
COMMENT ON COLUMN public.products.unitpieces IS 'Jumlah pcs per porsi (angka saja, misal 16)';

CREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category);
CREATE INDEX IF NOT EXISTS idx_products_name ON public.products(name);

-- =====================================================
-- 3. TABLE: orders
-- =====================================================
CREATE TABLE IF NOT EXISTS public.orders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'process', 'completed', 'cancelled')),
    total_price BIGINT DEFAULT 0,
    items_summary TEXT DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT now()
);

COMMENT ON TABLE public.orders IS 'Riwayat pesanan pelanggan';
COMMENT ON COLUMN public.orders.status IS 'Status: pending, process, completed, cancelled';

CREATE INDEX IF NOT EXISTS idx_orders_user_id ON public.orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON public.orders(created_at DESC);

-- =====================================================
-- 4. TRIGGER: Auto-create user profile saat signup
-- =====================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email, name, phone_number, role)
    VALUES (
        NEW.id,
        COALESCE(NEW.email, ''),
        COALESCE(NEW.raw_user_meta_data->>'name', 'New User'),
        COALESCE(NEW.raw_user_meta_data->>'phone_number', ''),
        COALESCE(NEW.raw_user_meta_data->>'role', 'user')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- =====================================================
-- 5. ENABLE ROW LEVEL SECURITY (RLS)
-- =====================================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 6. RLS POLICIES
-- =====================================================

-- --- 6a. Policies untuk tabel 'users' ---
-- User bisa melihat profilnya sendiri
CREATE POLICY "Users can view own profile"
    ON public.users FOR SELECT
    USING (auth.uid() = id);

-- Admin bisa melihat semua user
CREATE POLICY "Admins can view all users"
    ON public.users FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- User bisa update profilnya sendiri (kecuali email & role)
CREATE POLICY "Users can update own profile"
    ON public.users FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Trigger insert user (service level)
CREATE POLICY "Service role can insert users"
    ON public.users FOR INSERT
    WITH CHECK (true);

-- --- 6b. Policies untuk tabel 'products' ---
-- Semua authenticated user bisa melihat produk
CREATE POLICY "Authenticated users can view products"
    ON public.products FOR SELECT
    USING (auth.role() = 'authenticated');

-- Hanya admin yang bisa manage products (CRUD)
CREATE POLICY "Admins can insert products"
    ON public.products FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

CREATE POLICY "Admins can update products"
    ON public.products FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

CREATE POLICY "Admins can delete products"
    ON public.products FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- --- 6c. Policies untuk tabel 'orders' ---
-- User bisa melihat orderannya sendiri
CREATE POLICY "Users can view own orders"
    ON public.orders FOR SELECT
    USING (auth.uid() = user_id);

-- Admin bisa melihat semua orders
CREATE POLICY "Admins can view all orders"
    ON public.orders FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- User bisa membuat order
CREATE POLICY "Users can create orders"
    ON public.orders FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- Admin bisa update status orders
CREATE POLICY "Admins can update orders"
    ON public.orders FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =====================================================
-- 7. STORAGE BUCKET: menu-images
-- =====================================================
-- Hapus bucket lama jika ada
DELETE FROM storage.buckets WHERE id = 'menu-images';
--SELECT storage.empty_bucket('menu-images');

-- Insert bucket baru (public = true agar gambar bisa diakses via URL publik)
INSERT INTO storage.buckets (id, name, public)
VALUES ('menu-images', 'menu-images', true)
ON CONFLICT (id) DO NOTHING;

-- Policy: Semua orang bisa melihat gambar di bucket menu-images
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'storage'
          AND tablename = 'objects'
          AND policyname = 'Public images are viewable'
    ) THEN
        CREATE POLICY "Public images are viewable"
            ON storage.objects FOR SELECT
            USING (bucket_id = 'menu-images');
    END IF;
END
$$;

-- Policy: Authenticated users bisa upload gambar
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'storage'
          AND tablename = 'objects'
          AND policyname = 'Users can upload images'
    ) THEN
        CREATE POLICY "Users can upload images"
            ON storage.objects FOR INSERT
            TO authenticated
            WITH CHECK (bucket_id = 'menu-images');
    END IF;
END
$$;

-- Policy: Users bisa update gambar mereka sendiri
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'storage'
          AND tablename = 'objects'
          AND policyname = 'Users can update their images'
    ) THEN
        CREATE POLICY "Users can update their images"
            ON storage.objects FOR UPDATE
            TO authenticated
            USING (bucket_id = 'menu-images');
    END IF;
END
$$;

-- Policy: Users bisa delete gambar mereka sendiri
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'storage'
          AND tablename = 'objects'
          AND policyname = 'Users can delete their images'
    ) THEN
        CREATE POLICY "Users can delete their images"
            ON storage.objects FOR DELETE
            TO authenticated
            USING (bucket_id = 'menu-images');
    END IF;
END
$$;
