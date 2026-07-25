-- =====================================================
-- SHORI DIMSUM - INITIAL DATABASE SCHEMA
-- Migration: 20260723_initial_schema
-- Description: Buat tabel users, products, orders, order_items
--              beserta trigger, index, RLS policy, storage bucket
-- =====================================================

-- =====================================================
-- 1. TABLE: users
-- =====================================================
CREATE TABLE public.users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL PRIMARY KEY,
    email TEXT,
    name TEXT DEFAULT 'New User',
    phone_number TEXT DEFAULT NULL,
    address TEXT DEFAULT NULL,
    profile_img TEXT DEFAULT NULL,
    role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.users IS 'Profil pengguna, terhubung ke auth.users via id';
COMMENT ON COLUMN public.users.role IS 'Role: user (pelanggan) atau admin';

CREATE UNIQUE INDEX idx_users_email_unique
    ON public.users (email)
    WHERE email IS NOT NULL;

-- =====================================================
-- 2. TABLE: products
-- =====================================================
CREATE TABLE public.products (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    price BIGINT NOT NULL DEFAULT 0,
    description TEXT DEFAULT '',
    category TEXT DEFAULT 'General',
    unitpieces SMALLINT DEFAULT 1,
    image_path TEXT DEFAULT '',
    rating NUMERIC(2,1) DEFAULT 0.0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT products_price_check CHECK (price >= 0),
    CONSTRAINT products_unitpieces_check CHECK (unitpieces > 0),
    CONSTRAINT products_rating_check CHECK (rating >= 0 AND rating <= 5)
);

COMMENT ON TABLE public.products IS 'Daftar menu produk dimsum';
COMMENT ON COLUMN public.products.unitpieces IS 'Jumlah pcs per porsi (angka saja, misal 16)';

CREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category);
CREATE INDEX IF NOT EXISTS idx_products_name ON public.products(name);

-- =====================================================
-- 3. TABLE: orders
-- =====================================================
CREATE TABLE public.orders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'process', 'completed', 'cancelled')),
    total_price BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT orders_total_price_check CHECK (total_price >= 0)
);

COMMENT ON TABLE public.orders IS 'Riwayat pesanan pelanggan';
COMMENT ON COLUMN public.orders.status IS 'Status: pending, process, completed, cancelled';

CREATE INDEX IF NOT EXISTS idx_orders_user_id ON public.orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON public.orders(created_at DESC);

-- =====================================================
-- 3b. TABLE: order_items
-- =====================================================
CREATE TABLE public.order_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES public.products(id) ON DELETE SET NULL,
    product_name TEXT NOT NULL,
    unit_price BIGINT NOT NULL,
    quantity SMALLINT NOT NULL DEFAULT 1,
    subtotal BIGINT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT order_items_unit_price_check CHECK (unit_price >= 0),
    CONSTRAINT order_items_quantity_check CHECK (quantity > 0),
    CONSTRAINT order_items_subtotal_check CHECK (subtotal >= 0)
);

COMMENT ON TABLE public.order_items IS 'Line items dari setiap pesanan';
COMMENT ON COLUMN public.order_items.product_name IS 'Snapshot nama produk saat order';
COMMENT ON COLUMN public.order_items.unit_price IS 'Snapshot harga produk saat order';

CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON public.order_items(order_id);

-- =====================================================
-- 4. TRIGGER: Auto-create user profile saat signup
-- =====================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = publicagent
AS $$
BEGIN
    INSERT INTO public.users (id, email, name, phone_number)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'name', 'New User'),
        COALESCE(NEW.raw_user_meta_data->>'phone_number', NULL)
    )
    ON CONFLICT (id) DO NOTHING;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- 4b. TRIGGER: Auto-update updated_at
-- =====================================================
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;

CREATE TRIGGER set_users_updated_at
    BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_products_updated_at
    BEFORE UPDATE ON public.products
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_orders_updated_at
    BEFORE UPDATE ON public.orders
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- =====================================================
-- 4c. Helper function untuk admin check di RLS
-- =====================================================
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.users
        WHERE id = auth.uid()
          AND role = 'admin'
    );
$$;

REVOKE EXECUTE ON FUNCTION public.is_admin() FROM public;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;

-- =====================================================
-- 5. ENABLE ROW LEVEL SECURITY (RLS)
-- =====================================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 6. RLS POLICIES
-- =====================================================

-- --- 6a. Policies untuk tabel 'users' ---
CREATE POLICY "Users can view own profile"
    ON public.users FOR SELECT
    TO authenticated
    USING (auth.uid() = id);

CREATE POLICY "Admins can view all users"
    ON public.users FOR SELECT
    TO authenticated
    USING (public.is_admin());

CREATE POLICY "Users can update own profile"
    ON public.users FOR UPDATE
    TO authenticated
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- NOTE: INSERT via trigger handle_new_user (SECURITY DEFINER), tidak perlu policy INSERT

-- --- 6b. Policies untuk tabel 'products' ---
CREATE POLICY "Anyone can view products"
    ON public.products FOR SELECT
    TO anon, authenticated
    USING (true);

CREATE POLICY "Admins can insert products"
    ON public.products FOR INSERT
    TO authenticated
    WITH CHECK (public.is_admin());

CREATE POLICY "Admins can update products"
    ON public.products FOR UPDATE
    TO authenticated
    USING (public.is_admin())
    WITH CHECK (public.is_admin());

CREATE POLICY "Admins can delete products"
    ON public.products FOR DELETE
    TO authenticated
    USING (public.is_admin());

-- --- 6c. Policies untuk tabel 'orders' ---
CREATE POLICY "Users can view own orders"
    ON public.orders FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all orders"
    ON public.orders FOR SELECT
    TO authenticated
    USING (public.is_admin());

CREATE POLICY "Users can create orders"
    ON public.orders FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can update orders"
    ON public.orders FOR UPDATE
    TO authenticated
    USING (public.is_admin())
    WITH CHECK (public.is_admin());

-- --- 6d. Policies untuk tabel 'order_items' ---
CREATE POLICY "Users can view own order items"
    ON public.order_items FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.orders
            WHERE id = order_id AND user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can view all order items"
    ON public.order_items FOR SELECT
    TO authenticated
    USING (public.is_admin());

-- =====================================================
-- 7. STORAGE BUCKET: menu-images
-- =====================================================
INSERT INTO storage.buckets (id, name, public)
VALUES ('menu-images', 'menu-images', true)
ON CONFLICT (id) DO UPDATE SET
    public = EXCLUDED.public;

DROP POLICY IF EXISTS "Public images are viewable" ON storage.objects;
DROP POLICY IF EXISTS "Users can upload images" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their images" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their images" ON storage.objects;
DROP POLICY IF EXISTS "menu_images_public_read" ON storage.objects;
DROP POLICY IF EXISTS "menu_images_admin_insert" ON storage.objects;
DROP POLICY IF EXISTS "menu_images_admin_update" ON storage.objects;
DROP POLICY IF EXISTS "menu_images_admin_delete" ON storage.objects;

CREATE POLICY "menu_images_public_read"
    ON storage.objects FOR SELECT
    TO anon, authenticated
    USING (bucket_id = 'menu-images');

CREATE POLICY "menu_images_admin_insert"
    ON storage.objects FOR INSERT
    TO authenticated
    WITH CHECK (bucket_id = 'menu-images' AND public.is_admin());

CREATE POLICY "menu_images_admin_update"
    ON storage.objects FOR UPDATE
    TO authenticated
    USING (bucket_id = 'menu-images' AND public.is_admin());

CREATE POLICY "menu_images_admin_delete"
    ON storage.objects FOR DELETE
    TO authenticated
    USING (bucket_id = 'menu-images' AND public.is_admin());

-- =====================================================
-- 8. GRANTS — least privilege
-- =====================================================
GRANT USAGE ON SCHEMA public TO anon, authenticated;

GRANT SELECT ON public.products TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.products TO authenticated;

GRANT SELECT ON public.users TO authenticated;
GRANT UPDATE (name, phone_number, address, profile_img) ON public.users TO authenticated;
-- NOTE: INSERT on users hanya via trigger, NO GRANT INSERT TO authenticated

GRANT SELECT, INSERT, UPDATE ON public.orders TO authenticated;
GRANT UPDATE (status) ON public.orders TO authenticated;

GRANT SELECT ON public.order_items TO authenticated;

-- =====================================================
-- 9. RPC: create_order
-- =====================================================
CREATE OR REPLACE FUNCTION public.create_order(p_items JSONB)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    new_order_id UUID;
    v_product JSONB;
    v_product_record RECORD;
    v_subtotal BIGINT;
    v_total BIGINT := 0;
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    INSERT INTO public.orders (user_id, status)
    VALUES (auth.uid(), 'pending')
    RETURNING id INTO new_order_id;

    FOR v_product IN SELECT * FROM jsonb_array_elements(p_items)
    LOOP
        SELECT id, name, price INTO v_product_record
        FROM public.products
        WHERE id = (v_product->>'product_id')::UUID;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Product % not found', (v_product->>'product_id');
        END IF;

        v_subtotal := v_product_record.price * (v_product->>'quantity')::SMALLINT;
        v_total := v_total + v_subtotal;

        INSERT INTO public.order_items (
            order_id, product_id, product_name,
            unit_price, quantity, subtotal
        ) VALUES (
            new_order_id,
            v_product_record.id,
            v_product_record.name,
            v_product_record.price,
            (v_product->>'quantity')::SMALLINT,
            v_subtotal
        );
    END LOOP;

    UPDATE public.orders
    SET total_price = v_total
    WHERE id = new_order_id;

    RETURN jsonb_build_object(
        'order_id', new_order_id,
        'total_price', v_total
    );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.create_order(JSONB) FROM public;
GRANT EXECUTE ON FUNCTION public.create_order(JSONB) TO authenticated;
