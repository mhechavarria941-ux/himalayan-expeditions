/*
====================================================================
HIMALAYAN EXPEDITIONS - SCHEMA FOR CHARTDB VISUALIZATION
====================================================================
INSTRUCTIONS:
1. Copy this entire script
2. Go to https://www.chartdb.io
3. Click "Import SQL"
4. Paste this script
5. Click "Import" - ChartDB will automatically create the visual schema

This script creates all 16 tables with complete relationships.
ChartDB will parse it and generate a beautiful ERD (Entity Relationship Diagram).
====================================================================
*/

-- LOOKUP TABLES (Foundation)
CREATE TABLE season_lookup (
    SeasonKey INT PRIMARY KEY,
    Season NVARCHAR(50) NOT NULL
);

CREATE TABLE citizenship_lookup (
    CitizenshipKey INT PRIMARY KEY,
    Citizenship NVARCHAR(100) NOT NULL
);

-- BASE TABLES (Core Data)
CREATE TABLE peaks (
    peakid INT PRIMARY KEY,
    peak_name NVARCHAR(100) NOT NULL,
    heightmeters DECIMAL(10, 2),
    heightfeet DECIMAL(10, 2),
    climbing_attempts INT,
    first_ascent_year INT,
    first_ascent_country NVARCHAR(50),
    popular_climbing_season NVARCHAR(50)
);

CREATE TABLE exped (
    ExpeditionKey INT PRIMARY KEY,
    peakid INT NOT NULL,
    SeasonKey INT NOT NULL,
    year INT,
    season NVARCHAR(50),
    basecamp_date DATETIME,
    highpoint_date DATETIME,
    termination_date DATETIME,
    termination_reason NVARCHAR(255),
    success NVARCHAR(10),
    members_count INT,
    members_hired INT,
    oxygen_used NVARCHAR(10),
    FOREIGN KEY (peakid) REFERENCES peaks(peakid),
    FOREIGN KEY (SeasonKey) REFERENCES season_lookup(SeasonKey)
);

CREATE TABLE members (
    MemberKey INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    member_id INT,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    CitizenshipKey INT NOT NULL,
    age INT,
    experience_level NVARCHAR(50),
    hired NVARCHAR(10),
    death NVARCHAR(10),
    death_cause NVARCHAR(255),
    death_height_metres INT,
    death_height_feet INT,
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey),
    FOREIGN KEY (CitizenshipKey) REFERENCES citizenship_lookup(CitizenshipKey)
);

CREATE TABLE refer (
    ReferenceKey INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    reference_id INT,
    reference_text NVARCHAR(MAX),
    publication_year INT,
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

-- DECOMPOSITION TABLES (Exped Extensions)
CREATE TABLE expedition_timeline (
    expedition_timeline_id INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    basecamp_date DATETIME,
    highpoint_date DATETIME,
    termination_date DATETIME,
    expedition_duration_days INT,
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

CREATE TABLE expedition_routes (
    expedition_routes_id INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    route_name NVARCHAR(100),
    route_type NVARCHAR(100),
    primary_route NVARCHAR(10),
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

CREATE TABLE expedition_outcomes (
    expedition_outcomes_id INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    success_status NVARCHAR(50),
    members_reached_summit INT,
    members_attempted INT,
    termination_reason NVARCHAR(255),
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

CREATE TABLE expedition_statistics (
    expedition_statistics_id INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    members_count INT,
    members_hired INT,
    guides_count INT,
    porters_count INT,
    total_deaths INT,
    guides_deaths INT,
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

CREATE TABLE expedition_style (
    expedition_style_id INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    climbing_style NVARCHAR(100),
    oxygen_used NVARCHAR(10),
    permits_obtained NVARCHAR(10),
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

CREATE TABLE expedition_oxygen (
    expedition_oxygen_id INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    oxygen_used NVARCHAR(10),
    oxygen_bottles_used INT,
    members_using_oxygen INT,
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

CREATE TABLE expedition_camps (
    expedition_camps_id INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    camp_number INT,
    camp_altitude_metres INT,
    camp_altitude_feet INT,
    camp_date DATETIME,
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

CREATE TABLE expedition_incidents (
    expedition_incidents_id INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    incident_type NVARCHAR(100),
    incident_date DATETIME,
    incident_altitude DECIMAL(10, 2),
    casualties INT,
    description NVARCHAR(MAX),
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

CREATE TABLE expedition_reference_summary (
    expedition_reference_summary_id INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    reference_count INT,
    primary_source NVARCHAR(255),
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

CREATE TABLE expedition_admin (
    expedition_admin_id INT PRIMARY KEY,
    ExpeditionKey INT NOT NULL,
    data_source NVARCHAR(100),
    data_import_date DATETIME,
    notes NVARCHAR(MAX),
    FOREIGN KEY (ExpeditionKey) REFERENCES exped(ExpeditionKey)
);

-- ===================================================================
-- SCHEMA SUMMARY
-- ===================================================================
/*
✅ 16 TABLES TOTAL:

BASE TABLES (4):
├─ peaks (480 records)
├─ exped (11,425 records - HUB)
├─ members (89,000+ records)
└─ refer (15,586 records)

LOOKUP TABLES (2):
├─ season_lookup (4 seasons)
└─ citizenship_lookup (countries)

DECOMPOSITION TABLES (10):
├─ expedition_timeline
├─ expedition_routes
├─ expedition_outcomes
├─ expedition_statistics
├─ expedition_style
├─ expedition_oxygen
├─ expedition_camps
├─ expedition_incidents
├─ expedition_reference_summary
└─ expedition_admin

STAR SCHEMA DESIGN:
- exped is the HUB table
- All decomposition tables have FK → exped
- members & refer have FK → exped
- exped has FK → peaks & season_lookup
- members has FK → citizenship_lookup

TOTAL RELATIONSHIPS: 14 Foreign Keys
*/
