-- =====================================================
-- SHORI DIMSUM - SEED DATA
-- Data awal untuk testing aplikasi
-- =====================================================

-- =============================================
-- 1. SEED PRODUCTS (Menu Dimsum)
-- =============================================
INSERT INTO public.products (name, price, description, category, unitpieces, image_path, rating) VALUES
('Dimsum Mental',          10000, 'Dimsum ayam premium dengan kulit tipis yang lembut.', 'Dimsum', 16, '', '4.9'),
('Siomay Premium',         11000, 'Siomay ikan tenggiri asli dengan bumbu kacang spesial.', 'Dimsum', 10, '', '4.7'),
('Bakpao Ayam',            12000, 'Bakpao lembut isi ayam cincang berbumbu rempah.',   'Classic', 5, '', '4.5'),
('Ayam Special Crispy',    13000, 'Ayam goreng crispy dengan bumbu rahasia Shori Dimsum.', 'Popular', 2, '', '5.0'),
('Mie Ayam Bakso',         14000, 'Mie ayam dengan topping bakso sapi dan pangsit.',     'Classic', 5, '', '4.5'),
('Hakau Udang',            11500, 'Hakau udang segar dengan kulit transparan.',           'Dimsum', 8, '', '4.8'),
('Lumpia Surabaya',        9000,  'Lumpia isi sayuran dan udang rebon khas Surabaya.',      'Classic', 4, '', '4.6'),
('Pangsit Goreng',         8000,  'Pangsit goreng renyah isi ayam dan kol.',                 'Topping', 5, '', '4.4'),
('Cwaree Telur',           7000,  'Cwaree telur kukus lembut ala dimsum tradisional.',       'Dimsum', 4, '', '4.3'),
('Gyeranjjim',             8500,  'Telur kukus Korea dengan wortel dan daun bawang.',         'Topping', 2, '', '4.2')
ON CONFLICT DO NOTHING;

-- =============================================
-- 2. SEED ADMIN USER (Opsional)
-- =============================================
-- Untuk membuat user admin pertama, jalankan query ini SETELAH register:
-- UPDATE public.users SET role = 'admin' WHERE email = 'admin@shoridimsum.com';
--
-- Jika ingin otomatis saat seed (harus ada user di auth.users terlebih dahulu):
/*
INSERT INTO public.users (id, email, name, phone_number, role)
VALUES (
    '00000000-0000-0000-0000-000000000000', -- Placeholder, ganti dengan UUID user asli
    'admin@shoridimsum.com',
    'Admin Shori Dimsum',
    '081234567890',
    'admin'
) ON CONFLICT (id) DO NOTHING;
*/

-- =============================================
-- DONE! Seed data berhasil.
-- =============================================
