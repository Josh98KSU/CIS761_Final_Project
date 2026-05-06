-- ============================================================
-- CIS761 PC Builder Database - tables.sql
-- Creates all tables with primary keys, foreign keys,
-- and referential integrity constraints.
-- ============================================================

-- Drop functions in reverse dependency order for clean re-runs
DROP FUNCTION IF EXISTS sync_part_type_map CASCADE;

-- Drop tables in reverse dependency order for clean re-runs
DROP TABLE IF EXISTS Part_Type_Map;
DROP TABLE IF EXISTS Part_Review;
DROP TABLE IF EXISTS Favorite_Parts;
DROP TABLE IF EXISTS PCs;
DROP TABLE IF EXISTS Cooler;
DROP TABLE IF EXISTS PC_Case;
DROP TABLE IF EXISTS GPU;
DROP TABLE IF EXISTS Motherboard;
DROP TABLE IF EXISTS RAM;
DROP TABLE IF EXISTS PSU;
DROP TABLE IF EXISTS CPU;
DROP TABLE IF EXISTS PC_Parts;
DROP TABLE IF EXISTS Users;

-- ============================================================
-- Users
-- No additional unique keys beyond PK.
-- ============================================================
CREATE TABLE Users (
    user_id     SERIAL PRIMARY KEY,
    email       VARCHAR(255) NOT NULL UNIQUE,
    username    VARCHAR(100) NOT NULL UNIQUE,
    created_on  TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- ============================================================
-- PC_Parts  (supertype for all part subtypes)
-- No additional unique keys beyond PK.
-- ============================================================
CREATE TABLE PC_Parts (
    part_id     SERIAL PRIMARY KEY,
    manufacturer VARCHAR(100) NOT NULL,
    name         VARCHAR(255) NOT NULL,
    release_date DATE,
    price        NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    description  TEXT
);

-- ============================================================
-- CPU  (subtype of PC_Parts)
-- part_id is both PK and FK → PC_Parts.
-- No additional unique keys.
-- ============================================================
CREATE TABLE CPU (
    part_id             INT PRIMARY KEY REFERENCES PC_Parts(part_id) ON DELETE CASCADE,
    socket              VARCHAR(50)  NOT NULL,
    thermal_design_power INT         NOT NULL CHECK (thermal_design_power > 0),
    core_count          INT          NOT NULL CHECK (core_count > 0),
    base_clock          NUMERIC(5,2) NOT NULL,
    thread_count        INT          NOT NULL CHECK (thread_count > 0),
    boost_clock         NUMERIC(5,2) NOT NULL
);

-- ============================================================
-- PSU
-- ============================================================
CREATE TABLE PSU (
    part_id    INT PRIMARY KEY REFERENCES PC_Parts(part_id) ON DELETE CASCADE,
    modular    VARCHAR(20) NOT NULL CHECK (modular IN ('Full', 'Semi', 'Non-Modular')),
    wattage    INT         NOT NULL CHECK (wattage > 0),
    efficiency VARCHAR(20) NOT NULL  -- e.g. '80+ Gold'
);

-- ============================================================
-- RAM
-- ============================================================
CREATE TABLE RAM (
    part_id       INT PRIMARY KEY REFERENCES PC_Parts(part_id) ON DELETE CASCADE,
    ram_type      VARCHAR(20)  NOT NULL,   -- DDR4, DDR5 …
    num_of_sticks INT          NOT NULL CHECK (num_of_sticks > 0),
    capacity      INT          NOT NULL CHECK (capacity > 0),  -- GB
    speed         INT          NOT NULL CHECK (speed > 0)       -- MHz
);

-- ============================================================
-- GPU
-- ============================================================
CREATE TABLE GPU (
    part_id          INT PRIMARY KEY REFERENCES PC_Parts(part_id) ON DELETE CASCADE,
    vram             INT          NOT NULL CHECK (vram > 0),   -- GB
    chipset          VARCHAR(100) NOT NULL,
    length_mm        INT          NOT NULL CHECK (length_mm > 0),
    power_connectors VARCHAR(50)  NOT NULL
);

-- ============================================================
-- Motherboard
-- ============================================================
CREATE TABLE Motherboard (
    part_id     INT PRIMARY KEY REFERENCES PC_Parts(part_id) ON DELETE CASCADE,
    socket      VARCHAR(50)  NOT NULL,
    chipset     VARCHAR(50)  NOT NULL,
    ram_type    VARCHAR(20)  NOT NULL,
    form_factor VARCHAR(20)  NOT NULL,  -- ATX, mATX, ITX …
    max_ram     INT          NOT NULL CHECK (max_ram > 0)  -- GB
);

-- ============================================================
-- PC_Case
-- ============================================================
CREATE TABLE PC_Case (
    part_id      INT PRIMARY KEY REFERENCES PC_Parts(part_id) ON DELETE CASCADE,
    max_gpu_size INT          NOT NULL CHECK (max_gpu_size > 0),  -- mm
    form_factor  VARCHAR(20)  NOT NULL,
    color        VARCHAR(50)
);

-- ============================================================
-- Cooler
-- ============================================================
CREATE TABLE Cooler (
    part_id     INT PRIMARY KEY REFERENCES PC_Parts(part_id) ON DELETE CASCADE,
    cooler_type VARCHAR(30)  NOT NULL,   -- Air, AIO 240mm …
    socket_type VARCHAR(100) NOT NULL    -- comma-separated sockets supported
);

-- ============================================================
-- PCs  (a user's saved PC build; all part slots are optional
--       so the user can save an incomplete build)
-- No additional unique keys beyond PK.
-- ============================================================
CREATE TABLE PCs (
    pc_id       SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    user_id     INT          NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    cpu         INT REFERENCES CPU(part_id)         ON DELETE SET NULL,
    psu         INT REFERENCES PSU(part_id)         ON DELETE SET NULL,
    ram_kit     INT REFERENCES RAM(part_id)         ON DELETE SET NULL,
    gpu         INT REFERENCES GPU(part_id)         ON DELETE SET NULL,
    motherboard INT REFERENCES Motherboard(part_id) ON DELETE SET NULL,
    pc_case     INT REFERENCES PC_Case(part_id)      ON DELETE SET NULL,
    cooler      INT REFERENCES Cooler(part_id)      ON DELETE SET NULL,
    created_on  TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ============================================================
-- Favorite_Parts  (join table: Users ↔ PC_Parts)
-- PK is composite (user_id, part_id). No additional unique keys.
-- ============================================================
CREATE TABLE Favorite_Parts (
    user_id INT NOT NULL REFERENCES Users(user_id)    ON DELETE CASCADE,
    part_id INT NOT NULL REFERENCES PC_Parts(part_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, part_id)
);

-- ============================================================
-- Part_Review  (join table: Users ↔ PC_Parts, with timestamp
--              to allow a user to review the same part again
--              at a different time)
-- PK is composite (user_id, part_id, timestamp).
-- No additional unique keys.
-- ============================================================
CREATE TABLE Part_Review (
    user_id   INT            NOT NULL REFERENCES Users(user_id)    ON DELETE CASCADE,
    part_id   INT            NOT NULL REFERENCES PC_Parts(part_id) ON DELETE CASCADE,
    review_time TIMESTAMP      NOT NULL DEFAULT NOW(),
    rating    INT            NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment   TEXT,
    PRIMARY KEY (user_id, part_id, review_time)
);

-- ============================================================
-- Part_Type_Map  (join table: part tables ↔ PC_Parts)
-- PK is (part_id).
-- No additional unique keys.
-- ============================================================
CREATE TABLE Part_Type_Map (
    part_id INT PRIMARY KEY REFERENCES PC_Parts(part_id) ON DELETE CASCADE,
    part_type VARCHAR(20) NOT NULL
    CHECK (part_type IN ('CPU','GPU','RAM','MOTHERBOARD','PSU','PC_CASE','COOLER'))
);

-- ============================================================
-- TRIGGER LOGIC FOR PART_TYPE_MAP
-- ============================================================

-- 1. Single reusable function for all part types
CREATE OR REPLACE FUNCTION sync_part_type_map()
RETURNS TRIGGER AS $$
DECLARE
    part_type_val TEXT;
BEGIN

    CASE TG_TABLE_NAME
        WHEN 'cpu' THEN part_type_val := 'CPU';
        WHEN 'gpu' THEN part_type_val := 'GPU';
        WHEN 'ram' THEN part_type_val := 'RAM';
        WHEN 'motherboard' THEN part_type_val := 'MOTHERBOARD';
        WHEN 'psu' THEN part_type_val := 'PSU';
        WHEN 'pc_case' THEN part_type_val := 'PC_CASE';
        WHEN 'cooler' THEN part_type_val := 'COOLER';
    END CASE;

    INSERT INTO Part_Type_Map (part_id, part_type)
    VALUES (NEW.part_id, part_type_val)
    ON CONFLICT (part_id) DO NOTHING;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Drop existing triggers to ensure clean re-runs of the script
DROP TRIGGER IF EXISTS tr_cpu_sync ON CPU;
DROP TRIGGER IF EXISTS tr_gpu_sync ON GPU;
DROP TRIGGER IF EXISTS tr_ram_sync ON RAM;
DROP TRIGGER IF EXISTS tr_mobo_sync ON Motherboard;
DROP TRIGGER IF EXISTS tr_psu_sync ON PSU;
DROP TRIGGER IF EXISTS tr_case_sync ON PC_Case;
DROP TRIGGER IF EXISTS tr_cooler_sync ON Cooler;

-- 3. Attach the trigger to every specific part table
CREATE TRIGGER tr_cpu_sync    AFTER INSERT ON CPU         FOR EACH ROW EXECUTE FUNCTION sync_part_type_map();
CREATE TRIGGER tr_gpu_sync    AFTER INSERT ON GPU         FOR EACH ROW EXECUTE FUNCTION sync_part_type_map();
CREATE TRIGGER tr_ram_sync    AFTER INSERT ON RAM         FOR EACH ROW EXECUTE FUNCTION sync_part_type_map();
CREATE TRIGGER tr_mobo_sync   AFTER INSERT ON Motherboard  FOR EACH ROW EXECUTE FUNCTION sync_part_type_map();
CREATE TRIGGER tr_psu_sync    AFTER INSERT ON PSU         FOR EACH ROW EXECUTE FUNCTION sync_part_type_map();
CREATE TRIGGER tr_case_sync   AFTER INSERT ON PC_Case      FOR EACH ROW EXECUTE FUNCTION sync_part_type_map();
CREATE TRIGGER tr_cooler_sync AFTER INSERT ON Cooler      FOR EACH ROW EXECUTE FUNCTION sync_part_type_map();
