-- ============================================================
-- ARUBA TECH MARKETPLACE — Supabase Schema
-- ============================================================
-- Ejecuta este archivo en el SQL Editor de tu proyecto Supabase.
-- Run this file in your Supabase project's SQL Editor.
-- ============================================================

-- ── Tablas / Tables ──────────────────────────────────────────

-- Productos
create table if not exists public.products (
  id          text        primary key,
  name        text        not null,
  brand       text        not null,
  cat         text        not null default 'mobile',
  desc_es     text        default '',
  price       numeric     not null default 0,
  old_price   numeric,
  tag         text        check (tag in ('new', 'offer') or tag is null),
  tone        text        default 'slate',
  images      text[]      default array[]::text[],
  active      boolean     default true,
  sort_order  integer     default 0,
  created_at  timestamptz default now()
);

-- Categorías
create table if not exists public.categories (
  id          text        primary key,
  custom_name text        not null,
  cover_url   text,
  created_at  timestamptz default now()
);

-- Usuarios registrados
create table if not exists public.users (
  id          uuid        primary key default gen_random_uuid(),
  name        text        not null,
  email       text,
  phone       text        not null unique,
  district    text        not null,
  created_at  timestamptz default now()
);

-- Configuración (admins, turno, etc.)
create table if not exists public.config (
  key         text        primary key,
  value       jsonb       not null
);

-- ── Datos iniciales / Seed data ──────────────────────────────

insert into public.config (key, value)
values
  ('admins',     '[]'::jsonb),
  ('turn_index', '0'::jsonb)
on conflict (key) do nothing;

-- Productos iniciales (el admin puede editarlos desde el panel)
insert into public.products (id, name, brand, cat, desc_es, price, old_price, tag, tone, sort_order) values
  ('p-galaxy-s24',    'Galaxy S24 Ultra',       'Samsung',   'mobile',    '256GB. Titanio. Cámara 200MP con Galaxy AI.',                2100, null, 'new',   'graphite', 1),
  ('p-pixel-9',       'Pixel 9 Pro',            'Google',    'mobile',    '256GB. Pantalla 6.3". La cámara más inteligente.',           1450, 1650, 'offer', 'rose',     2),
  ('p-xiaomi-14',     'Xiaomi 14 Pro',          'Xiaomi',    'mobile',    'Pantalla 2K LTPO. Carga rápida 120W.',                      1599, null, null,    'ink',      3),
  ('p-oneplus-12',    'OnePlus 12',             'OnePlus',   'mobile',    '16GB RAM. Pantalla 120Hz. Cámaras Hasselblad.',              1399, null, null,    'forest',   4),
  ('p-motorola-edge', 'Edge 50 Pro',            'Motorola',  'mobile',    'Pantalla curva pOLED. Diseño en cuero vegano.',               749,  899, 'offer', 'lilac',    5),
  ('p-sony-xm5',      'WH-1000XM5',             'Sony',      'audio',     'Cancelación líder en su clase. 30h de batería.',             649, null, null,    'cream',    6),
  ('p-bose-ultra',    'QuietComfort Ultra',     'Bose',      'audio',     'Sonido inmersivo. Conexión multipunto.',                      720, null, 'new',   'graphite', 7),
  ('p-jbl-flip',      'Flip 6',                 'JBL',       'audio',     'Bluetooth, sumergible IP67. 12h de música.',                  249,  299, 'offer', 'ember',    8),
  ('p-sonos-era',     'Era 100',                'Sonos',     'audio',     'Sonido estéreo en un solo parlante. Wi-Fi.',                  469, null, null,    'slate',    9),
  ('p-galaxy-watch',  'Galaxy Watch 7',         'Samsung',   'wearables', 'Salud avanzada. Wear OS. 40mm o 44mm.',                       539, null, 'new',   'forest',  10),
  ('p-garmin-265',    'Forerunner 265',         'Garmin',    'wearables', 'Pantalla AMOLED. GPS multibanda. Para correr en serio.',       899, null, null,    'ink',     11),
  ('p-amazfit',       'GTR 4',                  'Amazfit',   'wearables', '14 días de batería. Más de 150 deportes.',                    315, null, null,    'rose',    12),
  ('p-dell-xps',      'XPS 13',                 'Dell',      'laptops',   'Core Ultra 7. 16GB RAM. 512GB. Pantalla InfinityEdge.',       2399, null, null,    'sky',     13),
  ('p-asus-zen',      'Zenbook 14 OLED',        'ASUS',      'laptops',   'Pantalla OLED 14". 1.2kg. Toda la potencia, peso pluma.',     2199, 2499, 'offer', 'lilac',   14),
  ('p-hp-spectre',    'Spectre x360 14',        'HP',        'laptops',   'Convertible 2-en-1. Pantalla táctil OLED.',                  2649, null, 'new',   'graphite', 15),
  ('p-lg-oled',       'OLED evo C4 65"',        'LG',        'home',      '4K. α9 AI. Dolby Vision IQ. Lo más inmersivo del año.',      3499, null, 'new',   'ink',     16),
  ('p-frame-55',      'The Frame 55"',          'Samsung',   'home',      'TV que cuando se apaga, se convierte en arte.',              2349, 2599, 'offer', 'cream',   17),
  ('p-dyson-v15',     'V15 Detect',             'Dyson',     'home',      'Aspiradora inalámbrica con láser. 60min de batería.',         1299, null, null,    'sun',     18),
  ('p-hue',           'Hue Starter Kit',        'Philips',   'home',      '3 bombillas color + puente. Tu casa, en tus manos.',           349, null, null,    'lilac',   19),
  ('p-ps5',           'PlayStation 5 Slim',     'Sony',      'gaming',    'Generación actual, más delgada. Lector de discos.',            949, null, null,    'slate',   20),
  ('p-switch',        'Switch OLED',            'Nintendo',  'gaming',    'Pantalla OLED 7". En casa o de viaje.',                        719, null, null,    'ember',   21),
  ('p-xbox',          'Xbox Series X',          'Microsoft', 'gaming',    '1TB. 4K nativo, 120fps en juegos compatibles.',                949, null, null,    'graphite', 22)
on conflict (id) do nothing;

-- ── Row Level Security ────────────────────────────────────────

alter table public.products   enable row level security;
alter table public.categories enable row level security;
alter table public.users      enable row level security;
alter table public.config     enable row level security;

-- Products: lectura y escritura públicas (el admin panel usa contraseña de app)
create policy "products_select" on public.products for select using (true);
create policy "products_insert" on public.products for insert with check (true);
create policy "products_update" on public.products for update using (true);
create policy "products_delete" on public.products for delete using (true);

-- Categories
create policy "categories_select" on public.categories for select using (true);
create policy "categories_insert" on public.categories for insert with check (true);
create policy "categories_update" on public.categories for update using (true);
create policy "categories_delete" on public.categories for delete using (true);

-- Users: solo insertar (no se pueden leer datos por privacidad)
create policy "users_insert" on public.users for insert with check (true);
create policy "users_select_own" on public.users for select using (true); -- login por teléfono requiere lectura

-- Config: lectura y escritura públicas
create policy "config_select" on public.config for select using (true);
create policy "config_insert" on public.config for insert with check (true);
create policy "config_update" on public.config for update using (true);

-- ── Storage (ejecutar después de crear el bucket) ─────────────
-- 1. Ve a Supabase Dashboard → Storage → Create Bucket
-- 2. Nombre: aruba-images
-- 3. Marca "Public bucket" ✓
-- 4. Luego ejecuta las políticas de storage:

create policy "storage_select" on storage.objects for select using (bucket_id = 'aruba-images');
create policy "storage_insert" on storage.objects for insert with check (bucket_id = 'aruba-images');
create policy "storage_update" on storage.objects for update using (bucket_id = 'aruba-images');
create policy "storage_delete" on storage.objects for delete using (bucket_id = 'aruba-images');
