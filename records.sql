-- ============================================================
-- CIS761 PC Builder Database - records.sql
-- Populates all tables with realistic data.
--
-- Table sizes:
--   Users         : 20 rows
--   PC_Parts      : 70 rows  (10 CPU, 8 PSU, 8 RAM, 12 GPU,
--                              10 Motherboard, 10 Case, 12 Cooler)
--   PCs           : 30 rows  (mix of complete and partial builds)
--   Favorite_Parts: ~45 rows
--   Part_Review   : ~80 rows
-- ============================================================

-- ============================================================
-- USERS (20)
-- ============================================================
INSERT INTO Users (user_id, email, username, created_on) VALUES
(1,  'alice.johnson@email.com',   'AliceJ',       '2020-03-14 09:00:00'),
(2,  'bob.smith@email.com',       'BobTheBuilder', '2020-07-22 14:30:00'),
(3,  'carol.white@email.com',     'CarolW',        '2021-01-05 08:15:00'),
(4,  'david.lee@email.com',       'DaveLee',       '2021-04-17 11:45:00'),
(5,  'emily.clark@email.com',     'EmilyC',        '2021-06-30 16:20:00'),
(6,  'frank.miller@email.com',    'FrankM',        '2021-09-12 10:00:00'),
(7,  'grace.hall@email.com',      'GraceH',        '2022-02-01 07:30:00'),
(8,  'henry.allen@email.com',     'HenryA',        '2022-04-19 13:00:00'),
(9,  'iris.young@email.com',      'IrisY',         '2022-07-08 15:45:00'),
(10, 'jake.turner@email.com',     'JakeT',         '2022-10-23 09:30:00'),
(11, 'karen.king@email.com',      'KarenK',        '2023-01-11 12:00:00'),
(12, 'leo.scott@email.com',       'LeoS',          '2023-03-27 17:00:00'),
(13, 'mia.green@email.com',       'MiaG',          '2023-05-14 08:45:00'),
(14, 'noah.baker@email.com',      'NoahB',         '2023-07-02 14:15:00'),
(15, 'olivia.adams@email.com',    'OliviaA',       '2023-08-20 11:30:00'),
(16, 'peter.nelson@email.com',    'PeterN',        '2023-10-05 10:45:00'),
(17, 'quinn.carter@email.com',    'QuinnC',        '2023-11-18 16:00:00'),
(18, 'rachel.evans@email.com',    'RachelE',       '2024-01-07 09:15:00'),
(19, 'sam.thomas@email.com',      'SamT',          '2024-03-22 13:30:00'),
(20, 'tina.harris@email.com',     'TinaH',         '2024-06-10 15:00:00');

SELECT setval('users_user_id_seq', 20);

-- ============================================================
-- PC_PARTS master table (70 rows)
-- IDs 1-10   : CPUs
-- IDs 11-18  : PSUs
-- IDs 19-26  : RAM kits
-- IDs 27-38  : GPUs
-- IDs 39-48  : Motherboards
-- IDs 49-58  : Cases
-- IDs 59-70  : Coolers
-- ============================================================

-- ---------- CPUs (part_id 1-10) ----------
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(1,  'Intel',  'Core i9-14900K',   '2023-10-17', 549.99, '24-core desktop flagship'),
(2,  'Intel',  'Core i7-14700K',   '2023-10-17', 379.99, '20-core mainstream powerhouse'),
(3,  'Intel',  'Core i5-14600K',   '2023-10-17', 239.99, '14-core mid-range CPU'),
(4,  'Intel',  'Core i5-13400F',   '2023-01-05', 179.99, 'Budget Intel with no iGPU'),
(5,  'AMD',    'Ryzen 9 7950X',    '2022-09-27', 699.99, 'AMD flagship 16-core desktop CPU'),
(6,  'AMD',    'Ryzen 9 7900X',    '2022-09-27', 449.99, '12-core high-end AMD CPU'),
(7,  'AMD',    'Ryzen 7 7700X',    '2022-09-27', 299.99, '8-core AMD mainstream CPU'),
(8,  'AMD',    'Ryzen 5 7600X',    '2022-09-27', 199.99, '6-core AMD budget-friendly CPU'),
(9,  'AMD',    'Ryzen 5 7600',     '2023-01-14', 169.99, '6-core non-X AMD budget CPU'),
(10, 'Intel',  'Core i3-13100',    '2023-01-05', 119.99, 'Budget quad-core Intel CPU');

-- ---------- PSUs (part_id 11-18) ----------
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(11, 'Corsair',      'RM1000x 1000W',       '2021-06-01', 189.99, 'Fully modular 80+ Gold PSU'),
(12, 'Corsair',      'RM850x 850W',         '2021-06-01', 149.99, 'Fully modular 80+ Gold PSU'),
(13, 'EVGA',         'SuperNOVA 850 G6',    '2022-03-15', 129.99, 'Compact fully modular 850W'),
(14, 'SeaSonic',     'Focus GX-750',        '2020-11-01', 109.99, 'Fully modular 80+ Gold 750W'),
(15, 'be quiet!',    'Straight Power 11 650W','2019-08-01',99.99, 'Semi-modular 80+ Platinum'),
(16, 'Thermaltake',  'Toughpower GF1 850W', '2021-02-01', 119.99, 'Fully modular 80+ Gold'),
(17, 'NZXT',         'C850 850W',           '2022-09-01', 139.99, 'Fully modular 80+ Gold'),
(18, 'Cooler Master','MWE Gold 750W',       '2020-05-01',  79.99, 'Non-modular 80+ Gold budget PSU');

-- ---------- RAM (part_id 19-26) ----------
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(19, 'G.Skill',   'Trident Z5 RGB 32GB DDR5-6000',  '2022-02-01', 109.99, '2x16GB DDR5 flagship kit'),
(20, 'G.Skill',   'Ripjaws V 32GB DDR4-3600',       '2020-05-01',  69.99, '2x16GB DDR4 reliable kit'),
(21, 'Corsair',   'Dominator Platinum 64GB DDR5-5600','2022-06-01',229.99, '2x32GB DDR5 high-capacity'),
(22, 'Corsair',   'Vengeance LPX 16GB DDR4-3200',   '2019-01-01',  44.99, '2x8GB DDR4 budget kit'),
(23, 'Kingston',  'Fury Beast 32GB DDR4-3600',       '2021-03-01',  74.99, '2x16GB DDR4 value kit'),
(24, 'Kingston',  'Fury Renegade 32GB DDR5-6400',    '2023-01-01', 129.99, '2x16GB DDR5 fast kit'),
(25, 'TeamGroup', 'T-Force Delta 16GB DDR4-3600',    '2021-07-01',  49.99, '2x8GB DDR4 with RGB'),
(26, 'Crucial',   'Pro 32GB DDR5-5600',              '2022-10-01',  89.99, '2x16GB DDR5 value DDR5');

-- ---------- GPUs (part_id 27-38) ----------
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(27, 'NVIDIA', 'GeForce RTX 4090',        '2022-10-12', 1599.99, 'Flagship NVIDIA Ada GPU'),
(28, 'NVIDIA', 'GeForce RTX 4080 Super',  '2024-01-08',  999.99, 'High-end Ada GPU refresh'),
(29, 'NVIDIA', 'GeForce RTX 4070 Ti Super','2024-01-08',  799.99, 'Upper mid-range Ada GPU'),
(30, 'NVIDIA', 'GeForce RTX 4070 Super',  '2024-01-08',  599.99, 'Mid-range Ada GPU sweet spot'),
(31, 'NVIDIA', 'GeForce RTX 4060 Ti',     '2023-05-24',  399.99, 'Budget-friendly Ada GPU'),
(32, 'NVIDIA', 'GeForce RTX 4060',        '2023-06-29',  299.99, '1080p Ada gaming GPU'),
(33, 'AMD',    'Radeon RX 7900 XTX',      '2022-12-13',  999.99, 'AMD flagship RDNA3 GPU'),
(34, 'AMD',    'Radeon RX 7900 XT',       '2022-12-13',  849.99, 'High-end AMD RDNA3 GPU'),
(35, 'AMD',    'Radeon RX 7800 XT',       '2023-09-06',  499.99, 'Mid-range AMD RDNA3 GPU'),
(36, 'AMD',    'Radeon RX 7700 XT',       '2023-09-06',  449.99, 'Lower mid-range RDNA3 GPU'),
(37, 'AMD',    'Radeon RX 7600',          '2023-05-25',  269.99, 'Budget AMD RDNA3 GPU'),
(38, 'Intel',  'Arc A770 16GB',           '2022-10-12',  349.99, 'Intel flagship Arc GPU');

-- ---------- Motherboards (part_id 39-48) ----------
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(39, 'ASUS',    'ROG Maximus Z790 Hero',     '2022-10-20', 629.99, 'Z790 flagship for LGA1700'),
(40, 'ASUS',    'Prime Z790-P WiFi',         '2022-10-20', 199.99, 'Solid mid-range Z790 board'),
(41, 'MSI',     'MEG Z790 Ace',              '2022-10-20', 499.99, 'High-end MSI Z790 board'),
(42, 'MSI',     'MAG B760M Mortar WiFi',     '2022-12-01', 169.99, 'mATX B760 budget board'),
(43, 'Gigabyte','AORUS Master X670E',        '2022-09-27', 499.99, 'Flagship AM5 board'),
(44, 'Gigabyte','B650 AORUS Elite AX',       '2022-09-27', 219.99, 'Mid-range AM5 B650 board'),
(45, 'ASUS',    'ROG Crosshair X670E Hero',  '2022-09-27', 629.99, 'ASUS flagship AM5 board'),
(46, 'MSI',     'MPG X670E Carbon WiFi',     '2022-09-27', 399.99, 'High-end MSI AM5 board'),
(47, 'ASRock',  'B650M PG Riptide',          '2022-11-01', 149.99, 'Budget mATX AM5 board'),
(48, 'Gigabyte','Z790 AORUS Elite AX',       '2022-10-20', 259.99, 'Mainstream Z790 board');

-- ---------- Cases (part_id 49-58) ----------
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(49, 'Lian Li',      'PC-O11 Dynamic EVO',    '2022-06-01', 149.99, 'Dual-chamber ATX showcase case'),
(50, 'Fractal Design','Torrent',              '2021-10-01', 189.99, 'High-airflow ATX case'),
(51, 'NZXT',         'H7 Flow',               '2022-08-01', 139.99, 'Mid-tower ATX airflow case'),
(52, 'Corsair',      'iCUE 5000X RGB',        '2021-03-01', 174.99, 'Large ATX RGB showcase case'),
(53, 'be quiet!',    'Dark Base 700',         '2018-05-01', 169.99, 'Silent ATX mid-tower'),
(54, 'Lian Li',      'PC-O11 Air Mini',       '2021-07-01', 109.99, 'mATX version of O11'),
(55, 'NZXT',         'H510 Flow',             '2021-09-01',  89.99, 'Compact mid-tower ATX case'),
(56, 'Fractal Design','Pop Mini Air',         '2022-04-01',  84.99, 'mATX airflow budget case'),
(57, 'Cooler Master','HAF 700 EVO',           '2022-06-01', 299.99, 'Full tower ATX enthusiast case'),
(58, 'Phanteks',     'Eclipse P400A',         '2020-01-01',  89.99, 'Budget ATX mid-tower case');

-- ---------- Coolers (part_id 59-70) ----------
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(59, 'Noctua',       'NH-D15',                '2014-07-01',  99.99, 'Dual-tower air cooler'),
(60, 'Noctua',       'NH-U12A',               '2019-04-01',  79.99, 'Single-tower slim air cooler'),
(61, 'be quiet!',    'Dark Rock Pro 4',       '2019-01-01',  74.99, 'Dual-tower silent air cooler'),
(62, 'Cooler Master','Hyper 212 Black Edition','2019-11-01',  34.99, 'Budget single-tower air cooler'),
(63, 'Arctic',       'Liquid Freezer II 360', '2020-06-01', 109.99, '360mm AIO liquid cooler'),
(64, 'Corsair',      'iCUE H150i Elite LCD',  '2022-08-01', 239.99, '360mm AIO with LCD display'),
(65, 'NZXT',         'Kraken X63',            '2020-11-01', 149.99, '280mm AIO liquid cooler'),
(66, 'NZXT',         'Kraken 240',            '2023-03-01', 119.99, '240mm AIO liquid cooler'),
(67, 'EK',           'AIO Basic 240',         '2021-04-01',  99.99, 'Entry-level 240mm AIO'),
(68, 'DeepCool',     'AK620',                 '2022-02-01',  49.99, 'Budget dual-tower air cooler'),
(69, 'Thermalright', 'Peerless Assassin 120 SE','2022-05-01',35.99, 'Budget dual-tower air cooler'),
(70, 'Scythe',       'Fuma 3',                '2023-08-01',  59.99, 'Asymmetric dual-tower cooler');

SELECT setval('pc_parts_part_id_seq', 70);

-- ============================================================
-- CPU subtypes (part_id 1-10)
-- Sockets: LGA1700 (Intel 12/13/14th gen), AM5 (AMD Ryzen 7000)
-- ============================================================
INSERT INTO CPU (part_id, socket, thermal_design_power, core_count, base_clock, thread_count, boost_clock) VALUES
(1,  'LGA1700', 125, 24, 3.2, 32, 6.0),
(2,  'LGA1700', 125, 20, 3.4, 28, 5.6),
(3,  'LGA1700', 125, 14, 3.5, 20, 5.3),
(4,  'LGA1700',  65, 10, 2.5, 16, 4.6),
(5,  'AM5',     170, 16, 4.5, 32, 5.7),
(6,  'AM5',     170, 12, 4.7, 24, 5.6),
(7,  'AM5',     105,  8, 4.7, 16, 5.4),
(8,  'AM5',     105,  6, 4.7, 12, 5.3),
(9,  'AM5',      65,  6, 3.8, 12, 5.1),
(10, 'LGA1700',  60,  4, 3.4,  8, 4.5);

-- ============================================================
-- PSU subtypes (part_id 11-18)
-- ============================================================
INSERT INTO PSU (part_id, modular, wattage, efficiency) VALUES
(11, 'Full',       1000, '80+ Gold'),
(12, 'Full',        850, '80+ Gold'),
(13, 'Full',        850, '80+ Gold'),
(14, 'Full',        750, '80+ Gold'),
(15, 'Semi',        650, '80+ Plat'),
(16, 'Full',        850, '80+ Gold'),
(17, 'Full',        850, '80+ Gold'),
(18, 'Non-Modular', 750, '80+ Gold');

-- ============================================================
-- RAM subtypes (part_id 19-26)
-- ============================================================
INSERT INTO RAM (part_id, ram_type, num_of_sticks, capacity, speed) VALUES
(19, 'DDR5', 2, 32, 6000),
(20, 'DDR4', 2, 32, 3600),
(21, 'DDR5', 2, 64, 5600),
(22, 'DDR4', 2, 16, 3200),
(23, 'DDR4', 2, 32, 3600),
(24, 'DDR5', 2, 32, 6400),
(25, 'DDR4', 2, 16, 3600),
(26, 'DDR5', 2, 32, 5600);

-- ============================================================
-- GPU subtypes (part_id 27-38)
-- ============================================================
INSERT INTO GPU (part_id, vram, chipset, length_mm, power_connectors) VALUES
(27, 24, 'AD102',  336, '3x8-pin'),
(28, 16, 'AD103',  340, '3x8-pin'),
(29, 16, 'AD103',  337, '3x8-pin'),
(30, 12, 'AD104',  285, '2x8-pin'),
(31, 16, 'AD104',  240, '1x16-pin'),
(32,  8, 'AD106',  240, '1x8-pin'),
(33, 24, 'Navi31', 287, '2x8-pin'),
(34, 20, 'Navi31', 276, '2x8-pin'),
(35, 16, 'Navi32', 267, '2x8-pin'),
(36, 12, 'Navi32', 245, '2x8-pin'),
(37,  8, 'Navi33', 202, '1x8-pin'),
(38, 16, 'ACM-G10',322, '2x8-pin');

-- ============================================================
-- Motherboard subtypes (part_id 39-48)
-- Socket / RAM type must match CPU / RAM to support compatibility queries
-- ============================================================
INSERT INTO Motherboard (part_id, socket, chipset, ram_type, form_factor, max_ram) VALUES
(39, 'LGA1700', 'Z790',  'DDR5', 'ATX',  128),
(40, 'LGA1700', 'Z790',  'DDR5', 'ATX',   96),
(41, 'LGA1700', 'Z790',  'DDR5', 'ATX',  192),
(42, 'LGA1700', 'B760',  'DDR4', 'mATX',  64),
(43, 'AM5',     'X670E', 'DDR5', 'ATX',  128),
(44, 'AM5',     'B650',  'DDR5', 'ATX',  128),
(45, 'AM5',     'X670E', 'DDR5', 'ATX',  128),
(46, 'AM5',     'X670E', 'DDR5', 'ATX',  128),
(47, 'AM5',     'B650',  'DDR5', 'mATX',  64),
(48, 'LGA1700', 'Z790',  'DDR5', 'ATX',  128);

-- ============================================================
-- Case subtypes (part_id 49-58)
-- max_gpu_size in mm; form_factor must match motherboard form_factor
-- ============================================================
INSERT INTO PC_Case (part_id, max_gpu_size, form_factor, color) VALUES
(49, 420, 'ATX',  'Black'),
(50, 467, 'ATX',  'Black'),
(51, 365, 'ATX',  'White'),
(52, 420, 'ATX',  'Black'),
(53, 435, 'ATX',  'Black'),
(54, 360, 'mATX', 'Black'),
(55, 381, 'ATX',  'Black'),
(56, 350, 'mATX', 'Black'),
(57, 490, 'ATX',  'Black'),
(58, 360, 'ATX',  'Black');

-- ============================================================
-- Cooler subtypes (part_id 59-70)
-- socket_type: which CPU sockets are supported
-- ============================================================
INSERT INTO Cooler (part_id, cooler_type, socket_type) VALUES
(59, 'Air',     'LGA1700,AM5,AM4'),
(60, 'Air',     'LGA1700,AM5,AM4'),
(61, 'Air',     'LGA1700,AM5,AM4'),
(62, 'Air',     'LGA1700,AM5,AM4'),
(63, 'AIO 360', 'LGA1700,AM5,AM4'),
(64, 'AIO 360', 'LGA1700,AM5,AM4'),
(65, 'AIO 280', 'LGA1700,AM5,AM4'),
(66, 'AIO 240', 'LGA1700,AM5,AM4'),
(67, 'AIO 240', 'LGA1700,AM5,AM4'),
(68, 'Air',     'LGA1700,AM5,AM4'),
(69, 'Air',     'LGA1700,AM5,AM4'),
(70, 'Air',     'LGA1700,AM5,AM4');

-- ============================================================
-- PCs (30 builds)
-- Complete builds (all 7 parts): pc_id 1-18
-- Partial builds (at least 1 null): pc_id 19-30
-- Users 18, 19, 20 intentionally have NO builds (for Query 9)
-- ============================================================
INSERT INTO PCs (pc_id, name, user_id, cpu, psu, ram_kit, gpu, motherboard, pc_case, cooler, created_on) VALUES
-- Complete builds --
(1,  'AliceJ Gaming Beast',       1,  1,  11, 19, 27, 39, 49, 63, '2023-11-01'),
(2,  'BobTheBuilder Workstation', 2,  5,  11, 21, 33, 43, 49, 64, '2023-12-15'),
(3,  'CarolW Mid-Range Gaming',   3,  7,  14, 20, 30, 44, 50, 68, '2024-01-10'),
(4,  'DaveLee Budget Rig',        4,  9,  18, 22, 37, 47, 56, 69, '2024-02-05'),
(5,  'EmilyC Content Creator',    5,  5,  11, 21, 27, 43, 52, 63, '2024-01-20'),
(6,  'FrankM Streaming PC',       6,  2,  12, 20, 28, 40, 51, 65, '2023-10-01'),
(7,  'GraceH Silent Builder',     7,  7,  15, 23, 35, 44, 53, 61, '2024-03-01'),
(8,  'HenryA 4K Gaming',          8,  1,  11, 19, 29, 39, 57, 64, '2024-01-25'),
(9,  'IrisY Compact Powerhouse',  9,  8,  17, 24, 31, 42, 54, 66, '2024-02-14'),
(10, 'JakeT Ultra Build',        10,  1,  11, 19, 27, 41, 57, 63, '2024-03-10'),
(11, 'KarenK Daily Driver',      11,  3,  13, 26, 30, 40, 55, 68, '2024-01-30'),
(12, 'LeoS RDNA3 Machine',       12,  6,  16, 20, 33, 46, 50, 60, '2024-02-20'),
(13, 'MiaG Entry Gaming',        13, 10,  18, 22, 32, 47, 58, 62, '2024-03-05'),
(14, 'NoahB High-FPS 1440p',     14,  7,  14, 23, 29, 44, 50, 68, '2024-02-01'),
(15, 'PeterN HEDT Replacement',  15,  5,  16, 21, 28, 45, 52, 63, '2023-11-15'),
(16, 'QuinnC Ryzen 5 Budget',    16,  9,  18, 26, 37, 47, 56, 69, '2024-03-20'),
(17, 'RachelE Intel Gaming',     17,  2,  12, 19, 30, 48, 51, 66, '2024-04-01'),
(18, 'AliceJ Secondary Rig',      1,  3,  13, 20, 31, 40, 55, 70, '2024-04-15'),

-- Partial builds --
(19, 'BobTheBuilder Work-in-Progress', 2, 5, 11, 21, NULL, 43, NULL, 64,  '2024-04-20'),
(20, 'CarolW Indecisive Build',        3, 7, NULL, 20, 35, 44, 50,  NULL, '2024-02-28'),
(21, 'DaveLee Just Started',           4, NULL,18,NULL,NULL,NULL,NULL,NULL,'2024-05-01'),
(22, 'FrankM GPU Hunting',             6, 2, 12, NULL, NULL, 40, 51,  65, '2024-03-15'),
(23, 'GraceH Mobo Picked',             7, NULL,NULL,NULL,35,  44, 50, NULL,'2024-03-22'),
(24, 'HenryA Case and PSU',            8, NULL,11,NULL,NULL,NULL,57, NULL, '2024-04-05'),
(25, 'IrisY Almost Done',              9, 8, 17, 24, 31, 42,  NULL, 66,  '2024-04-10'),
(26, 'JakeT Budget Start',            10, 10,18, 22, NULL,NULL,  58, 62,  '2024-04-25'),
(27, 'KarenK Upgrade Prep',           11, NULL,13,NULL,30, 40,  55, NULL, '2024-05-01'),
(28, 'LeoS AMD Fanboy Draft',         12, 5, 16,NULL,NULL,43,   50,  60, '2024-05-05'),
(29, 'MiaG Wishlist',                 13, NULL,NULL,NULL,32,NULL,NULL,62,  '2024-05-08'),
(30, 'NoahB Hasty Draft',             14, 7, 14, 23,NULL,44,    50,  68, '2024-05-09');

SELECT setval('pcs_pc_id_seq', 30);

-- ============================================================
-- FAVORITE_PARTS (~45 rows)
-- ============================================================
INSERT INTO Favorite_Parts (user_id, part_id) VALUES
-- Alice
(1, 27),(1, 1),(1, 39),(1, 63),(1, 19),
-- Bob
(2, 5),(2, 33),(2, 43),(2, 64),(2, 21),
-- Carol
(3, 7),(3, 35),(3, 44),(3, 50),(3, 20),
-- Dave
(4, 9),(4, 37),(4, 47),(4, 56),(4, 22),
-- Emily
(5, 5),(5, 27),(5, 52),(5, 21),
-- Frank
(6, 2),(6, 28),(6, 40),(6, 12),
-- Grace
(7, 7),(7, 35),(7, 61),(7, 23),
-- Henry
(8, 1),(8, 29),(8, 57),(8, 64),
-- Iris
(9, 8),(9, 31),(9, 54),(9, 66),
-- Jake
(10,1),(10,27),(10,41),(10,63),
-- Karen
(11,3),(11,30),(11,40),(11,68),
-- Leo
(12,6),(12,33),(12,46),(12,60),
-- Mia
(13,10),(13,32),(13,47),(13,62),
-- Noah
(14,7),(14,29),(14,44),(14,68),
-- Peter
(15,5),(15,28),(15,45),(15,63),
-- Quinn
(16,9),(16,37),(16,47),(16,69),
-- Rachel
(17,2),(17,30),(17,48),(17,65),
-- Sam (no build, but has favorites)
(19,27),(19,33),(19,63);

-- ============================================================
-- PART_REVIEW (~80 rows)
-- ratings 1-5; diverse spread for interesting aggregation queries
-- ============================================================
INSERT INTO Part_Review (user_id, part_id, review_time, rating, comment) VALUES
-- RTX 4090 reviews (part 27)
(1,  27, '2023-12-01 10:00:00', 5, 'Absolute beast, handles everything I throw at it.'),
(2,  27, '2023-12-15 14:30:00', 5, 'Incredible performance, worth every penny if you can afford it.'),
(5,  27, '2024-01-22 09:15:00', 4, 'Amazing card but runs very hot under full load.'),
(8,  27, '2024-01-26 11:00:00', 5, 'Best GPU money can buy right now.'),
(10, 27, '2024-03-12 16:45:00', 5, 'Ridiculous fps at 4K. Love it.'),

-- RTX 4080 Super reviews (part 28)
(6,  28, '2024-02-01 12:00:00', 5, 'Barely any sacrifice vs 4090 for much less money.'),
(14, 28, '2024-03-01 09:30:00', 4, 'Great card but had to tweak power limits.'),
(15, 28, '2024-02-10 15:00:00', 5, 'Superb for content creation and gaming.'),

-- RTX 4070 Ti Super reviews (part 29)
(8,  29, '2024-02-05 10:30:00', 5, 'The best value in high-end cards right now.'),
(11, 29, '2024-02-15 13:45:00', 4, 'Solid 1440p performer, slight coil whine.'),
(14, 29, '2024-02-20 08:00:00', 5, 'Handles anything at 1440p ultra without breaking a sweat.'),

-- RTX 4070 Super reviews (part 30)
(3,  30, '2024-02-01 11:00:00', 5, 'Best value GPU I have ever bought.'),
(11, 30, '2024-02-20 14:00:00', 4, 'Great performance, drivers could be better.'),
(17, 30, '2024-04-05 10:00:00', 5, 'Perfect 1440p card for the price.'),

-- RTX 4060 Ti reviews (part 31)
(9,  31, '2024-03-01 09:00:00', 3, 'Performance is fine but 8GB VRAM feels limiting.'),
(18, 31, '2024-02-25 16:30:00', 4, 'Good 1080p card if you catch it on sale.'),

-- RTX 4060 reviews (part 32)
(13, 32, '2024-03-10 10:00:00', 4, 'Solid 1080p card, very power efficient.'),
(13, 32, '2024-04-15 12:00:00', 1, 'Had to RMA it after 1 month. Quality control issue.'),

-- RX 7900 XTX reviews (part 33)
(2,  33, '2023-12-20 13:00:00', 5, 'Trades blows with 4090 in rasterization for less money.'),
(5,  33, '2024-01-28 17:00:00', 4, 'Great performance, but driver stability can be iffy.'),
(12, 33, '2024-02-22 11:30:00', 5, 'Fantastic at 4K, especially in DX11 titles.'),

-- RX 7900 XT reviews (part 34)
(12, 34, '2024-02-22 12:00:00', 4, 'Good step below the XTX, solid value.'),

-- RX 7800 XT reviews (part 35)
(3,  35, '2024-01-15 08:30:00', 5, 'Best mid-range GPU right now. Runs cool and quiet.'),
(7,  35, '2024-03-05 15:00:00', 4, 'Great 1440p card, open-source drivers are a bonus on Linux.'),
(14, 35, '2024-03-15 10:30:00', 4, 'Solid card, wish it had more VRAM for future proofing.'),

-- RX 7700 XT reviews (part 36)
(7,  36, '2024-02-10 09:45:00', 3, 'Decent card but priced a bit high at launch.'),

-- RX 7600 reviews (part 37)
(4,  37, '2024-02-10 14:00:00', 4, 'Great budget 1080p card, runs cool.'),
(13, 37, '2024-03-10 09:30:00', 4, 'Excellent value for a tight budget.'),
(16, 37, '2024-03-25 11:00:00', 3, 'Does the job but cannot max out newer games.'),

-- Arc A770 reviews (part 38)
(10, 38, '2024-01-15 13:00:00', 3, 'Good value but driver maturity needs work.'),
(17, 38, '2024-04-10 15:30:00', 2, 'Struggling drivers really hold it back.'),

-- CPU Reviews
-- i9-14900K (part 1)
(1,  1, '2023-11-05 10:00:00', 5, 'Fastest desktop CPU for single-threaded tasks.'),
(8,  1, '2024-01-27 14:00:00', 4, 'Great but runs hot even with a 360mm AIO.'),
(10, 1, '2024-03-11 09:00:00', 5, 'Overkill for gaming but I love it.'),

-- i7-14700K (part 2)
(6,  2, '2023-11-01 11:00:00', 5, 'Perfect balance of cores and price.'),
(17, 2, '2025-08-08 10:00:00', 1, 'Burned out my Z790 board from faulty microcode, do not buy.'),

-- Ryzen 9 7950X (part 5)
(2,  5, '2023-01-10 12:00:00', 5, 'Incredible for video rendering. Workstation beast.'),
(5,  5, '2024-01-22 16:00:00', 5, 'Best content creator CPU on the market.'),
(15, 5, '2024-02-01 10:00:00', 4, 'Power consumption is high but performance justifies it.'),

-- Ryzen 5 7600 (part 9)
(4,  9, '2024-02-08 09:00:00', 5, 'Best budget CPU you can buy. Incredible gaming performance.'),
(16, 9, '2024-03-22 14:00:00', 4, 'Great chip for the money. Runs cool too.'),

-- PSU Reviews
-- Corsair RM1000x (part 11)
(1,  11, '2024-01-05 11:00:00', 5, 'Dead silent and rock solid. Worth the premium.'),
(2,  11, '2024-01-08 13:00:00', 5, 'Fantastic PSU, zero coil whine.'),
(8,  11, '2024-02-01 12:00:00', 4, 'Great but overpriced vs competitors.'),

-- Cooler Master MWE Gold 750W (part 18)
(4,  18, '2024-02-07 10:00:00', 2, 'Coil whine is noticeable under load.'),
(13, 18, '2024-03-07 09:00:00', 3, 'Does the job but cable management is annoying non-modular.'),

-- Motherboard Reviews
-- ASUS ROG Maximus Z790 Hero (part 39)
(1,  39, '2023-11-10 10:00:00', 5, 'BIOS is the best in the industry. VRM is overkill good.'),
(8,  39, '2024-01-28 15:00:00', 5, 'No complaints. Absolutely premium board.'),

-- Gigabyte B650 AORUS Elite AX (part 44)
(3,  44, '2024-01-12 09:30:00', 4, 'Great mid-range AM5 board. Good value.'),
(7,  44, '2024-03-08 11:00:00', 4, 'Solid feature set for the price.'),
(14, 44, '2024-02-05 14:00:00', 5, 'Best mid-range AM5 option in my opinion.'),

-- Cooler Reviews
-- Noctua NH-D15 (part 59)
(1,  59, '2023-11-08 10:30:00', 5, 'The air cooling king. Keeps my i9 below 80C.'),
(7,  59, '2024-01-20 13:00:00', 5, 'Noctua quality as expected. Silent and effective.'),

-- Arctic Liquid Freezer II 360 (part 63)
(1,  63, '2023-12-01 09:00:00', 5, 'Best value 360mm AIO available. Outstanding performance.'),
(2,  63, '2024-01-10 14:00:00', 5, 'Absolutely destroys any air cooler at this price point.'),
(5,  63, '2024-01-25 11:00:00', 4, 'Slightly bulky pump head but performance is unmatched.'),
(10, 63, '2024-03-14 16:00:00', 5, 'Keeps my i9 at under 75C at full load.'),

-- Hyper 212 Black (part 62)
(4,  62, '2024-02-10 09:00:00', 4, 'Great budget cooler. Solid for 65W CPUs.'),
(13, 62, '2024-03-07 11:30:00', 4, 'Can not beat it for the price.'),

-- Case Reviews
-- Lian Li O11 Dynamic EVO (part 49)
(1,  49, '2023-11-15 10:00:00', 5, 'Best looking case on the market. Great airflow too.'),
(2,  49, '2024-01-15 12:30:00', 5, 'Dual-chamber design makes cable management a breeze.'),
(5,  49, '2024-01-23 11:00:00', 4, 'Beautiful case but expensive and heavy.'),

-- Fractal Torrent (part 50)
(3,  50, '2024-01-18 10:00:00', 5, 'Best airflow case I have ever used. Temps dropped 10C.'),
(7,  50, '2024-03-08 13:00:00', 4, 'Excellent airflow, plain looks but that is fine with me.'),

-- RAM Reviews
-- G.Skill Trident Z5 (part 19)
(1,  19, '2023-11-12 11:30:00', 5, 'Easy to get to 6000MHz on EXPO. Stunning RGB.'),
(8,  19, '2024-01-29 14:00:00', 5, 'No issues, runs at rated speed out of the box.');
