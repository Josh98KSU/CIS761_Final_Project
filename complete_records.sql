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
(15, 'Semi',        650, '80+ Platinum'),
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
(17, 'RachelE Intel Gaming',      17, 2,  12, 19, 30, 48, 51, 66, '2024-04-01'),
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
(17, 2, '2025-08-08 10:00:00', 1, 'Burned out my board'),

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

-- PC_Parts Table Data
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(71, 'AMD', 'Ryzen 9 9950X', '2024-07-31', 649.99, 'Zen 5 flagship with 16 cores and high clock speeds.'),
(72, 'AMD', 'Ryzen 9 9900X', '2024-07-31', 499.00, 'Zen 5 high-end 12-core processor for productivity.'),
(73, 'AMD', 'Ryzen 7 9700X', '2024-08-08', 359.00, 'Efficient Zen 5 8-core CPU for gaming and creative work.'),
(74, 'AMD', 'Ryzen 5 9600X', '2024-08-08', 279.00, 'Mainstream Zen 5 6-core processor.'),
(75, 'AMD', 'Ryzen 9 9950X3D', '2025-01-15', 749.00, 'Zen 5 flagship with 3D V-Cache for ultimate gaming.'),
(76, 'AMD', 'Ryzen 7 9800X3D', '2024-11-07', 479.00, 'The world''s fastest gaming processor with 2nd Gen 3D V-Cache.'),
(77, 'AMD', 'Ryzen 5 9600X3D', '2025-03-20', 329.00, 'Mid-range gaming powerhouse with 3D V-Cache.'),
(78, 'AMD', 'Ryzen 9 7950X', '2022-09-27', 549.99, 'Previous gen Zen 4 flagship for heavy multi-threading.'),
(79, 'AMD', 'Ryzen 9 7950X3D', '2023-02-28', 699.00, 'Zen 4 16-core with 3D V-Cache.'),
(80, 'AMD', 'Ryzen 7 7800X3D', '2023-04-06', 449.00, 'Highly popular Zen 4 gaming processor.'),
(81, 'AMD', 'Ryzen 9 7900X', '2022-09-27', 439.00, 'Zen 4 12-core workstation-grade CPU.'),
(82, 'AMD', 'Ryzen 7 7700X', '2022-09-27', 329.00, 'Zen 4 8-core gaming and productivity CPU.'),
(83, 'AMD', 'Ryzen 5 7600X', '2022-09-27', 249.00, 'Entry-level Zen 4 desktop processor.'),
(84, 'AMD', 'Ryzen 7 8700G', '2024-01-31', 329.00, 'Zen 4 APU with powerful Radeon 780M integrated graphics.'),
(85, 'AMD', 'Ryzen 5 8600G', '2024-01-31', 229.00, 'Zen 4 APU for budget gaming builds.'),
(86, 'AMD', 'Ryzen 9 5950X', '2020-11-05', 499.00, 'Legendary AM4 flagship with 16 cores.'),
(87, 'AMD', 'Ryzen 9 5900X', '2020-11-05', 349.00, 'High-performance Zen 3 12-core CPU.'),
(88, 'AMD', 'Ryzen 7 5800X3D', '2022-04-20', 399.00, 'The CPU that brought 3D V-Cache to the mainstream.'),
(89, 'AMD', 'Ryzen 7 5700X3D', '2024-01-31', 249.00, 'Affordable 3D V-Cache upgrade for AM4 users.'),
(90, 'AMD', 'Ryzen 5 5600X', '2020-11-05', 159.00, 'Classic 6-core Zen 3 processor.'),
(91, 'Intel', 'Core Ultra 9 285K', '2024-10-24', 589.00, 'Arrow Lake flagship with 24 cores (8P + 16E).'),
(92, 'Intel', 'Core Ultra 7 265K', '2024-10-24', 394.00, 'High-end Arrow Lake CPU with 20 cores.'),
(93, 'Intel', 'Core Ultra 5 245K', '2024-10-24', 309.00, 'Mid-range Arrow Lake CPU with 14 cores.'),
(94, 'Intel', 'Core Ultra 9 285', '2025-01-08', 549.00, 'Locked Arrow Lake flagship for high efficiency.'),
(95, 'Intel', 'Core Ultra 7 265', '2025-01-08', 379.00, '65W TDP Arrow Lake processor with 20 cores.'),
(96, 'Intel', 'Core Ultra 5 245', '2025-01-08', 289.00, 'Efficient mid-range Arrow Lake processor.'),
(97, 'Intel', 'Core i9-14900K', '2023-10-17', 589.00, 'Refresh of 13th Gen flagship, extremely high clocks.'),
(98, 'Intel', 'Core i7-14700K', '2023-10-17', 409.00, '14th Gen with extra E-cores compared to previous gen.'),
(99, 'Intel', 'Core i5-14600K', '2023-10-17', 319.00, 'Highly versatile 14th Gen gaming processor.'),
(100, 'Intel', 'Core i9-14900KS', '2024-03-14', 689.00, 'Special Edition CPU hitting 6.2 GHz out of the box.'),
(101, 'Intel', 'Core i9-13900K', '2022-10-20', 529.00, 'High-performance Raptor Lake flagship.'),
(102, 'Intel', 'Core i7-13700K', '2022-10-20', 369.00, 'Powerful 16-core (8P + 8E) desktop CPU.'),
(103, 'Intel', 'Core i5-13600K', '2022-10-20', 299.00, 'The sweet spot for gaming in the 13th Gen.'),
(104, 'Intel', 'Core i9-12900K', '2021-11-04', 399.00, 'First Intel hybrid architecture flagship (Alder Lake).'),
(105, 'Intel', 'Core i7-12700K', '2021-11-04', 279.00, 'Alder Lake 12-core processor.'),
(106, 'Intel', 'Core i5-12400F', '2022-01-04', 149.00, 'Popular budget 6-core processor without iGPU.'),
(107, 'AMD', 'Threadripper 7980X', '2023-11-21', 4999.00, 'HEDT beast with 64 cores and 128 threads.'),
(108, 'AMD', 'Threadripper 7970X', '2023-11-21', 2499.00, 'HEDT 32-core processor for professional workloads.'),
(109, 'AMD', 'Ryzen 3 5300G', '2021-04-13', 99.00, 'Budget 4-core APU for light office tasks.'),
(110, 'Intel', 'Core i3-14100', '2024-01-08', 139.00, 'Modern 4-core budget desktop CPU.'),
(111, 'Intel', 'Core i3-12100', '2022-01-04', 119.00, 'Alder Lake quad-core budget king.'),
(112, 'AMD', 'Ryzen 5 5500', '2022-04-04', 99.00, 'Highly affordable Zen 3 6-core CPU.'),
(113, 'AMD', 'Ryzen 5 4500', '2022-04-04', 79.00, 'Entry-level Zen 2 6-core for tight budgets.'),
(114, 'Intel', 'Core Ultra 3 205', '2025-05-10', 159.00, 'Arrow Lake entry-level processor.'),
(115, 'AMD', 'Ryzen 7 9700', '2025-01-10', 329.00, 'Non-X Zen 5 8-core, lower power consumption.'),
(116, 'AMD', 'Ryzen 5 9600', '2025-01-10', 249.00, 'Non-X Zen 5 6-core, efficient mainstream choice.'),
(117, 'Intel', 'Core Ultra 9 290K', '2025-10-15', 629.00, 'Refresh of the Arrow Lake flagship.'),
(118, 'Intel', 'Core Ultra 7 270K', '2025-10-15', 419.00, 'Enhanced Arrow Lake 20-core CPU.'),
(119, 'Intel', 'Core Ultra 5 250K', '2025-10-15', 329.00, 'High-performance mainstream Arrow Lake Refresh.'),
(120, 'AMD', 'Ryzen 9 9950XT', '2025-09-20', 699.00, 'Clock-speed bumped Zen 5 flagship.'),
(121, 'AMD', 'Ryzen 9 7900X3D', '2023-02-28', 599.00, '12-core Zen 4 with 3D V-Cache.'),
(122, 'AMD', 'Ryzen 7 5700X', '2022-04-04', 189.00, 'Efficient 65W 8-core AM4 processor.'),
(123, 'Intel', 'Core i5-13400', '2023-01-03', 229.00, 'Great value 10-core (6P + 4E) CPU.'),
(124, 'Intel', 'Core i5-14400', '2024-01-08', 239.00, 'Slightly faster version of the i5-13400.'),
(125, 'AMD', 'Ryzen 7 7700', '2023-01-10', 299.00, 'Non-X Zen 4 8-core with included cooler.'),
(126, 'AMD', 'Ryzen 5 7600', '2023-01-10', 219.00, 'Excellent entry to the AM5 platform.'),
(127, 'Intel', 'Core i9-14900F', '2024-01-08', 549.00, '14th Gen flagship without integrated graphics.'),
(128, 'Intel', 'Core i7-14700', '2024-01-08', 389.00, 'Efficient 14th Gen 20-core CPU.'),
(129, 'AMD', 'Ryzen 5 5600G', '2021-04-13', 139.00, 'Zen 3 APU with Vega 7 graphics.'),
(130, 'AMD', 'Ryzen 7 5700G', '2021-04-13', 189.00, '8-core Zen 3 APU for small form factor builds.');

-- CPU Table Data
INSERT INTO CPU (part_id, socket, thermal_design_power, core_count, base_clock, thread_count, boost_clock) VALUES
(71, 'AM5', 170, 16, 4.3, 32, 5.7),
(72, 'AM5', 120, 12, 4.4, 24, 5.6),
(73, 'AM5', 65, 8, 3.8, 16, 5.5),
(74, 'AM5', 65, 6, 3.9, 12, 5.4),
(75, 'AM5', 120, 16, 4.2, 32, 5.7),
(76, 'AM5', 120, 8, 4.7, 16, 5.2),
(77, 'AM5', 120, 6, 4.1, 12, 5.0),
(78, 'AM5', 170, 16, 4.5, 32, 5.7),
(79, 'AM5', 120, 16, 4.2, 32, 5.7),
(80, 'AM5', 120, 8, 4.2, 16, 5.0),
(81, 'AM5', 170, 12, 4.7, 24, 5.6),
(82, 'AM5', 105, 8, 4.5, 16, 5.4),
(83, 'AM5', 105, 6, 4.7, 12, 5.3),
(84, 'AM5', 65, 8, 4.2, 16, 5.1),
(85, 'AM5', 65, 6, 4.3, 12, 5.0),
(86, 'AM4', 105, 16, 3.4, 32, 4.9),
(87, 'AM4', 105, 12, 3.7, 24, 4.8),
(88, 'AM4', 105, 8, 3.4, 16, 4.5),
(89, 'AM4', 105, 8, 3.0, 16, 4.1),
(90, 'AM4', 65, 6, 3.7, 12, 4.6),
(91, 'LGA1851', 125, 24, 3.2, 24, 5.7),
(92, 'LGA1851', 125, 20, 3.3, 20, 5.4),
(93, 'LGA1851', 125, 14, 3.6, 14, 5.2),
(94, 'LGA1851', 65, 24, 2.5, 24, 5.5),
(95, 'LGA1851', 65, 20, 2.4, 20, 5.2),
(96, 'LGA1851', 65, 14, 2.6, 14, 5.0),
(97, 'LGA1700', 125, 24, 3.2, 32, 6.0),
(98, 'LGA1700', 125, 20, 3.4, 28, 5.6),
(99, 'LGA1700', 125, 14, 3.5, 20, 5.3),
(100, 'LGA1700', 150, 24, 3.2, 32, 6.2),
(101, 'LGA1700', 125, 24, 3.0, 32, 5.8),
(102, 'LGA1700', 125, 16, 3.4, 24, 5.4),
(103, 'LGA1700', 125, 14, 3.5, 20, 5.1),
(104, 'LGA1700', 125, 16, 3.2, 24, 5.2),
(105, 'LGA1700', 125, 12, 3.6, 20, 5.0),
(106, 'LGA1700', 65, 6, 2.5, 12, 4.4),
(107, 'sTR5', 350, 64, 3.2, 128, 5.1),
(108, 'sTR5', 350, 32, 4.0, 64, 5.3),
(109, 'AM4', 65, 4, 4.0, 8, 4.2),
(110, 'LGA1700', 60, 4, 3.5, 8, 4.7),
(111, 'LGA1700', 60, 4, 3.3, 8, 4.3),
(112, 'AM4', 65, 6, 3.7, 12, 4.2),
(113, 'AM4', 65, 6, 3.6, 12, 4.1),
(114, 'LGA1851', 45, 8, 3.0, 8, 4.5),
(115, 'AM5', 65, 8, 3.4, 16, 5.4),
(116, 'AM5', 65, 6, 3.5, 12, 5.3),
(117, 'LGA1851', 125, 24, 3.3, 24, 5.9),
(118, 'LGA1851', 125, 20, 3.4, 20, 5.6),
(119, 'LGA1851', 125, 14, 3.7, 14, 5.4),
(120, 'AM5', 170, 16, 4.4, 32, 5.9),
(121, 'AM5', 120, 12, 4.4, 24, 5.6),
(122, 'AM4', 65, 8, 3.4, 16, 4.6),
(123, 'LGA1700', 65, 10, 2.5, 16, 4.6),
(124, 'LGA1700', 65, 10, 2.5, 16, 4.7),
(125, 'AM5', 65, 8, 3.8, 16, 5.3),
(126, 'AM5', 65, 6, 3.8, 12, 5.1),
(127, 'LGA1700', 125, 24, 3.2, 32, 6.0),
(128, 'LGA1700', 65, 20, 2.1, 28, 5.4),
(129, 'AM4', 65, 6, 3.9, 12, 4.4),
(130, 'AM4', 65, 8, 3.8, 16, 4.6);

-- PC_Parts Table Data (RAM)
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(131, 'Corsair', 'Vengeance RGB 32GB DDR5-6000', '2023-05-12', 114.99, 'High-performance DDR5 memory with dynamic RGB lighting.'),
(132, 'G.Skill', 'Trident Z5 Neo RGB 32GB DDR5-6400', '2023-08-20', 129.99, 'Optimized for AMD EXPO with sleek aluminum heatspreaders.'),
(133, 'TeamGroup', 'T-Force Delta RGB 32GB DDR5-7200', '2023-11-05', 145.00, 'Ultra-fast DDR5 for enthusiasts and overclockers.'),
(134, 'Kingston', 'Fury Renegade 32GB DDR5-8000', '2024-02-14', 189.99, 'Top-tier speed for Intel XMP 3.0 platforms.'),
(135, 'Crucial', 'Crucial Pro 32GB DDR5-5600', '2023-04-10', 95.99, 'Plug-and-play high-speed memory for clean builds.'),
(136, 'Corsair', 'Dominator Titanium 64GB DDR5-6600', '2023-10-15', 315.00, 'Premium aesthetics with swappable top bars and DHX cooling.'),
(137, 'G.Skill', 'Ripjaws S5 32GB DDR5-5200', '2022-11-20', 89.00, 'Low-profile DDR5 ideal for small form factor builds.'),
(138, 'Patriot', 'Viper Xtreme 5 32GB DDR5-7600', '2024-01-30', 159.99, 'High-performance gaming RAM with industrial design.'),
(139, 'ADATA', 'XPG Lancer RGB 32GB DDR5-6000', '2023-06-12', 109.99, 'Sleek design with customizable lighting effects.'),
(140, 'Mushkin', 'Redline ST 32GB DDR5-6400', '2023-09-08', 119.00, 'Aggressive timings for gaming performance.'),
(141, 'Corsair', 'Vengeance LPX 16GB DDR4-3200', '2020-05-15', 39.99, 'Classic low-profile DDR4 memory for reliability.'),
(142, 'G.Skill', 'Ripjaws V 16GB DDR4-3600', '2020-08-10', 44.99, 'Popular high-frequency DDR4 for gaming systems.'),
(143, 'Crucial', 'Ballistix 32GB DDR4-3200', '2021-03-22', 75.00, 'Dependable DDR4 with black heatspreaders.'),
(144, 'TeamGroup', 'T-Create Expert 64GB DDR5-6000', '2024-03-05', 199.00, 'High-capacity kit designed for content creators.'),
(145, 'Kingston', 'Fury Beast 16GB DDR5-4800', '2022-01-12', 59.00, 'Entry-level DDR5 for modern office PCs.'),
(146, 'Corsair', 'Vengeance 96GB DDR5-5600', '2024-05-20', 349.99, 'Massive 2-stick capacity for heavy multitasking.'),
(147, 'G.Skill', 'Trident Z5 Royal 32GB DDR5-7200', '2024-06-15', 210.00, 'Luxury RAM with crystalline light bar and gold finish.'),
(148, 'Patriot', 'Viper Venom 16GB DDR5-5200', '2023-02-11', 54.99, 'Aggressive performance in a single stick configuration.'),
(149, 'TeamGroup', 'T-Force Vulcan 32GB DDR5-6000', '2023-04-18', 105.00, 'Minimalist non-RGB DDR5 for performance builds.'),
(150, 'ADATA', 'XPG Caster RGB 32GB DDR5-7000', '2023-12-01', 139.99, 'Future-proof speeds with bold aesthetics.'),
(151, 'Corsair', 'Dominator Platinum 32GB DDR4-3600', '2021-10-10', 129.00, 'Iconic design for premium DDR4 workstations.'),
(152, 'Mushkin', 'Enhanced Silverline 8GB DDR4-2666', '2019-11-04', 19.99, 'Budget-friendly upgrade for older systems.'),
(153, 'Crucial', 'Crucial 16GB DDR5-4800 (Single)', '2022-05-05', 49.00, 'Standard OEM-style DDR5 for basic upgrades.'),
(154, 'G.Skill', 'Flare X5 32GB DDR5-6000', '2023-03-14', 112.00, 'Tuned for AMD AM5 platforms with low profile.'),
(155, 'TeamGroup', 'Elite 32GB DDR5-4800', '2023-01-20', 85.00, 'Standard-compliant DDR5 for enterprise stability.'),
(156, 'Kingston', 'Fury Renegade RGB 48GB DDR5-6400', '2024-04-12', 175.00, 'Non-binary capacity for niche memory requirements.'),
(157, 'Corsair', 'Vengeance RGB 64GB DDR5-5200', '2023-07-30', 219.00, 'Large capacity RGB kit for video editing.'),
(158, 'Patriot', 'Viper Steel 16GB DDR4-4400', '2021-06-08', 95.00, 'Extremely fast DDR4 for record-breaking overclocks.'),
(159, 'G.Skill', 'Trident Z Neo 32GB DDR4-3600', '2020-12-05', 89.99, 'The gold standard for Ryzen 5000 series builds.'),
(160, 'Mushkin', 'Redline Lumina 32GB DDR4-3200', '2021-08-15', 79.00, 'Beautifully illuminated DDR4 memory kits.'),
(161, 'ADATA', 'XPG Spectrix D50 16GB DDR4-3200', '2021-02-14', 45.00, 'Solid performance with a clean geometric design.'),
(162, 'TeamGroup', 'T-Force Zeus 32GB DDR4-3200', '2021-05-10', 68.00, 'Affordable 32GB kit for gaming and productivity.'),
(163, 'Corsair', 'Vengeance 32GB DDR5-4800', '2022-02-28', 92.00, 'The original Corsair DDR5 launch kit.'),
(164, 'Kingston', 'Fury Beast RGB 64GB DDR5-6000', '2024-01-15', 235.00, 'Balanced speed and high capacity with lighting.'),
(165, 'Crucial', 'Pro 48GB DDR5-5600', '2024-03-22', 155.00, 'Workstation efficiency in a 2-stick 48GB kit.'),
(166, 'G.Skill', 'Ripjaws S5 64GB DDR5-5600', '2023-11-11', 205.00, 'Compact 64GB DDR5 for air-cooled builds.'),
(167, 'Patriot', 'Viper Venom 32GB DDR5-6000', '2023-05-01', 108.00, 'Fast, aggressive, and reliable gaming RAM.'),
(168, 'TeamGroup', 'T-Force Delta RGB 16GB DDR5-5200', '2022-10-10', 65.00, 'Entry-level RGB DDR5 for budget builders.'),
(169, 'ADATA', 'XPG Lancer 16GB DDR5-5600', '2022-12-15', 69.00, 'Solid non-RGB DDR5 for clean aesthetics.'),
(170, 'Mushkin', 'Redline ST 64GB DDR5-5600', '2024-02-20', 215.00, 'Stable high-capacity performance for professionals.'),
(171, 'Corsair', 'Vengeance RGB Pro 16GB DDR4-3200', '2019-06-20', 54.00, 'Classic high-end RGB lighting for DDR4.'),
(172, 'G.Skill', 'Trident Z RGB 32GB DDR4-3200', '2018-03-10', 82.00, 'The kit that defined modern RGB RAM design.'),
(173, 'Kingston', 'Fury Renegade 128GB DDR4-3200', '2021-09-12', 310.00, 'Quad-channel kit for X299 or Threadripper builds.'),
(174, 'TeamGroup', 'T-Create Classic 32GB DDR4-3200', '2021-04-18', 65.00, 'Professional design with industrial stability.'),
(175, 'Crucial', 'Crucial 8GB DDR4-2400', '2017-10-05', 15.00, 'Standard replacement stick for older desktops.'),
(176, 'Corsair', 'Vengeance LPX 32GB DDR4-3600', '2020-09-14', 79.00, 'Low-profile high-speed DDR4 for large coolers.'),
(177, 'Patriot', 'Viper Elite II 16GB DDR4-2666', '2021-02-01', 35.00, 'Solid budget choice for basic PC builds.'),
(178, 'ADATA', 'XPG Spectrix D60G 16GB DDR4-3600', '2020-05-15', 55.00, 'More RGB per square inch than any other kit.'),
(179, 'Mushkin', 'Enhanced Essentials 16GB DDR4-2133', '2016-08-10', 28.00, 'Essential memory for legacy systems.'),
(180, 'G.Skill', 'Trident Z Royal 64GB DDR4-3600', '2020-11-20', 245.00, 'High-end aesthetic for top-tier DDR4 builds.'),
(181, 'Corsair', 'Dominator Titanium 32GB DDR5-7200', '2023-12-10', 225.00, 'Elite performance with sophisticated design.'),
(182, 'TeamGroup', 'T-Force Xtreem ARGB 32GB DDR4-3600', '2021-07-05', 110.00, 'Full mirror-finish light bar for extreme builds.'),
(183, 'Kingston', 'Fury Beast 32GB DDR4-3200', '2021-06-15', 69.00, 'The dependable workhorse for modern DDR4.'),
(184, 'Crucial', 'Crucial Pro 32GB DDR4-3200', '2023-04-10', 65.00, 'Standard reliable memory with heat spreader.'),
(185, 'Corsair', 'Vengeance RGB 192GB DDR5-5200', '2024-08-15', 680.00, 'Maximum memory for 4-slot consumer boards.'),
(186, 'G.Skill', 'Zeta R5 128GB DDR5-6000', '2024-02-01', 540.00, 'Registered DIMM kit for workstation platforms.'),
(187, 'Patriot', 'Viper Steel 64GB DDR4-3600', '2022-03-12', 145.00, 'High capacity for heavy DDR4 workloads.'),
(188, 'ADATA', 'XPG Lancer 32GB DDR5-5200', '2023-01-10', 95.00, 'Clean, fast, and stable DDR5 memory.'),
(189, 'TeamGroup', 'T-Force Vulcan Z 16GB DDR4-3200', '2020-04-15', 36.00, 'Excellent price-to-performance for budget gaming.'),
(190, 'Mushkin', 'Redline 32GB DDR5-6000', '2023-10-25', 115.00, 'Tuned for low latency and high bandwidth.');

-- RAM Table Data
INSERT INTO RAM (part_id, ram_type, num_of_sticks, capacity, speed) VALUES
(131, 'DDR5', 2, 32, 6000),
(132, 'DDR5', 2, 32, 6400),
(133, 'DDR5', 2, 32, 7200),
(134, 'DDR5', 2, 32, 8000),
(135, 'DDR5', 2, 32, 5600),
(136, 'DDR5', 2, 64, 6600),
(137, 'DDR5', 2, 32, 5200),
(138, 'DDR5', 2, 32, 7600),
(139, 'DDR5', 2, 32, 6000),
(140, 'DDR5', 2, 32, 6400),
(141, 'DDR4', 2, 16, 3200),
(142, 'DDR4', 2, 16, 3600),
(143, 'DDR4', 2, 32, 3200),
(144, 'DDR5', 2, 64, 6000),
(145, 'DDR5', 2, 16, 4800),
(146, 'DDR5', 2, 96, 5600),
(147, 'DDR5', 2, 32, 7200),
(148, 'DDR5', 1, 16, 5200),
(149, 'DDR5', 2, 32, 6000),
(150, 'DDR5', 2, 32, 7000),
(151, 'DDR4', 2, 32, 3600),
(152, 'DDR4', 1, 8, 2666),
(153, 'DDR5', 1, 16, 4800),
(154, 'DDR5', 2, 32, 6000),
(155, 'DDR5', 2, 32, 4800),
(156, 'DDR5', 2, 48, 6400),
(157, 'DDR5', 2, 64, 5200),
(158, 'DDR4', 2, 16, 4400),
(159, 'DDR4', 2, 32, 3600),
(160, 'DDR4', 2, 32, 3200),
(161, 'DDR4', 2, 16, 3200),
(162, 'DDR4', 2, 32, 3200),
(163, 'DDR5', 2, 32, 4800),
(164, 'DDR5', 2, 64, 6000),
(165, 'DDR5', 2, 48, 5600),
(166, 'DDR5', 2, 64, 5600),
(167, 'DDR5', 2, 32, 6000),
(168, 'DDR5', 2, 16, 5200),
(169, 'DDR5', 1, 16, 5600),
(170, 'DDR5', 2, 64, 5600),
(171, 'DDR4', 2, 16, 3200),
(172, 'DDR4', 2, 32, 3200),
(173, 'DDR4', 4, 128, 3200),
(174, 'DDR4', 2, 32, 3200),
(175, 'DDR4', 1, 8, 2400),
(176, 'DDR4', 2, 32, 3600),
(177, 'DDR4', 2, 16, 2666),
(178, 'DDR4', 2, 16, 3600),
(179, 'DDR4', 2, 16, 2133),
(180, 'DDR4', 2, 64, 3600),
(181, 'DDR5', 2, 32, 7200),
(182, 'DDR4', 2, 32, 3600),
(183, 'DDR4', 2, 32, 3200),
(184, 'DDR4', 2, 32, 3200),
(185, 'DDR5', 4, 192, 5200),
(186, 'DDR5', 4, 128, 6000),
(187, 'DDR4', 2, 64, 3600),
(188, 'DDR5', 2, 32, 5200),
(189, 'DDR4', 2, 16, 3200),
(190, 'DDR5', 2, 32, 6000);

-- PC_Parts Table Data (PSU)
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(191, 'Corsair', 'RM750e (2023)', '2023-03-20', 99.99, 'Fully modular low-noise ATX power supply with ATX 3.0 support.'),
(192, 'Seasonic', 'FOCUS GX-850', '2022-05-15', 139.99, 'Compact, fully modular 80+ Gold unit with a 10-year warranty.'),
(193, 'EVGA', 'SuperNOVA 1000 G7', '2022-08-01', 189.99, 'High-efficiency Gold rated PSU with a compact 130mm chassis.'),
(194, 'be quiet!', 'Dark Power 13 1000W', '2023-01-24', 249.90, 'Virtually inaudible 80+ Titanium efficiency with ATX 3.0.'),
(195, 'Asus', 'ROG Thor 1200P2', '2021-11-10', 329.99, 'Premium 80+ Platinum PSU with OLED power display and Aura Sync.'),
(196, 'Corsair', 'SF750', '2019-02-15', 169.99, 'The gold standard for SFX power supplies, 80+ Platinum.'),
(197, 'Cooler Master', 'V850 Gold V2', '2020-07-15', 125.00, 'Full-modular PSU with high-efficiency and flat cables.'),
(198, 'Thermaltake', 'Toughpower GF3 1350W', '2022-09-12', 229.99, 'PCIe 5.0 ready unit designed for the latest power-hungry GPUs.'),
(199, 'Seasonic', 'PRIME TX-1600', '2023-06-30', 529.99, 'Ultimate 80+ Titanium performance for extreme workstations.'),
(200, 'SilverStone', 'SX1000 Platinum', '2021-01-05', 269.99, 'World first SFX-L 1000W power supply for high-end SFF builds.'),
(201, 'MSI', 'MPG A850G PCIE5', '2022-10-18', 144.99, 'ATX 3.0 compliant PSU featuring a native 16-pin connector.'),
(202, 'Phanteks', 'Revolt 1200W Platinum', '2023-08-22', 219.99, 'Cable-free PSU designed for custom cable configurations.'),
(203, 'NZXT', 'C1200 Gold', '2023-02-14', 199.99, 'Silent operation with a Zero RPM Fan mode.'),
(204, 'Fractal Design', 'Ion+ 2 Platinum 860W', '2021-05-18', 159.99, 'Ultra-flexible UltraFlex DC cables for easy routing.'),
(205, 'Super Flower', 'Leadex VII Gold 1000W', '2023-04-10', 169.99, 'High-performance ATX 3.0 unit from a top-tier OEM.'),
(206, 'Corsair', 'RM1000x Shift', '2023-01-31', 209.99, 'Innovative side-mounted cable interface for easier access.'),
(207, 'Deepcool', 'PX1000G', '2023-05-25', 159.99, 'Reliable 80+ Gold ATX 3.0 PSU with solid Japanese capacitors.'),
(208, 'XPG', 'Core Reactor II 850W', '2023-07-12', 129.99, 'Compact Gold-rated PSU with a premium FDB fan.'),
(209, 'be quiet!', 'Pure Power 12 M 750W', '2023-02-07', 119.90, 'Quiet 80+ Gold efficiency with ATX 3.0 compatibility.'),
(210, 'Corsair', 'CX650M', '2021-10-05', 69.99, 'Semi-modular 80+ Bronze PSU for budget-conscious builds.'),
(211, 'EVGA', '500 W1', '2019-06-12', 44.99, 'Entry-level 80+ White non-modular power supply.'),
(212, 'Thermaltake', 'Smart 500W', '2018-04-10', 39.99, 'Budget-friendly non-modular PSU for basic systems.'),
(213, 'Cooler Master', 'MWE Bronze 550 V2', '2020-09-12', 59.99, 'Reliable 80+ Bronze unit with DC-to-DC technology.'),
(214, 'Seasonic', 'S12III 500W', '2019-11-20', 54.00, 'Legacy non-modular 80+ Bronze unit.'),
(215, 'Asus', 'ROG Strix 850W Gold', '2020-05-30', 139.99, 'ROG heatsinks and Axial-tech fan for cool operation.'),
(216, 'Corsair', 'AX1600i', '2018-05-22', 599.99, 'The pinnacle of power delivery with GaN transistors.'),
(217, 'Lian Li', 'SP850', '2022-07-08', 149.99, 'High-wattage SFX power supply with sleek aluminum housing.'),
(218, 'FSP Group', 'Hydro PTM Pro 1200W', '2021-03-14', 259.99, 'Platinum efficiency with off-wet coating for harsh environments.'),
(219, 'Gigabyte', 'UD850GM', '2022-02-15', 114.99, 'Ultra Durable design with Japanese main capacitors.'),
(220, 'SilverStone', 'ST1500-TI', '2017-09-10', 439.99, '80+ Titanium 1500W beast for multi-GPU setups.'),
(221, 'Corsair', 'RM650 (2023)', '2023-04-05', 89.99, 'Fully modular 650W Gold PSU for mid-range builds.'),
(222, 'EVGA', 'SuperNOVA 750 GT', '2021-03-22', 109.99, 'Auto Eco Mode for silent operation at low loads.'),
(223, 'Deepcool', 'DQ750-M-V2L', '2020-08-14', 95.00, 'Fully modular 80+ Gold with black flat cables.'),
(224, 'Seasonic', 'FOCUS PX-750', '2020-01-10', 145.00, 'Platinum rated efficiency in a compact 140mm frame.'),
(225, 'Thermaltake', 'Toughpower Grand RGB 850W', '2017-06-15', 129.99, 'RGB-enabled Gold PSU for those who need more lights.'),
(226, 'Antec', 'HCG Gold 750W', '2018-10-12', 119.99, 'High Current Gamer series with PhaseWave Design.'),
(227, 'ADATA', 'XPG Pylon 650W', '2020-10-25', 65.00, 'Highly rated Bronze unit for budget gaming.'),
(228, 'Montech', 'Century 850W', '2021-02-14', 109.99, 'Fully modular Gold PSU at an aggressive price point.'),
(229, 'Enermax', 'Revolution D.F. 850W', '2019-04-18', 114.99, 'Dust Free Rotation technology to keep the fan clean.'),
(230, 'Cooler Master', 'SFX Gold 750W', '2020-12-05', 135.00, 'SFX form factor with high-density power delivery.'),
(231, 'MSI', 'MAG A650BN', '2021-09-10', 59.99, 'Solid 80+ Bronze entry for mainstream gamers.'),
(232, 'Phanteks', 'AMP 750W Gold', '2019-10-20', 105.00, 'Seasonic-collaborated design with modular cables.'),
(233, 'Fractal Design', 'Anode Bronze 600W', '2022-04-15', 64.99, 'Reliable semi-modular Bronze PSU for essentials.'),
(234, 'Asus', 'TUF Gaming 750W Bronze', '2020-11-30', 89.99, 'Military-grade certification for durability.'),
(235, 'Corsair', 'HXi Series HX1500i', '2022-06-14', 399.99, 'Fully digital Platinum efficiency with iCUE control.'),
(236, 'SilverStone', 'Nightjar 450W', '2018-05-10', 159.99, 'Fanless zero-noise 80+ Platinum power supply.'),
(237, 'FSP Group', 'Dagger Pro 850W', '2021-08-01', 155.00, 'High-wattage SFX PSU for small form factor PCs.'),
(238, 'Rosewill', 'PMW 1200', '2022-03-10', 179.99, '80+ Platinum unit designed for server-grade stability.'),
(239, 'Thermaltake', 'Smart BM3 750W', '2023-09-05', 84.99, 'Semi-modular ATX 3.0 budget option.'),
(240, 'be quiet!', 'System Power 10 650W', '2022-10-25', 74.90, 'Proven reliability for price-conscious PC builds.'),
(241, 'Seasonic', 'Vertex GX-1000', '2023-01-15', 229.99, 'Premium ATX 3.0 unit with embossed cables.'),
(242, 'MSI', 'MEG AI1300P PCIE5', '2022-11-01', 359.99, 'High-end Platinum unit with software monitoring.'),
(243, 'Asus', 'ROG Loki SFX-L 850W', '2022-12-20', 219.99, 'SFX-L Platinum PSU with ARGB fan and PCIe 5.0.'),
(244, 'Cooler Master', 'V1100 SFX Platinum', '2023-03-10', 289.99, 'Highest density SFX power supply available.'),
(245, 'Corsair', 'SF1000 (2024)', '2024-06-12', 229.99, 'High-power SFX ATX 3.1 compliant power supply.'),
(246, 'Seasonic', 'FOCUS GX-1000 (2026)', '2026-01-20', 199.99, 'Next-gen refresh with ultra-stable voltage regulation.'),
(247, 'be quiet!', 'Dark Power Pro 13 1600W', '2023-05-20', 449.90, 'The benchmark for noise and efficiency.'),
(248, 'Super Flower', 'Leadex V Gold 850W', '2021-07-15', 139.99, 'Ultra-short 130mm depth for maximum case compatibility.'),
(249, 'SilverStone', 'Extreme 850R Platinum', '2022-12-05', 215.00, 'SFX form factor with Cybernetics Platinum rating.'),
(250, 'Phanteks', 'Revolt 1600W Titanium', '2024-02-28', 499.99, 'Extreme power for AI workstations and overclocking.');

-- PSU Table Data
INSERT INTO PSU (part_id, modular, wattage, efficiency) VALUES
(191, 'Full', 750, '80+ Gold'),
(192, 'Full', 850, '80+ Gold'),
(193, 'Full', 1000, '80+ Gold'),
(194, 'Full', 1000, '80+ Titanium'),
(195, 'Full', 1200, '80+ Platinum'),
(196, 'Full', 750, '80+ Platinum'),
(197, 'Full', 850, '80+ Gold'),
(198, 'Full', 1350, '80+ Gold'),
(199, 'Full', 1600, '80+ Titanium'),
(200, 'Full', 1000, '80+ Platinum'),
(201, 'Full', 850, '80+ Gold'),
(202, 'Full', 1200, '80+ Platinum'),
(203, 'Full', 1200, '80+ Gold'),
(204, 'Full', 860, '80+ Platinum'),
(205, 'Full', 1000, '80+ Gold'),
(206, 'Full', 1000, '80+ Gold'),
(207, 'Full', 1000, '80+ Gold'),
(208, 'Full', 850, '80+ Gold'),
(209, 'Full', 750, '80+ Gold'),
(210, 'Semi', 650, '80+ Bronze'),
(211, 'Non-Modular', 500, '80+ White'),
(212, 'Non-Modular', 500, '80+ White'),
(213, 'Non-Modular', 550, '80+ Bronze'),
(214, 'Non-Modular', 500, '80+ Bronze'),
(215, 'Full', 850, '80+ Gold'),
(216, 'Full', 1600, '80+ Titanium'),
(217, 'Full', 850, '80+ Gold'),
(218, 'Full', 1200, '80+ Platinum'),
(219, 'Full', 850, '80+ Gold'),
(220, 'Full', 1500, '80+ Titanium'),
(221, 'Full', 650, '80+ Gold'),
(222, 'Full', 750, '80+ Gold'),
(223, 'Full', 750, '80+ Gold'),
(224, 'Full', 750, '80+ Platinum'),
(225, 'Full', 850, '80+ Gold'),
(226, 'Full', 750, '80+ Gold'),
(227, 'Non-Modular', 650, '80+ Bronze'),
(228, 'Full', 850, '80+ Gold'),
(229, 'Full', 850, '80+ Gold'),
(230, 'Full', 750, '80+ Gold'),
(231, 'Non-Modular', 650, '80+ Bronze'),
(232, 'Full', 750, '80+ Gold'),
(233, 'Semi', 600, '80+ Bronze'),
(234, 'Non-Modular', 750, '80+ Bronze'),
(235, 'Full', 1500, '80+ Platinum'),
(236, 'Non-Modular', 450, '80+ Platinum'),
(237, 'Full', 850, '80+ Gold'),
(238, 'Full', 1200, '80+ Platinum'),
(239, 'Semi', 750, '80+ Bronze'),
(240, 'Non-Modular', 650, '80+ Bronze'),
(241, 'Full', 1000, '80+ Gold'),
(242, 'Full', 1300, '80+ Platinum'),
(243, 'Full', 850, '80+ Platinum'),
(244, 'Full', 1100, '80+ Platinum'),
(245, 'Full', 1000, '80+ Platinum'),
(246, 'Full', 1000, '80+ Gold'),
(247, 'Full', 1600, '80+ Titanium'),
(248, 'Full', 850, '80+ Gold'),
(249, 'Full', 850, '80+ Platinum'),
(250, 'Full', 1600, '80+ Titanium');

-- PC_Parts Table Data (GPU)
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(251, 'NVIDIA', 'GeForce RTX 5090 Founders Edition', '2025-01-20', 1999.99, 'The Blackwell flagship. Absolute overkill for anything less than 8K gaming.'),
(252, 'NVIDIA', 'GeForce RTX 5080 Founders Edition', '2025-01-20', 1199.99, 'High-end Blackwell performance with significant ray-tracing improvements.'),
(253, 'ASUS', 'ROG Strix RTX 5070 Ti', '2025-03-15', 849.99, 'Premium overclocked 5070 Ti with massive triple-fan cooling.'),
(254, 'MSI', 'Suprim X RTX 5090', '2025-02-10', 2199.99, 'Luxury tier 5090 with brushed aluminum shroud and silent fans.'),
(255, 'AMD', 'Radeon RX 8900 XTX', '2025-05-12', 1099.99, 'AMD RDNA 4 flagship featuring massive rasterization power.'),
(256, 'AMD', 'Radeon RX 8800 XT', '2025-05-12', 649.99, 'The sweet spot for 4K gaming in the RDNA 4 lineup.'),
(257, 'Sapphire', 'Nitro+ Radeon RX 8900 XTX', '2025-06-01', 1199.99, 'The highest-performing RDNA 4 card with beautiful ARGB accents.'),
(258, 'Intel', 'Arc B580 Battlemage', '2025-02-14', 349.99, 'Intel second-gen mid-range contender. Great value for 1440p.'),
(259, 'Gigabyte', 'Aorus Master RTX 5080', '2025-02-15', 1349.99, 'Features a side-mounted LCD screen for real-time telemetry.'),
(260, 'NVIDIA', 'GeForce RTX 5070 Founders Edition', '2025-04-10', 599.99, 'Efficient, compact Blackwell card for the modern enthusiast.'),
(261, 'XFX', 'Speedster MERC 310 RX 7900 XTX', '2022-12-13', 929.99, 'A classic RDNA 3 powerhouse with a sleek black design.'),
(262, 'ASRock', 'Phantom Gaming RX 8700 XT', '2025-07-20', 499.99, 'Aggressive styling and solid 1440p performance.'),
(263, 'NVIDIA', 'GeForce RTX 4090 Founders Edition', '2022-10-12', 1599.99, 'The legendary Ada Lovelace king that held the crown for years.'),
(264, 'MSI', 'Gaming X Slim RTX 4070 Super', '2024-01-17', 629.99, 'Thin-profile card perfect for high-performance SFF builds.'),
(265, 'Zotac', 'Gaming Trinity RTX 4080 Super', '2024-01-31', 999.99, 'Curved aesthetic with excellent thermal performance.'),
(266, 'PowerColor', 'Hellhound RX 7800 XT', '2023-09-06', 499.99, 'Efficient cooling and distinctive blue LED lighting.'),
(267, 'NVIDIA', 'GeForce RTX 5060', '2025-08-15', 329.99, 'The entry point for Blackwell, bringing DLSS 4 to the masses.'),
(268, 'AMD', 'Radeon RX 8600 XT', '2025-09-10', 349.99, 'High-efficiency RDNA 4 card targeting 1080p ultra settings.'),
(269, 'ASUS', 'Dual RTX 4060 Ti 16GB', '2023-07-18', 449.99, 'Extra VRAM for texture-heavy workloads and future-proofing.'),
(270, 'Intel', 'Arc A770 Limited Edition', '2022-10-12', 329.00, 'Intel first flagship effort, now a solid budget choice.'),
(271, 'EVGA', 'GeForce RTX 3090 Ti FTW3 Ultra', '2022-03-29', 1999.99, 'A collector item. The final flagship from EVGA before their exit.'),
(272, 'Gigabyte', 'Windforce RTX 4060', '2023-06-29', 299.99, 'Cool and quiet entry-level card for 1080p gaming.'),
(273, 'Sapphire', 'Pulse RX 7600 XT', '2024-01-24', 329.99, 'Budget-friendly card with a surprising 16GB of VRAM.'),
(274, 'PNY', 'Verto RTX 4070 Ti Super', '2024-01-24', 799.99, 'No-nonsense design focused on performance and stability.'),
(275, 'NVIDIA', 'GeForce RTX 3060 12GB', '2021-02-25', 289.99, 'The long-reigning mid-range king of the Steam hardware survey.'),
(276, 'Galax', 'RTX 4090 HOF (Hall of Fame)', '2022-12-05', 2499.99, 'White PCB extreme overclocking card for world records.'),
(277, 'ASUS', 'TUF Gaming RX 7900 XT', '2022-12-13', 749.99, 'Built like a tank with military-grade components.'),
(278, 'AMD', 'Radeon RX 6950 XT', '2022-05-10', 649.99, 'The peak of RDNA 2 performance, still relevant for 1440p.'),
(279, 'MSI', 'Ventus 2X RTX 4050 (Desktop)', '2025-01-15', 199.99, 'Entry-level desktop card for eSports and office productivity.'),
(280, 'Intel', 'Arc B570 Battlemage', '2025-03-01', 249.99, 'The new budget king for 1080p high settings.'),
(281, 'Colorful', 'iGame RTX 5080 Vulcan', '2025-03-20', 1299.99, 'Includes a detachable smart screen and pop-up fans.'),
(282, 'Gainward', 'Phantom RTX 5070', '2025-04-15', 619.99, 'Dark, industrial aesthetic with excellent airflow.'),
(283, 'XFX', 'Speedster SWFT 210 RX 7600', '2023-05-25', 269.99, 'Compact dual-fan design for mainstream AMD builds.'),
(284, 'Sapphire', 'Pure RX 7700 XT', '2023-09-06', 439.99, 'A clean, all-white aesthetic for RDNA 3 enthusiasts.'),
(285, 'Palit', 'GameRock RTX 4080', '2022-11-16', 1199.99, 'The "Midnight Kaleidoscope" with crystal-style RGB.'),
(286, 'NVIDIA', 'GeForce RTX 5090 Ti', '2026-03-01', 2499.99, 'The dual-GPU-on-one-die monster release for late 2026.'),
(287, 'AMD', 'Radeon RX 8950 XTX', '2026-04-15', 1249.99, 'A late-cycle RDNA 4 refresh with higher clock speeds.'),
(288, 'ASUS', 'ROG Matrix RTX 4090', '2023-09-19', 3199.99, 'Liquid-cooled enthusiast card with liquid metal TIM.'),
(289, 'Gigabyte', 'Eagle RTX 4070 Ti', '2023-01-05', 769.99, 'Reliable three-fan performance without the price premium.'),
(290, 'Inno3D', 'iChill X3 RTX 5070 Ti', '2025-03-10', 829.99, 'Heavily stylized shroud with high static pressure fans.'),
(291, 'PowerColor', 'Red Devil RX 7900 GRE', '2024-02-27', 549.99, 'Golden Rabbit Edition with premium Devil-series cooling.'),
(292, 'Acer', 'Predator BiFrost Arc A770', '2022-11-15', 349.99, 'Hybrid cooling design with blower and axial fans.'),
(293, 'Sparkle', 'Titan OC Arc B580', '2025-02-20', 369.99, 'Sparkle returns with a heavy-duty Battlemage overclock.'),
(294, 'Gunnir', 'Photon Arc A750', '2022-10-12', 249.00, 'The most popular Intel GPU choice in the Asian market.'),
(295, 'NVIDIA', 'RTX A6000 Ada Generation', '2023-01-01', 6799.99, 'Workstation beast with 48GB VRAM for AI and rendering.'),
(296, 'AMD', 'Radeon Pro W7900', '2023-04-13', 3999.00, 'Professional RDNA 3 card with DisplayPort 2.1 support.'),
(297, 'NVIDIA', 'GeForce GTX 1650 G6', '2020-04-01', 159.99, 'The immortal budget card that requires no power connector.'),
(298, 'ASUS', 'ProArt RTX 4080 Super', '2024-03-10', 1099.99, 'Elegant, minimal design for creative professionals.'),
(299, 'MSI', 'Expert RTX 4080 Super', '2024-01-31', 1149.99, 'Push-pull fan design inspired by enterprise hardware.'),
(300, 'Sapphire', 'Nitro+ RX 6800 XT', '2020-11-18', 649.99, 'One of the best-regarded AMD cards of the last decade.'),
(301, 'NVIDIA', 'GeForce RTX 2080 Ti FE', '2018-09-20', 1199.00, 'The first consumer card to introduce Ray Tracing cores.'),
(302, 'AMD', 'Radeon RX 5700 XT', '2019-07-07', 399.00, 'The RDNA 1 champion that offered incredible value.'),
(303, 'ASUS', 'Dual RTX 3060 Ti GDDR6X', '2022-10-15', 399.99, 'Updated mid-gen refresh with faster memory speeds.'),
(304, 'Gigabyte', 'Low Profile RTX 4060', '2023-08-10', 329.99, 'The fastest low-profile card available for HTPC builds.'),
(305, 'Biostar', 'Radeon RX 7600', '2023-05-25', 259.99, 'Basic, functional RDNA 3 for standard desktops.'),
(306, 'ASRock', 'Aqua RX 7900 XTX', '2022-12-13', 1399.99, 'Features a pre-installed full-coverage water block.'),
(307, 'Yeston', 'RTX 4080 Sakura Sugar', '2023-04-10', 1250.00, 'Waifu-themed aesthetics with floral-scented fans.'),
(308, 'Leadtek', 'WinFast RTX 5060 Ti', '2025-07-01', 399.99, 'A classic brand returns with a solid Blackwell mid-ranger.'),
(309, 'NVIDIA', 'GeForce RTX 3050 6GB', '2024-02-02', 179.99, 'Low-power version of the 3050 that runs off slot power.'),
(310, 'Matrox', 'Luma A380', '2023-06-01', 299.99, 'Powered by Intel Arc, specialized for multi-display walls.');

-- GPU Table Data
INSERT INTO GPU (part_id, VRAM, chipset, length_mm, power_connectors) VALUES
(251, 32, 'Blackwell GB202', 336, '1x 16-pin'),
(252, 16, 'Blackwell GB203', 306, '1x 16-pin'),
(253, 12, 'Blackwell GB205', 315, '1x 16-pin'),
(254, 32, 'Blackwell GB202', 358, '1x 16-pin'),
(255, 24, 'RDNA 4 Navi 41', 320, '2x 8-pin'),
(256, 16, 'RDNA 4 Navi 42', 280, '2x 8-pin'),
(257, 24, 'RDNA 4 Navi 41', 330, '3x 8-pin'),
(258, 12, 'Battlemage BMG-G10', 265, '1x 8-pin'),
(259, 16, 'Blackwell GB203', 342, '1x 16-pin'),
(260, 12, 'Blackwell GB205', 244, '1x 16-pin'),
(261, 24, 'RDNA 3 Navi 31', 344, '3x 8-pin'),
(262, 12, 'RDNA 4 Navi 42', 275, '1x 8-pin'),
(263, 24, 'Ada Lovelace AD102', 304, '1x 16-pin'),
(264, 12, 'Ada Lovelace AD104', 267, '1x 16-pin'),
(265, 16, 'Ada Lovelace AD103', 307, '1x 16-pin'),
(266, 12, 'RDNA 3 Navi 32', 232, '2x 8-pin'),
(267, 8, 'Blackwell GB207', 220, '1x 8-pin'),
(268, 16, 'RDNA 4 Navi 44', 240, '1x 8-pin'),
(269, 16, 'Ada Lovelace AD106', 227, '1x 8-pin'),
(270, 16, 'Alchemist ACM-G10', 270, '1x 8-pin + 1x 6-pin'),
(271, 24, 'Ampere GA102', 338, '1x 16-pin'),
(272, 8, 'Ada Lovelace AD107', 204, '1x 8-pin'),
(273, 16, 'RDNA 3 Navi 33', 247, '1x 8-pin'),
(274, 16, 'Ada Lovelace AD103', 305, '1x 16-pin'),
(275, 12, 'Ampere GA106', 242, '1x 8-pin'),
(276, 24, 'Ada Lovelace AD102', 352, '2x 16-pin'),
(277, 20, 'RDNA 3 Navi 31', 320, '2x 8-pin'),
(278, 16, 'RDNA 2 Navi 21', 320, '3x 8-pin'),
(279, 6, 'Ada Lovelace AD107', 172, 'None'),
(280, 8, 'Battlemage BMG-G21', 230, '1x 8-pin'),
(281, 16, 'Blackwell GB203', 348, '1x 16-pin'),
(282, 12, 'Blackwell GB205', 306, '1x 16-pin'),
(283, 8, 'RDNA 3 Navi 33', 241, '1x 8-pin'),
(284, 12, 'RDNA 3 Navi 32', 280, '2x 8-pin'),
(285, 16, 'Ada Lovelace AD103', 329, '1x 16-pin'),
(286, 48, 'Blackwell Dual GB202', 365, '2x 16-pin'),
(287, 24, 'RDNA 4 Navi 41', 325, '3x 8-pin'),
(288, 24, 'Ada Lovelace AD102', 280, '1x 16-pin'),
(289, 12, 'Ada Lovelace AD104', 282, '1x 16-pin'),
(290, 12, 'Blackwell GB205', 300, '1x 16-pin'),
(291, 16, 'RDNA 3 Navi 32', 320, '2x 8-pin'),
(292, 16, 'Alchemist ACM-G10', 267, '2x 8-pin'),
(293, 12, 'Battlemage BMG-G10', 305, '2x 8-pin'),
(294, 8, 'Alchemist ACM-G10', 300, '2x 8-pin'),
(295, 48, 'Ada Lovelace AD102', 267, '1x 16-pin'),
(296, 48, 'RDNA 3 Navi 31', 280, '2x 8-pin'),
(297, 4, 'Turing TU117', 158, 'None'),
(298, 16, 'Ada Lovelace AD103', 300, '1x 16-pin'),
(299, 16, 'Ada Lovelace AD103', 312, '1x 16-pin'),
(300, 16, 'RDNA 2 Navi 21', 310, '2x 8-pin'),
(301, 11, 'Turing TU102', 267, '2x 8-pin'),
(302, 8, 'RDNA 1 Navi 10', 272, '1x 8-pin + 1x 6-pin'),
(303, 8, 'Ampere GA104', 230, '1x 8-pin'),
(304, 8, 'Ada Lovelace AD107', 182, '1x 8-pin'),
(305, 8, 'RDNA 3 Navi 33', 235, '1x 8-pin'),
(306, 24, 'RDNA 3 Navi 31', 275, '3x 8-pin'),
(307, 16, 'Ada Lovelace AD103', 330, '1x 16-pin'),
(308, 8, 'Blackwell GB207', 215, '1x 8-pin'),
(309, 6, 'Ampere GA107', 170, 'None'),
(310, 6, 'Alchemist ACM-G11', 150, 'None');

-- PC_Parts Table Data (Cooler)
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(311, 'Noctua', 'NH-D15 G2', '2024-06-20', 149.90, 'The second generation of the legendary dual-tower flagship.'),
(312, 'Corsair', 'iCUE Link H150i RGB', '2023-07-15', 239.99, '360mm AIO with simplified cable management and high-performance fans.'),
(313, 'Arctic', 'Liquid Freezer III 360', '2024-02-14', 115.00, 'Top-tier price-to-performance liquid cooler with VRM fan.'),
(314, 'be quiet!', 'Dark Rock Pro 5', '2023-10-24', 99.90, 'Virtually inaudible high-end air cooling with a speed switch.'),
(315, 'NZXT', 'Kraken Elite 360', '2023-04-18', 279.99, 'Premium AIO featuring a high-resolution LCD screen on the pump.'),
(316, 'Thermalright', 'Peerless Assassin 120 SE', '2022-05-10', 34.90, 'Dual-tower air cooler that punches way above its price bracket.'),
(317, 'Deepcool', 'AK620 Digital', '2023-06-01', 79.99, 'High-performance air cooler with a real-time status display.'),
(318, 'Lian Li', 'Galahad II LCD 360', '2023-08-15', 249.00, 'AIO featuring an Asetek 8th Gen pump and customizable LCD.'),
(319, 'Cooler Master', 'Hyper 212 Halo', '2023-02-05', 39.99, 'A modern refresh of the most famous budget air cooler in history.'),
(320, 'EKWB', 'EK-Nucleus AIO CR360 Lux', '2023-01-10', 189.99, 'Liquid cooler designed with enthusiast-grade waterblock DNA.'),
(321, 'Noctua', 'NH-U12A chromax.black', '2021-10-12', 129.90, 'Flagship 120mm cooler with performance rivaling 140mm units.'),
(322, 'Corsair', 'H100i RGB Platinum', '2020-03-14', 139.99, 'Reliable 240mm liquid cooler for mainstream gaming builds.'),
(323, 'Arctic', 'Freezer 36', '2024-03-05', 45.00, 'Single-tower air cooler with a new mounting system for LGA1851.'),
(324, 'be quiet!', 'Pure Loop 2 240', '2023-09-12', 109.90, 'Elegant liquid cooling with a decoupled pump for silent operation.'),
(325, 'Thermalright', 'Phantom Spirit 120 EVO', '2024-01-20', 49.90, 'Enhanced version of the Peerless Assassin with higher heatpipe count.'),
(326, 'Noctua', 'NH-L9i-17xx', '2021-11-04', 44.90, 'Ultra-low profile air cooler for SFF builds.'),
(327, 'Phanteks', 'Glacier One 360MPH', '2021-06-30', 199.99, 'High-performance AIO with a unique infinity mirror pump cap.'),
(328, 'Deepcool', 'Assassin IV', '2023-07-10', 99.99, 'A clean, cubic air cooler designed for maximum heat dissipation.'),
(329, 'Cooler Master', 'MasterLiquid ML360L V2', '2021-05-20', 94.99, 'Budget-friendly 360mm liquid cooling with RGB fans.'),
(330, 'NZXT', 'T120 RGB', '2022-10-25', 49.99, 'Sleek single-tower air cooler with integrated lighting.'),
(331, 'Fractal Design', 'Lumen S36 v2', '2023-02-14', 139.99, 'Updated liquid cooler with improved pump reliability.'),
(332, 'Arctic', 'Liquid Freezer II 280', '2020-05-15', 105.00, 'Thick 280mm radiator for high-performance quiet cooling.'),
(333, 'Thermalright', 'AXP120-X67', '2022-08-12', 39.90, 'Low-profile cooler with 6 heatpipes for powerful ITX systems.'),
(334, 'Lian Li', 'Galahad II Trinity Performance', '2023-07-01', 169.99, 'Focused on raw thermal performance with thick fans.'),
(335, 'ID-COOLING', 'SE-224-XTS', '2023-01-15', 29.99, 'Excellent entry-level air cooler with modern socket support.'),
(336, 'SilverStone', 'IceMyst 360', '2023-11-20', 159.99, 'AIO with stackable fans to cool surrounding motherboard components.'),
(337, 'Scythe', 'Fuma 3', '2023-07-18', 49.99, 'Asymmetric dual-tower design for 100% RAM compatibility.'),
(338, 'be quiet!', 'Dark Rock TF 2', '2021-08-10', 89.90, 'High-end top-flow cooler for compact powerhouses.'),
(339, 'Noctua', 'NH-P1', '2021-06-14', 109.90, 'Passive fanless CPU cooler for silent enthusiast PCs.'),
(340, 'Corsair', 'iCUE H170i Elite LCD XT', '2023-02-10', 309.99, 'Massive 420mm AIO for extreme CPU cooling.'),
(341, 'Deepcool', 'LS720 SE', '2023-04-01', 109.99, 'Clean design AIO with 4th Gen pump technology.'),
(342, 'Cooler Master', 'MA824 Stealth', '2023-05-20', 99.99, 'Massive air tower with 8 heatpipes and stealthy look.'),
(343, 'Arctic', 'Freezer 50', '2020-10-15', 65.00, 'Aggressive dual-tower design with A-RGB lighting.'),
(344, 'Thermalright', 'Silver Soul 135', '2021-09-05', 35.90, 'Compact dual-tower air cooler for smaller cases.'),
(345, 'Phanteks', 'Glacier One 420D30', '2024-03-12', 189.99, 'High-airflow AIO utilizing the premium D30 fans.'),
(346, 'NZXT', 'Kraken 240', '2023-04-18', 139.99, 'The base Kraken model with a square 1.54 inch LCD.'),
(347, 'Noctua', 'NH-U14S TR4-SP3', '2017-08-31', 89.90, 'Specialized air cooler for AMD Threadripper platforms.'),
(348, 'IceGiant', 'ProSiphon Elite', '2021-02-20', 169.99, 'Thermosiphon technology for massive heat loads.'),
(349, 'Scythe', 'Mugen 6 Black Edition', '2024-02-01', 54.99, 'Sixth iteration of the quiet classic with a black finish.'),
(350, 'be quiet!', 'Pure Rock 2 FX', '2022-08-14', 52.90, 'Essential air cooling with vibrant Light Wings fans.'),
(351, 'Lian Li', 'HydroShift LCD 360S', '2024-07-10', 199.99, 'Side-mounted radiator tubing for a cleaner look.'),
(352, 'Deepcool', 'AN600', '2023-06-15', 54.99, 'Low-profile 62mm cooler with high RAM clearance.'),
(353, 'Thermalright', 'Frozen Edge 360', '2023-10-01', 65.00, 'Incredibly affordable high-performance 360mm AIO.'),
(354, 'Corsair', 'A115 Tower Cooler', '2024-01-16', 99.99, 'High-performance air cooler with sliding fan rails.'),
(355, 'Arctic', 'Liquid Freezer III 420', '2024-02-14', 129.99, 'The king of radiator surface area for the hottest CPUs.'),
(356, 'EKWB', 'EK-AIO 240 Basic', '2021-04-05', 89.99, 'No-frills, high-performance liquid cooling without LEDs.'),
(357, 'Thermaltake', 'TH360 V2 Ultra ARGB', '2023-11-15', 169.99, 'AIO with 2.1 inch LCD and high-static pressure fans.'),
(358, 'ID-COOLING', 'IS-55 Black', '2022-12-10', 39.99, '55mm tall cooler perfect for mini-ITX gaming builds.'),
(359, 'Alphacool', 'Eisbaer Pro Aurora 360', '2021-07-20', 210.00, 'Expandable AIO with full copper radiator and G1/4 threads.'),
(360, 'G.Skill', 'Enki 360', '2021-03-10', 175.00, 'Custom high-density micro-fin design for better heat transfer.'),
(361, 'Noctua', 'NH-D12L', '2022-04-05', 89.90, 'Low-height 120mm dual-tower for specialized cases.'),
(362, 'Deepcool', 'AK400 Zero Dark', '2022-09-15', 39.99, 'Popular single-tower budget cooler in all-black.'),
(363, 'Thermalright', 'Assassin King 120 SE', '2022-06-20', 25.00, 'Ultra-budget 5-heatpipe single tower cooler.'),
(364, 'Cooler Master', 'MasterAir MA612 Stealth', '2021-03-30', 85.00, 'Asymmetrical heatpipe design for full RAM access.'),
(365, 'be quiet!', 'Shadow Rock Slim 2', '2021-05-11', 49.90, 'Space-saving slim tower that does not compromise on noise.'),
(366, 'SilverStone', 'Vida 240 Slim', '2022-08-30', 119.99, 'Slim 240mm AIO with 22mm radiator for tight spaces.'),
(367, 'Asus', 'ROG Ryujin III 360 ARGB', '2023-05-15', 349.99, 'Enthusiast AIO with magnetic fans and 3.5 inch LCD.'),
(368, 'MSI', 'MAG CoreLiquid E360', '2023-09-01', 139.99, 'Large surface area copper base with rotating blockhead.'),
(369, 'Lian Li', 'Galahad II Trinity 240', '2023-07-15', 119.99, 'Includes three interchangeable pump caps for customization.'),
(370, 'Zalman', 'CNPS10X Performa', '2021-05-10', 44.99, 'Classic performance air cooler with high-fin density.');

-- Cooler Table Data
INSERT INTO Cooler (part_id, cooler_type, socket_type) VALUES
(311, 'Air', 'LGA1851/1700/AM5'),
(312, 'AIO', 'LGA1851/1700/AM5'),
(313, 'AIO', 'LGA1851/1700/AM5'),
(314, 'Air', 'LGA1700/AM5/AM4'),
(315, 'AIO', 'LGA1700/AM5'),
(316, 'Air', 'LGA1700/AM5/AM4'),
(317, 'Air', 'LGA1700/AM5/AM4'),
(318, 'AIO', 'LGA1700/AM5'),
(319, 'Air', 'LGA1700/AM5'),
(320, 'AIO', 'LGA1700/AM5'),
(321, 'Air', 'LGA1700/AM5'),
(322, 'AIO', 'LGA1200/AM4'),
(323, 'Air', 'LGA1851/1700'),
(324, 'AIO', 'LGA1700/AM5'),
(325, 'Air', 'LGA1851/1700/AM5'),
(326, 'Air', 'LGA1700'),
(327, 'AIO', 'LGA1200/AM4'),
(328, 'Air', 'LGA1700/AM5'),
(329, 'AIO', 'LGA1700/AM4'),
(330, 'Air', 'LGA1700/AM5'),
(331, 'AIO', 'LGA1700/AM5'),
(332, 'AIO', 'LGA1200/AM4'),
(333, 'Air', 'LGA1700/AM5'),
(334, 'AIO', 'LGA1700/AM5'),
(335, 'Air', 'LGA1700/AM5'),
(336, 'AIO', 'LGA1700/AM5'),
(337, 'Air', 'LGA1700/AM5'),
(338, 'Air', 'LGA1200/AM4'),
(339, 'Air', 'LGA1200/AM4'),
(340, 'AIO', 'LGA1700/AM5'),
(341, 'AIO', 'LGA1700/AM5'),
(342, 'Air', 'LGA1700/AM5'),
(343, 'Air', 'LGA1200/AM4'),
(344, 'Air', 'LGA1700/AM5'),
(345, 'AIO', 'LGA1700/AM5'),
(346, 'AIO', 'LGA1700/AM5'),
(347, 'Air', 'sTR5/sTRX4'),
(348, 'Air', 'LGA1700/AM5/sTR5'),
(349, 'Air', 'LGA1851/1700/AM5'),
(350, 'Air', 'LGA1700/AM5'),
(351, 'AIO', 'LGA1700/AM5'),
(352, 'Air', 'LGA1700/AM5'),
(353, 'AIO', 'LGA1700/AM5'),
(354, 'Air', 'LGA1851/1700/AM5'),
(355, 'AIO', 'LGA1851/1700/AM5'),
(356, 'AIO', 'LGA1200/AM4'),
(357, 'AIO', 'LGA1700/AM5'),
(358, 'Air', 'LGA1700/AM5'),
(359, 'AIO', 'LGA1700/AM5/sTR5'),
(360, 'AIO', 'LGA1200/AM4'),
(361, 'Air', 'LGA1700/AM5'),
(362, 'Air', 'LGA1700/AM5'),
(363, 'Air', 'LGA1700/AM5'),
(364, 'Air', 'LGA1200/AM4'),
(365, 'Air', 'LGA1200/AM4'),
(366, 'AIO', 'LGA1700/AM5'),
(367, 'AIO', 'LGA1700/AM5'),
(368, 'AIO', 'LGA1700/AM5'),
(369, 'AIO', 'LGA1700/AM5'),
(370, 'Air', 'LGA1200/AM4');
-- PC_Parts Table Data (PC Cases)
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(371, 'Fractal Design', 'North', '2022-12-07', 139.99, 'Elegant mid-tower with genuine walnut or oak front slats.'),
(372, 'Fractal Design', 'North XL', '2024-03-05', 169.99, 'Larger version of the North, supporting E-ATX and 420mm radiators.'),
(373, 'Fractal Design', 'Terra', '2023-05-31', 179.99, 'Boutique SFF case with an adjustable internal spine and wood trim.'),
(374, 'Fractal Design', 'Meshify 2 Compact', '2021-02-17', 124.99, 'High-airflow case with iconic angular mesh front panel.'),
(375, 'Fractal Design', 'Define 7', '2020-02-19', 179.99, 'Premium silent case with modular internal layout for storage or cooling.'),
(376, 'Lian Li', 'O11 Dynamic EVO RGB', '2023-12-20', 169.99, 'The evolution of the O11 series with dual-strip RGB and reversible layout.'),
(377, 'Lian Li', 'Lancool III', '2022-07-15', 149.99, 'Hardcore airflow chassis with four pre-installed 140mm PWM fans.'),
(378, 'Lian Li', 'O11 Vision', '2023-11-10', 139.99, 'Three-sided glass "fishtank" case with no corner pillars.'),
(379, 'Lian Li', 'A3-mATX', '2024-05-22', 69.99, 'Compact 26L Micro-ATX case developed with DAN Cases.'),
(380, 'Lian Li', 'Q58', '2021-09-20', 129.99, 'Mini-ITX split-panel design with mesh and glass options.'),
(381, 'NZXT', 'H5 Flow (2024)', '2024-06-10', 94.99, 'Mid-tower with a dedicated bottom-intake fan for the GPU.'),
(382, 'NZXT', 'H6 Flow', '2023-11-01', 109.99, 'Compact dual-chamber case with angled front-corner fans.'),
(383, 'NZXT', 'H7 Flow RGB', '2024-06-10', 149.99, 'Modern high-performance ATX tower with massive mesh panels.'),
(384, 'NZXT', 'H9 Elite', '2023-01-24', 239.99, 'Premium dual-chamber case with glass top and side panels.'),
(385, 'NZXT', 'H1 V2', '2022-02-15', 349.99, 'Vertical ITX case including 750W PSU and 140mm AIO.'),
(386, 'Corsair', '4000D Airflow', '2020-09-15', 104.99, 'The staple of modern builds; excellent cable management and airflow.'),
(387, 'Corsair', '5000D RGB Airflow', '2023-02-28', 219.99, 'Larger mid-tower with side-intake fan mounts and iCUE integration.'),
(388, 'Corsair', '7000D Airflow', '2021-06-29', 269.99, 'Full-tower behemoth for massive custom water cooling loops.'),
(389, 'Corsair', '2000D RGB Airflow', '2023-05-16', 189.99, 'Small form factor vertical tower supporting 360mm AIOs.'),
(390, 'Corsair', '3500X', '2024-07-01', 89.99, 'Entry-level panoramic glass mid-tower for showpiece builds.'),
(391, 'Phanteks', 'NV7', '2023-03-31', 219.99, 'Showcase ATX chassis that frames the motherboard like a picture.'),
(392, 'Phanteks', 'NV5', '2023-09-15', 109.99, 'Slightly more compact version of the NV7 for mainstream builds.'),
(393, 'Phanteks', 'Eclipse G360A', '2022-06-07', 99.99, 'Value-oriented high-airflow case with integrated lighting.'),
(394, 'Phanteks', 'Enthoo Pro 2 Server Edition', '2023-11-10', 189.99, 'Full tower designed for professional workstations and servers.'),
(395, 'Phanteks', 'Evolv Shift XT', '2022-02-22', 169.99, 'Expandable ITX case that grows in height to fit different cooling.'),
(396, 'be quiet!', 'Shadow Base 800 FX', '2023-09-05', 219.90, 'High-airflow mid-tower with Light Wings fans and ARGB hub.'),
(397, 'be quiet!', 'Dark Base Pro 901', '2023-06-27', 299.90, 'The flagship modular tower for maximum quiet and flexibility.'),
(398, 'be quiet!', 'Pure Base 500DX', '2020-04-28', 109.90, 'Compact ATX tower with subtle ARGB and silent operation.'),
(399, 'Cooler Master', 'MasterBox NR200P V2', '2024-01-15', 124.99, 'The king of mainstream ITX cases, now with USB-C and 280mm support.'),
(400, 'Cooler Master', 'HAF 700 EVO', '2022-02-16', 499.99, 'The "Berserker" flagship with an Iris LCD screen and massive fans.'),
(401, 'Cooler Master', 'MasterBox TD500 Mesh V2', '2023-02-14', 99.99, 'Polygonal mesh front design with high airflow and tool-less panels.'),
(402, 'Hyte', 'Y70 Touch Infinite', '2024-05-15', 359.99, 'Panoramic case featuring an integrated 4K touchscreen.'),
(403, 'Hyte', 'Y60', '2022-03-15', 199.99, 'Iconic three-piece panoramic glass with vertical GPU mount.'),
(404, 'Hyte', 'Y40', '2023-01-10', 149.99, 'Modern S-tier aesthetic for mid-sized ATX builds.'),
(405, 'Thermaltake', 'The Tower 300', '2024-01-08', 149.99, 'Unique octagonal prism design for vertical Micro-ATX builds.'),
(406, 'Thermaltake', 'Ceres 300 TG', '2023-05-30', 99.99, 'Perforated panels for high-airflow and modern component support.'),
(407, 'Thermaltake', 'Core P3 TG Pro', '2022-11-15', 159.99, 'Open-frame chassis designed for wall mounting or desktop display.'),
(408, 'ASUS', 'ROG Hyperion GR701', '2023-02-10', 499.99, 'Extreme full-tower for ROG superfans with dual 420mm radiator support.'),
(409, 'ASUS', 'TUF Gaming GT302 ARGB', '2024-03-20', 129.99, 'Optimized for high-airflow with BTF back-side connector support.'),
(410, 'ASUS', 'Prime AP201', '2022-06-15', 74.99, 'Quasi-mesh Micro-ATX case with a surprisingly high capacity.'),
(411, 'MSI', 'MPG Gungnir 300R Airflow', '2023-09-12', 169.99, 'Includes a high-end omnidirectional GPU support bracket.'),
(412, 'MSI', 'MAG Pano M100R PZ', '2024-02-10', 109.99, 'Micro-ATX panoramic case with back-connect motherboard support.'),
(413, 'SSUPD', 'Meshlicious', '2021-05-01', 119.99, 'Vertical SFF case with full mesh panels for incredible cooling.'),
(414, 'SSUPD', 'Meshroom S', '2022-09-05', 159.99, 'Evolution of Meshlicious with ATX motherboard support in SFF form.'),
(415, 'Montech', 'Sky Two', '2022-11-30', 99.99, 'Luxury-designed panoramic case with four high-performance fans.'),
(416, 'Montech', 'Air 903 Max', '2023-06-15', 75.00, 'Budget airflow king with massive 140mm fans included.'),
(417, 'Montech', 'King 95 Pro', '2023-12-05', 149.99, 'Dual-chamber design with curved glass and robust fan support.'),
(418, 'SilverStone', 'Alta G1M', '2021-10-25', 169.99, 'Vertical Micro-ATX tower with chimney-effect cooling.'),
(419, 'SilverStone', 'Sugo 16', '2021-12-10', 95.00, 'Ultra-compact shoe-box style ITX case for home servers.'),
(420, 'Deepcool', 'CH560 Digital', '2023-07-15', 109.99, 'Mid-tower with an integrated side-panel digital display.'),
(421, 'Deepcool', 'CH160', '2024-04-10', 69.99, 'High-airflow portable ITX case with a built-in handle.'),
(422, 'Deepcool', 'Morpheus', '2023-11-20', 199.99, 'Fully modular reconfigurable case (Single or Dual Chamber).'),
(423, 'Antec', 'Performance 1 FT', '2023-04-12', 159.99, 'Full tower with a temperature display and massive mesh front.'),
(424, 'Antec', 'C8', '2024-01-15', 129.99, 'Dual-chamber "Full View" case focusing on bottom-to-top airflow.'),
(425, 'FormD', 'T1 V2.1', '2024-01-01', 195.00, 'Enthusiast-grade CNC aluminum sandwich-style ITX case.'),
(426, 'NCASE', 'M1EVO', '2023-10-01', 210.00, 'The successor to the case that started the SFF revolution.'),
(427, 'Velka', 'Velka 3', '2023-05-10', 159.00, 'One of the smallest cases in the world (3.96L) that fits a GPU.'),
(428, 'Streacom', 'DA6', '2022-06-20', 250.00, 'Open-frame chrome pipe ITX masterpiece.'),
(429, 'Jonsbo', 'TK-1', '2023-05-15', 119.00, 'U-shaped curved glass Micro-ATX dual-chamber case.'),
(430, 'Jonsbo', 'D31 Mesh Screen', '2023-02-10', 115.00, 'Micro-ATX case featuring a built-in 8-inch LCD in the front panel.');

-- PC_Case Table Data
INSERT INTO PC_Case (part_id, max_gpu_size, form_factor, color) VALUES
(371, 355, 'ATX Mid Tower', 'Charcoal/Walnut'),
(372, 413, 'ATX Full Tower', 'Chalk/Oak'),
(373, 322, 'Mini ITX Tower', 'Jade'),
(374, 341, 'ATX Mid Tower', 'Black'),
(375, 467, 'ATX Mid Tower', 'Grey'),
(376, 455, 'ATX Mid Tower', 'Black'),
(377, 385, 'ATX Mid Tower', 'White'),
(378, 455, 'ATX Mid Tower', 'Chrome'),
(379, 415, 'MicroATX Tower', 'Black'),
(380, 320, 'Mini ITX Tower', 'Black/Grey'),
(381, 365, 'ATX Mid Tower', 'White'),
(382, 365, 'ATX Mid Tower', 'Black'),
(383, 410, 'ATX Mid Tower', 'White'),
(384, 435, 'ATX Mid Tower', 'White'),
(385, 324, 'Mini ITX Tower', 'Black'),
(386, 360, 'ATX Mid Tower', 'Black'),
(387, 420, 'ATX Mid Tower', 'White'),
(388, 450, 'ATX Full Tower', 'Black'),
(389, 365, 'Mini ITX Tower', 'Grey'),
(390, 410, 'ATX Mid Tower', 'Black'),
(391, 450, 'ATX Full Tower', 'Black'),
(392, 440, 'ATX Mid Tower', 'White'),
(393, 365, 'ATX Mid Tower', 'Black'),
(394, 475, 'ATX Full Tower', 'Black'),
(395, 324, 'Mini ITX Tower', 'Silver'),
(396, 430, 'ATX Mid Tower', 'Black'),
(397, 495, 'ATX Full Tower', 'Black'),
(398, 369, 'ATX Mid Tower', 'White'),
(399, 356, 'Mini ITX Tower', 'Black'),
(400, 490, 'ATX Full Tower', 'Titanium Grey'),
(401, 410, 'ATX Mid Tower', 'Black'),
(402, 400, 'ATX Mid Tower', 'White'),
(403, 390, 'ATX Mid Tower', 'Red'),
(404, 422, 'ATX Mid Tower', 'Black'),
(405, 400, 'MicroATX Tower', 'Sky Blue'),
(406, 370, 'ATX Mid Tower', 'Black'),
(407, 450, 'ATX Mid Tower', 'Black'),
(408, 460, 'ATX Full Tower', 'Black'),
(409, 400, 'ATX Mid Tower', 'White'),
(410, 338, 'MicroATX Tower', 'Black'),
(411, 380, 'ATX Mid Tower', 'Black'),
(412, 390, 'MicroATX Tower', 'White'),
(413, 334, 'Mini ITX Tower', 'Black'),
(414, 336, 'Mini ITX Tower', 'Sage Green'),
(415, 400, 'ATX Mid Tower', 'White'),
(416, 400, 'ATX Mid Tower', 'Black'),
(417, 420, 'ATX Mid Tower', 'Red'),
(418, 355, 'MicroATX Tower', 'Black'),
(419, 275, 'Mini ITX Tower', 'White'),
(420, 380, 'ATX Mid Tower', 'Black'),
(421, 305, 'Mini ITX Tower', 'White'),
(422, 480, 'ATX Full Tower', 'Black'),
(423, 400, 'ATX Full Tower', 'Black'),
(424, 440, 'ATX Full Tower', 'White'),
(425, 325, 'Mini ITX Tower', 'Black'),
(426, 360, 'Mini ITX Tower', 'Silver'),
(427, 175, 'Mini ITX Tower', 'Black'),
(428, 323, 'Mini ITX Tower', 'Chrome'),
(429, 280, 'MicroATX Tower', 'Black'),
(430, 400, 'MicroATX Tower', 'White');

-- PC_Parts Table Data (Motherboards)
INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) VALUES
(431, 'ASUS', 'ROG Maximus Z890 Hero', '2024-10-24', 699.99, 'Flagship Intel LGA1851 motherboard with Thunderbolt 4 and extreme power delivery.'),
(432, 'MSI', 'MEG Z890 ACE', '2024-10-24', 649.00, 'Premium E-ATX board for Arrow Lake with gold-accented aesthetics.'),
(433, 'Gigabyte', 'Z890 AORUS Master', '2024-10-24', 549.99, 'High-end Intel motherboard with robust thermal fins and PCIe 5.0 support.'),
(434, 'ASRock', 'Z890 Taichi', '2024-10-24', 499.99, 'Legendary gear-themed design with 24+2+1 phase power for LGA1851.'),
(435, 'ASUS', 'ROG Strix X870E-E Gaming WiFi', '2024-09-30', 499.99, 'Top-tier AM5 board for Ryzen 9000 series with massive heatsinks.'),
(436, 'Gigabyte', 'X870E AORUS Xtreme', '2024-09-30', 799.99, 'The ultimate AM5 platform with 10GbE LAN and premium audio DAC.'),
(437, 'MSI', 'MPG X870E Carbon WiFi', '2024-09-30', 479.00, 'Sleek black aesthetic with full PCIe 5.0 integration for storage and GPU.'),
(438, 'ASRock', 'X870 Steel Legend WiFi', '2024-10-15', 279.99, 'Reliable AM5 performance with a distinct white and camo aesthetic.'),
(439, 'ASUS', 'TUF Gaming B850-Plus WiFi', '2025-01-10', 229.99, 'Durable mainstream AM5 board for balanced gaming builds.'),
(440, 'MSI', 'MAG B850 Tomahawk WiFi', '2025-01-10', 219.00, 'The legendary Tomahawk series returns for the Ryzen 9000 mid-range.'),
(441, 'Gigabyte', 'B850 AORUS Elite AX', '2025-01-10', 199.99, 'Feature-rich B-series board with efficient VRM for gaming.'),
(442, 'ASUS', 'ROG Strix Z790-E Gaming WiFi II', '2023-10-16', 439.99, 'Refined LGA1700 board with WiFi 7 and high-speed DDR5 support.'),
(443, 'MSI', 'MPG Z790 Edge TI Max WiFi', '2023-10-16', 359.99, 'Brilliant white Z790 board optimized for 14th Gen Intel CPUs.'),
(444, 'Gigabyte', 'Z790 AORUS Elite X AX', '2023-10-16', 289.99, 'Excellent value Z790 board with easy DIY features like M.2 EZ-Latch.'),
(445, 'ASRock', 'Z790 Nova WiFi', '2023-10-16', 329.99, 'New ASRock series with an incredible number of M.2 slots.'),
(446, 'ASUS', 'ROG Crosshair X670E Hero', '2022-09-27', 649.99, 'The premier AM5 choice for enthusiasts and heavy overclocking.'),
(447, 'MSI', 'MAG X670E Tomahawk WiFi', '2023-03-15', 299.99, 'Solid X-series features at a more approachable price point.'),
(448, 'Gigabyte', 'X670 AORUS Elite AX', '2022-09-27', 269.99, 'Reliable X670 platform with a focus on core connectivity.'),
(449, 'ASUS', 'ProArt X670E-Creator WiFi', '2022-09-27', 499.99, 'Designed for creators with 10GbE, USB4, and minimal aesthetics.'),
(450, 'ASRock', 'X670E Taichi Carrara', '2022-09-27', 529.99, '20th Anniversary edition with a stunning marble-texture finish.'),
(451, 'ASUS', 'ROG Strix B650-A Gaming WiFi', '2022-10-10', 239.99, 'A stylish white and silver B650 board for AM5 users.'),
(452, 'MSI', 'MAG B650 Mortar WiFi', '2022-10-10', 199.99, 'Premium Micro-ATX board with heavy duty heatsinks.'),
(453, 'Gigabyte', 'B650I AORUS Ultra', '2022-11-15', 259.99, 'High-end Mini-ITX board for powerful SFF AM5 builds.'),
(454, 'ASRock', 'B650M Pro RS WiFi', '2023-05-10', 149.99, 'The budget king for AM5, offering great features for the price.'),
(455, 'ASUS', 'Prime B650M-A II', '2022-10-10', 159.99, 'Essential B650 Micro-ATX board for office or entry-level gaming.'),
(456, 'MSI', 'PRO Z790-A MAX WiFi', '2023-10-16', 259.99, 'Professional-grade Z790 board with a clean, silver design.'),
(457, 'Gigabyte', 'B760 AORUS Elite AX', '2023-01-03', 179.99, 'Mid-range Intel board with balanced power and connectivity.'),
(458, 'ASUS', 'TUF Gaming B760M-Plus WiFi', '2023-01-03', 189.99, 'Rock-solid Micro-ATX performance for Intel 12th/13th/14th Gen.'),
(459, 'ASRock', 'B760I Lightning WiFi', '2024-02-15', 179.99, 'Impressive VRM for a budget-friendly Mini-ITX Intel board.'),
(460, 'MSI', 'B760 Gaming Plus WiFi', '2023-01-03', 159.99, 'Affordable ATX board for Intel users moving to DDR5.'),
(461, 'ASUS', 'ROG Strix B760-I Gaming WiFi', '2023-01-03', 219.99, 'Premium ITX board for Intel with high-speed networking.'),
(462, 'ASRock', 'B760M-HDV/M.2 D4', '2023-01-03', 99.99, 'Ultra-budget Intel board utilizing affordable DDR4 memory.'),
(463, 'Gigabyte', 'B760M DS3H AX DDR4', '2023-01-03', 129.99, 'Entry-level Micro-ATX board with built-in WiFi.'),
(464, 'ASUS', 'ROG Strix B550-F Gaming WiFi II', '2021-10-20', 189.99, 'One of the best AM4 boards ever made for Ryzen 5000.'),
(465, 'MSI', 'B550-A Pro', '2020-06-16', 129.99, 'Reliable, no-frills AM4 workhorse for professional builds.'),
(466, 'Gigabyte', 'B550I AORUS Pro AX', '2020-06-16', 199.99, 'Renowned AM4 ITX board with excellent thermal management.'),
(467, 'ASRock', 'B550 Phantom Gaming-ITX/ax', '2020-06-16', 169.99, 'Compact AM4 power with 2.5GbE and WiFi 6.'),
(468, 'ASUS', 'TUF Gaming X570-Plus WiFi', '2019-07-07', 209.99, 'The classic X570 board that powered millions of Ryzen 3000 builds.'),
(469, 'MSI', 'MAG X570S Tomahawk MAX WiFi', '2021-08-10', 229.99, 'Fanless X570 refresh for silent, high-end AM4 operation.'),
(470, 'Gigabyte', 'X570S AORUS Master', '2021-08-10', 349.99, 'Premium refreshed X570 with massive storage potential.'),
(471, 'ASRock', 'X570 Taichi', '2019-07-07', 299.99, 'High-end AM4 aesthetic with integrated WiFi and triple M.2.'),
(472, 'ASUS', 'ROG Strix X570-I Gaming', '2019-07-07', 259.99, 'The gold standard for high-performance AM4 SFF builds.'),
(473, 'Gigabyte', 'A520M S2H', '2020-08-18', 74.99, 'Basic AM4 motherboard for office and budget PCs.'),
(474, 'MSI', 'A520M-A Pro', '2020-08-18', 69.99, 'Minimalist AM4 Micro-ATX for cost-sensitive builds.'),
(475, 'ASRock', 'A520M-ITX/ac', '2020-08-18', 104.99, 'Rare affordable ITX entry for the AM4 platform.'),
(476, 'ASUS', 'ROG Maximus Z790 Dark Hero', '2023-10-16', 629.99, 'The pinnacle of LGA1700, featuring stealthy looks and WiFi 7.'),
(477, 'MSI', 'MEG Z790 Godlike MAX', '2023-10-16', 1199.99, 'Extreme E-ATX board with a detachable 4.5-inch LCD dashboard.'),
(478, 'Gigabyte', 'Z790 AORUS Tachyon', '2023-02-15', 599.99, 'Specialized 2-DIMM board designed purely for memory overclocking.'),
(479, 'ASUS', 'Pro WS W790E-SAGE SE', '2023-03-10', 1299.99, 'Workstation-class board for Intel Xeon W-2400/3400 processors.'),
(480, 'ASRock', 'WRX90 WS EVO', '2024-01-20', 999.99, 'Professional AM5 workstation board for Threadripper 7000.'),
(481, 'Gigabyte', 'TRX50 AORUS Master', '2023-11-21', 799.99, 'High-end HEDT motherboard for creative professionals.'),
(482, 'ASUS', 'ROG Strix B760-G Gaming WiFi D4', '2023-01-03', 179.99, 'Micro-ATX board for Intel with DDR4 and white/silver theme.'),
(483, 'MSI', 'MPG B650I Edge WiFi', '2022-10-10', 239.99, 'Compact AM5 board with an elegant silver-white finish.'),
(484, 'ASRock', 'B650 LiveMixer', '2022-10-10', 229.99, 'Uniquely styled graffiti board with 23 USB ports for streamers.'),
(485, 'ASUS', 'ProArt B760-Creator D4', '2023-01-03', 219.99, 'Creative-focused Intel board utilizing affordable DDR4.'),
(486, 'MSI', 'MAG B550 Tomahawk', '2020-06-16', 169.99, 'A classic AM4 board known for exceptional VRM cooling.'),
(487, 'Gigabyte', 'B550 Gaming X V2', '2020-09-10', 109.99, 'Great value ATX motherboard for late-gen AM4 builds.'),
(488, 'ASRock', 'B450M-HDV R4.0', '2019-01-15', 64.99, 'The ultimate budget survivor for the AM4 platform.'),
(489, 'ASUS', 'Prime H610M-E D4', '2022-01-04', 99.99, 'Basic entry point for Intel 12th and 13th Gen builds.'),
(490, 'MSI', 'PRO H610M-G DDR4', '2022-01-04', 89.99, 'Cost-effective Micro-ATX for home and office Intel PCs.');

-- Motherboard Table Data
INSERT INTO Motherboard (part_id, socket, chipset, ram_type, form_factor, max_ram) VALUES
(431, 'LGA1851', 'Z890', 'DDR5', 'ATX', 192),
(432, 'LGA1851', 'Z890', 'DDR5', 'E-ATX', 256),
(433, 'LGA1851', 'Z890', 'DDR5', 'ATX', 192),
(434, 'LGA1851', 'Z890', 'DDR5', 'ATX', 192),
(435, 'AM5', 'X870E', 'DDR5', 'ATX', 192),
(436, 'AM5', 'X870E', 'DDR5', 'E-ATX', 256),
(437, 'AM5', 'X870E', 'DDR5', 'ATX', 192),
(438, 'AM5', 'X870', 'DDR5', 'ATX', 192),
(439, 'AM5', 'B850', 'DDR5', 'ATX', 192),
(440, 'AM5', 'B850', 'DDR5', 'ATX', 192),
(441, 'AM5', 'B850', 'DDR5', 'ATX', 192),
(442, 'LGA1700', 'Z790', 'DDR5', 'ATX', 192),
(443, 'LGA1700', 'Z790', 'DDR5', 'ATX', 192),
(444, 'LGA1700', 'Z790', 'DDR5', 'ATX', 192),
(445, 'LGA1700', 'Z790', 'DDR5', 'ATX', 192),
(446, 'AM5', 'X670E', 'DDR5', 'ATX', 192),
(447, 'AM5', 'X670E', 'DDR5', 'ATX', 192),
(448, 'AM5', 'X670', 'DDR5', 'ATX', 192),
(449, 'AM5', 'X670E', 'DDR5', 'ATX', 192),
(450, 'AM5', 'X670E', 'DDR5', 'E-ATX', 256),
(451, 'AM5', 'B650', 'DDR5', 'ATX', 192),
(452, 'AM5', 'B650', 'DDR5', 'Micro-ATX', 128),
(453, 'AM5', 'B650', 'DDR5', 'Mini-ITX', 96),
(454, 'AM5', 'B650', 'DDR5', 'Micro-ATX', 128),
(455, 'AM5', 'B650', 'DDR5', 'Micro-ATX', 128),
(456, 'LGA1700', 'Z790', 'DDR5', 'ATX', 192),
(457, 'LGA1700', 'B760', 'DDR5', 'ATX', 192),
(458, 'LGA1700', 'B760', 'DDR5', 'Micro-ATX', 128),
(459, 'LGA1700', 'B760', 'DDR5', 'Mini-ITX', 96),
(460, 'LGA1700', 'B760', 'DDR5', 'ATX', 192),
(461, 'LGA1700', 'B760', 'DDR5', 'Mini-ITX', 96),
(462, 'LGA1700', 'B760', 'DDR4', 'Micro-ATX', 64),
(463, 'LGA1700', 'B760', 'DDR4', 'Micro-ATX', 128),
(464, 'AM4', 'B550', 'DDR4', 'ATX', 128),
(465, 'AM4', 'B550', 'DDR4', 'ATX', 128),
(466, 'AM4', 'B550', 'DDR4', 'Mini-ITX', 64),
(467, 'AM4', 'B550', 'DDR4', 'Mini-ITX', 64),
(468, 'AM4', 'X570', 'DDR4', 'ATX', 128),
(469, 'AM4', 'X570', 'DDR4', 'ATX', 128),
(470, 'AM4', 'X570', 'DDR4', 'ATX', 128),
(471, 'AM4', 'X570', 'DDR4', 'ATX', 128),
(472, 'AM4', 'X570', 'DDR4', 'Mini-ITX', 64),
(473, 'AM4', 'A520', 'DDR4', 'Micro-ATX', 64),
(474, 'AM4', 'A520', 'DDR4', 'Micro-ATX', 64),
(475, 'AM4', 'A520', 'DDR4', 'Mini-ITX', 64),
(476, 'LGA1700', 'Z790', 'DDR5', 'ATX', 192),
(477, 'LGA1700', 'Z790', 'DDR5', 'E-ATX', 256),
(478, 'LGA1700', 'Z790', 'DDR5', 'ATX', 96),
(479, 'LGA4677', 'W790', 'DDR5', 'E-ATX', 2048),
(480, 'sTR5', 'WRX90', 'DDR5', 'E-ATX', 2048),
(481, 'sTR5', 'TRX50', 'DDR5', 'ATX', 1024),
(482, 'LGA1700', 'B760', 'DDR4', 'Micro-ATX', 128),
(483, 'AM5', 'B650', 'DDR5', 'Mini-ITX', 96),
(484, 'AM5', 'B650', 'DDR5', 'ATX', 192),
(485, 'LGA1700', 'B760', 'DDR4', 'ATX', 128),
(486, 'AM4', 'B550', 'DDR4', 'ATX', 128),
(487, 'AM4', 'B550', 'DDR4', 'ATX', 128),
(488, 'AM4', 'B450', 'DDR4', 'Micro-ATX', 32),
(489, 'LGA1700', 'H610', 'DDR4', 'Micro-ATX', 64),
(490, 'LGA1700', 'H610', 'DDR4', 'Micro-ATX', 64);

SELECT setval('pc_parts_part_id_seq', 490);

--

INSERT INTO Users (user_id, email, created_on, username) VALUES
(21, 'alex.smith@example.com', '2024-01-15 08:30:00', 'alex_s'),
(22, 'jordan.b@webmail.com', '2024-01-16 12:45:10', 'jordanb_99'),
(23, 'tech_guru@provider.net', '2024-01-20 15:20:00', 'techguru'),
(24, 'morgan_dev@code.io', '2024-02-01 09:15:30', 'morgandev'),
(25, 's.taylor@domain.org', '2024-02-05 18:00:00', 'staylor'),
(26, 'river_run@flow.com', '2024-02-10 21:10:45', 'river_r'),
(27, 'casey.jones@mail.com', '2024-02-12 07:55:00', 'cjonesy'),
(28, 'data_wiz@stats.edu', '2024-02-15 14:25:00', 'datawiz'),
(29, 'pixel_art@design.com', '2024-02-28 11:30:15', 'pixelart'),
(30, 'alpha_user@beta.io', '2024-03-01 10:00:00', 'alphauser'),
(31, 'beta_tester@beta.io', '2024-03-02 11:05:00', 'betatester'),
(32, 'gamma_ray@physics.org', '2024-03-05 16:40:20', 'gammaray'),
(33, 'delta_force@security.net', '2024-03-10 23:15:00', 'deltaf'),
(34, 'echo_chamber@sound.com', '2024-03-12 08:20:00', 'echo_c'),
(35, 'fox_trot@dance.edu', '2024-03-15 19:45:00', 'foxtrot'),
(36, 'golf_pro@links.com', '2024-03-18 13:10:10', 'golfpro'),
(37, 'hotel_cal@travel.net', '2024-03-20 06:00:00', 'h_california'),
(38, 'india_ink@print.com', '2024-03-22 17:30:45', 'i_ink'),
(39, 'juliet_r@shakespeare.uk', '2024-03-25 20:15:00', 'jromeo'),
(40, 'kilo_gram@metric.org', '2024-03-28 12:00:00', 'kilo_g'),
(41, 'lima_bean@garden.com', '2024-04-01 09:40:00', 'limabean'),
(42, 'mike_check@audio.io', '2024-04-03 14:50:30', 'mike123'),
(43, 'nov_star@astronomy.net', '2024-04-05 22:10:00', 'novastar'),
(44, 'oscar_winner@movies.com', '2024-04-08 18:25:00', 'oscar_w'),
(45, 'papa_john@pizza.org', '2024-04-10 11:15:00', 'papajohn'),
(46, 'quebec_native@canada.ca', '2024-04-12 08:05:55', 'quebec_n'),
(47, 'romeo_m@shakespeare.uk', '2024-04-15 21:40:00', 'romeo_m'),
(48, 'sierra_mist@drinks.com', '2024-04-18 15:55:00', 'sierramist'),
(49, 'tango_down@gaming.net', '2024-04-20 02:30:00', 'tangod'),
(50, 'uniform_char@code.io', '2024-04-22 10:20:10', 'uniform_c'),
(51, 'victor_v@win.com', '2024-04-25 13:45:00', 'victor_v'),
(52, 'whiskey_sour@bar.net', '2024-04-28 23:50:00', 'wsour'),
(53, 'xray_vision@hero.org', '2024-05-01 07:10:00', 'xray_v'),
(54, 'yankee_doodle@history.edu', '2024-05-03 16:20:30', 'yankee_d'),
(55, 'zulu_time@clock.com', '2024-05-05 12:00:00', 'zulu_t'),
(56, 'sky_walker@force.net', '2024-05-08 19:30:00', 'skywalker'),
(57, 'cloud_nine@weather.com', '2024-05-10 11:11:11', 'cloud9'),
(58, 'ocean_blue@sea.org', '2024-05-12 08:45:00', 'oceanblue'),
(59, 'forest_green@nature.net', '2024-05-15 14:00:00', 'f_green'),
(60, 'mountain_high@peaks.com', '2024-05-18 10:25:40', 'mtnhigh');

SELECT setval('users_user_id_seq', 61);

INSERT INTO Favorite_Parts (user_id, part_id) VALUES
(1, 45), (1, 102), (3, 12), (3, 489), (5, 210),
(7, 33), (7, 56), (7, 401), (10, 15), (12, 88),
(12, 450), (15, 22), (18, 312), (20, 5), (21, 199),
(22, 42), (25, 367), (25, 10), (28, 281), (30, 150),
(31, 444), (32, 12), (35, 99), (35, 100), (38, 27),
(40, 480), (41, 230), (42, 55), (44, 310), (45, 11),
(48, 8), (50, 490), (51, 123), (53, 201), (55, 333),
(57, 19), (58, 400), (59, 2), (60, 47), (60, 48);

INSERT INTO Part_Review (user_id, part_id, review_time, rating, comment) VALUES
(1, 45, '2024-05-20 09:00:00', 5, 'Exceptional build quality, very impressed.'),
(3, 12, '2024-05-21 14:22:10', 4, 'Solid performance, but shipping took a while.'),
(5, 210, '2024-05-22 11:05:00', 2, 'Did not fit as described in the manual.'),
(7, 33, '2024-05-23 16:45:30', 5, 'Perfect replacement part. Works like a charm.'),
(10, 15, '2024-05-24 10:30:00', 3, 'Average quality, expected a bit more for the price.'),
(12, 88, '2024-05-25 08:15:00', 1, 'Broke within the first week of use.'),
(15, 22, '2024-05-26 19:20:00', 4, 'Great value for money. Would buy again.'),
(18, 312, '2024-05-27 13:10:00', 5, 'Top-tier materials used here.'),
(20, 5, '2024-05-28 17:55:45', 3, 'Does the job, but instructions were vague.'),
(21, 199, '2024-05-29 09:40:00', 5, 'Seamless integration with my current setup.'),
(22, 42, '2024-05-30 12:00:00', 4, 'Very durable, though a bit heavy.'),
(25, 367, '2024-06-01 15:30:20', 2, 'Packaging was damaged upon arrival.'),
(28, 281, '2024-06-02 11:15:00', 5, 'Highly recommended for professional use.'),
(30, 150, '2024-06-03 14:00:00', 4, 'Good balance of price and performance.'),
(31, 444, '2024-06-04 10:45:00', 1, 'Defective unit, had to return immediately.'),
(32, 12, '2024-06-05 08:20:00', 5, 'Best in class for this specific part ID.'),
(35, 99, '2024-06-06 21:10:00', 3, 'It is okay, but there are better alternatives.'),
(38, 27, '2024-06-07 13:50:00', 4, 'Easy to install and very reliable.'),
(40, 480, '2024-06-08 16:30:00', 5, 'Exceeded all my expectations!'),
(41, 230, '2024-06-09 09:10:00', 2, 'Not compatible with older models as claimed.'),
(42, 55, '2024-06-10 12:45:00', 4, 'Sleek design and functions perfectly.'),
(44, 310, '2024-06-11 18:20:15', 5, 'A must-have for any serious enthusiast.'),
(45, 11, '2024-06-12 11:00:00', 3, 'Decent, but I noticed some minor wear early on.'),
(48, 8, '2024-06-13 07:55:00', 5, 'Fast delivery and excellent quality control.'),
(50, 490, '2024-06-14 20:30:00', 4, 'Reliable part, no complaints so far.'),
(51, 123, '2024-06-15 15:40:00', 1, 'Completely different from the pictures.'),
(53, 201, '2024-06-16 10:15:00', 5, 'Precision engineering at its finest.'),
(55, 333, '2024-06-17 19:00:00', 4, 'Great customer support when I had questions.'),
(57, 19, '2024-06-18 12:20:00', 3, 'Funcional, but the finish is a bit rough.'),
(58, 400, '2024-06-19 08:45:00', 5, 'Absolutely worth the investment.'),
(59, 2, '2024-06-20 14:10:00', 2, 'Underperformed during high-stress testing.'),
(60, 47, '2024-06-21 17:50:00', 5, 'I am buying a second one for my other rig.'),
(7, 56, '2024-06-22 09:30:00', 4, 'Stable and efficient, no issues encountered.'),
(25, 10, '2024-06-23 11:05:00', 5, 'Brilliant design and very easy to configure.'),
(35, 100, '2024-06-24 13:15:00', 3, 'Middle of the road, does what it says.'),
(60, 48, '2024-06-25 10:00:00', 4, 'Quick setup, worked right out of the box.'),
(2, 150, '2024-06-26 15:20:00', 5, 'The best part I have purchased this year.'),
(14, 22, '2024-06-27 18:40:00', 4, 'Good longevity, still going strong.'),
(49, 310, '2024-06-28 08:55:00', 2, 'Price is a bit steep for the utility offered.'),
(56, 5, '2024-06-29 12:30:00', 5, 'Flawless performance under load.');

INSERT INTO PCs (pc_id, cpu, psu, ram_kit, gpu, motherboard, pc_case, cooler, user_id, name, created_on) VALUES
(31, 75, 195, 140, 255, 435, 375, 315, 21, 'Alpha Machine', '2025-06-05 10:00:00'),
(32, 82, 202, 155, 260, 442, 380, NULL, 22, 'Beta Box', '2025-06-12 14:30:00'),
(33, 110, 240, 180, 305, 485, 425, 365, 23, 'Gamma Gaming', '2025-07-01 09:15:20'),
(34, 95, 215, 162, NULL, 460, 395, 340, 24, 'Delta Dev', '2025-07-15 18:45:00'),
(35, 128, 248, 188, 309, 488, 428, 368, 25, 'Epsilon Elite', '2025-08-02 21:00:00'),
(36, 71, 191, 131, 251, 431, 371, 311, 26, 'Zeta Zero', '2025-08-05 08:00:00'),
(37, 88, 210, 145, 265, 450, 385, 330, 27, 'Eta Engine', '2025-08-10 11:20:00'),
(38, NULL, 230, 175, 290, 475, 410, 355, 28, 'Theta Thinker', '2025-08-18 16:10:00'),
(39, 101, 222, 160, 280, 465, 400, 345, 29, 'Iota Iron', '2025-08-22 13:40:00'),
(40, 78, 198, 138, 258, 438, 378, 318, 30, 'Kappa Korpus', '2025-09-01 10:05:00'),
(41, 120, 245, 185, 300, 480, 420, 360, 31, 'Lambda Light', '2025-09-05 22:30:00'),
(42, 92, 205, 150, 270, 445, NULL, 325, 32, 'Mu Master', '2025-09-12 07:15:00'),
(43, 105, 225, 168, 285, 468, 405, 348, 33, 'Nu Nexus', '2025-09-18 19:50:00'),
(44, 112, 235, 172, 295, 472, 415, 352, 34, 'Xi X-Stream', '2025-09-24 14:00:00'),
(45, 85, 212, 142, NULL, 455, 382, 335, 35, 'Omicron One', '2025-10-01 09:10:00'),
(46, 125, 249, 189, 308, 489, 429, 369, 36, 'Pi Power', '2025-10-05 23:45:00'),
(47, 72, 192, 133, 252, 432, 372, 312, 37, 'Rho Runner', '2025-10-10 12:00:00'),
(48, 98, 218, 158, 278, NULL, 398, 338, 38, 'Sigma Solid', '2025-10-14 16:25:00'),
(49, 108, 238, 178, 298, 478, 418, 358, 39, 'Tau Titan', '2025-10-20 20:30:00'),
(50, 80, 200, 148, 268, 440, 388, 328, 40, 'Upsilon Ultra', '2025-10-25 08:45:00'),
(51, 118, 232, 182, 302, 482, 422, 362, 41, 'Phi Phantom', '2025-11-01 10:15:00'),
(52, 89, 208, 152, 256, 448, 384, NULL, 42, 'Chi Craft', '2025-11-03 15:40:00'),
(53, 103, 228, 165, 288, 462, 402, 342, 43, 'Psi Prime', '2025-11-05 11:10:00'),
(54, 122, 242, 186, 306, 486, 426, 366, 44, 'Omega Orbit', '2025-11-08 19:20:00'),
(55, 76, 196, 136, 256, 436, 376, 316, 45, 'Solaris', '2025-11-10 09:00:00'),
(56, 114, 234, 174, 294, 474, 414, 354, 46, 'Nebula', '2025-11-12 17:35:00'),
(57, 94, 214, 154, 274, 454, 394, 334, 47, 'Pulsar', '2025-11-15 13:50:00'),
(58, 126, 246, 187, 307, 487, 427, 367, 48, 'Quasar', '2025-11-18 21:05:00'),
(59, 73, 193, 134, 253, 433, 373, 313, 49, 'Supernova', '2025-11-20 08:30:00'),
(60, 106, 226, 166, 286, 466, 406, 346, 50, 'BlackHole', '2025-11-22 14:15:00'),
(61, 84, 204, NULL, 264, 444, 384, 324, 1, 'ProtoBuild', '2025-11-25 11:55:00'),
(62, 111, 231, 171, 291, 471, 411, 351, 5, 'Vanguard', '2025-11-28 16:40:00'),
(63, 79, 199, 139, 259, 439, 379, 319, 10, 'Horizon', '2025-12-01 10:20:00'),
(64, 119, 239, 179, 299, 479, 419, 359, 15, 'Apex', '2025-12-02 22:10:00'),
(65, 100, NULL, 161, 281, 461, 401, 341, 20, 'Zenith', '2025-12-03 09:50:00'),
(66, 81, 201, 141, 261, 441, 381, 321, 55, 'Eclipse', '2025-12-04 12:30:00'),
(67, 129, 250, 190, 310, 490, 430, 370, 60, 'Final Boss', '2025-12-05 00:01:00'),
(68, 77, 197, 137, 257, 437, 377, 317, 3, 'Mini Mac', '2026-01-05 08:20:00'),
(69, 104, 224, 164, 284, 464, 404, 344, 7, 'Iron Clad', '2026-01-05 11:45:00'),
(70, 117, 237, 177, 297, 477, 417, 357, 12, 'Turbo', '2026-01-05 13:07:00');

SELECT setval('pcs_pc_id_seq', 71);

-- Part_Type_Map table inserts
INSERT INTO Part_Type_Map (part_id, part_type)
SELECT part_id, 'CPU' FROM CPU;
 
INSERT INTO Part_Type_Map (part_id, part_type)
SELECT part_id, 'GPU' FROM GPU;
 
INSERT INTO Part_Type_Map (part_id, part_type)
SELECT part_id, 'RAM' FROM RAM;
 
INSERT INTO Part_Type_Map (part_id, part_type)
SELECT part_id, 'PSU' FROM PSU;
 
INSERT INTO Part_Type_Map (part_id, part_type)
SELECT part_id, 'MOTHERBOARD' FROM Motherboard;
 
INSERT INTO Part_Type_Map (part_id, part_type)
SELECT part_id, 'CASE' FROM PC_Case;
 
INSERT INTO Part_Type_Map (part_id, part_type)
SELECT part_id, 'COOLER' FROM Cooler;