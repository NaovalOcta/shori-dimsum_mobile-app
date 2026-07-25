-- =====================================================
-- SHORI DIMSUM - SEED DATA
-- Data awal untuk testing aplikasi
-- =====================================================

-- =============================================
-- 1. SEED PRODUCTS (Menu Dimsum)
-- =============================================
INSERT INTO public.products (name, price, description, category, unitpieces, image_path, rating) VALUES
('Dimsum Mental',          10000, 'Dimsum ayam premium dengan kulit tipis yang lembut.', 'Dimsum', 16, '', 4.9),
('Siomay Premium',         11000, 'Siomay ikan tenggiri asli dengan bumbu kacang spesial.', 'Dimsum', 10, '', 4.7),
('Bakpao Ayam',            12000, 'Bakpao lembut isi ayam cincang berbumbu rempah.',   'Classic', 5, '', 4.5),
('Ayam Special Crispy',    13000, 'Ayam goreng crispy dengan bumbu rahasia Shori Dimsum.', 'Popular', 2, '', 5.0),
('Mie Ayam Bakso',         14000, 'Mie ayam dengan topping bakso sapi dan pangsit.',     'Classic', 5, '', 4.5),
('Hakau Udang',            11500, 'Hakau udang segar dengan kulit transparan.',           'Dimsum', 8, '', 4.8),
('Lumpia Surabaya',        9000,  'Lumpia isi sayuran dan udang rebon khas Surabaya.',      'Classic', 4, '', 4.6),
('Pangsit Goreng',         8000,  'Pangsit goreng renyah isi ayam dan kol.',                 'Topping', 5, '', 4.4),
('Cwaree Telur',           7000,  'Cwaree telur kukus lembut ala dimsum tradisional.',       'Dimsum', 4, '', 4.3),
('Gyeranjjim',             8500,  'Telur kukus Korea dengan wortel dan daun bawang.',         'Topping', 2, '', 4.2)
ON CONFLICT DO NOTHING;

-- =============================================
-- 2. SEED ADMIN USER (Manual)
-- =============================================
-- Admin pertama TIDAK bisa dibuat otomatis. Ikuti langkah berikut:
--
-- 1. Register user baru lewat aplikasi (role akan 'user' secara default).
-- 2. Buka Supabase Dashboard → SQL Editor.
-- 3. Jalankan query:
--
--    UPDATE public.users SET role = 'admin'
--    WHERE email = 'admin@shoridimsum.com';
--
-- 4. Login dengan akun tersebut — akan redirect ke Admin Dashboard.

-- =============================================
-- DONE! Seed data berhasil.
-- =============================================
