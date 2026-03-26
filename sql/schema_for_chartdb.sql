-- ================================
-- HIMALAYAN EXPEDITIONS DATABASE
-- ChartDB Compatible Schema Export
-- ================================

-- Lookup Tables (Referenced by other tables)
CREATE TABLE season_lookup (
    SeasonKey INT PRIMARY KEY IDENTITY(1,1),
    SeasonName VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE citizenship_lookup (
    CitizenshipKey INT PRIMARY KEY IDENTITY(1,1),
    CountryCode VARCHAR(50) UNIQUE NOT NULL
);

-- Core Dimension Tables
CREATE TABLE peaks (
    peakid INT PRIMARY KEY,
    pkname VARCHAR(255),
    heightm INT,
    himal VARCHAR(50),
    region VARCHAR(50),
    pexpid VARCHAR(20),
    pstatus VARCHAR(50)
);

-- Fact Table (Central)
CREATE TABLE exped (
    ExpeditionKey INT PRIMARY KEY IDENTITY(1,1),
    expid VARCHAR(20),
    [year] INT,
    season VARCHAR(30),
    SeasonKey INT FOREIGN KEY REFERENCES season_lookup(SeasonKey),
    peakid INT FOREIGN KEY REFERENCES peaks(peakid),
    totmembers INT,
    smtmembers INT,
    hired INT,
    deaths INT,
    basecamp_date DATE,
    highpoint_date DATE,
    termination_date DATE,
    termination_reason VARCHAR(100),
    o2used CHAR(1),
    traverse CHAR(1),
    ski CHAR(1),
    parapente CHAR(1),
    nocamps INT,
    nonlocaldeaths INT,
    nondeaths INT,
    firstascentdate DATE,
    agency VARCHAR(100),
    rgn_agency_id VARCHAR(50),
    checksum BIGINT,
    claimed VARCHAR(20),
    disputed VARCHAR(20),
    UNIQUE(expid, [year])
);

-- Core Dimension Tables
CREATE TABLE members (
    MemberKey INT PRIMARY KEY IDENTITY(1,1),
    membid VARCHAR(20),
    expid VARCHAR(20),
    myear INT,
    ExpeditionKey INT FOREIGN KEY REFERENCES exped(ExpeditionKey),
    fname VARCHAR(100),
    lname VARCHAR(100),
    cit_alpha VARCHAR(50),
    CitizenshipKey INT FOREIGN KEY REFERENCES citizenship_lookup(CitizenshipKey),
    peakid INT,
    smtdate DATE,
    smttime TIME,
    ascent VARCHAR(50),
    mo2used CHAR(1),
    mo2none INT,
    mo2climb INT,
    mo2descent INT,
    mroute VARCHAR(100),
    death CHAR(1),
    deathtype VARCHAR(50),
    deathdate DATE,
    deathtime TIME,
    UNIQUE(membid, expid, myear)
);

CREATE TABLE refer (
    ReferenceKey INT PRIMARY KEY IDENTITY(1,1),
    refid VARCHAR(20),
    expid VARCHAR(20),
    ryear INT,
    ExpeditionKey INT FOREIGN KEY REFERENCES exped(ExpeditionKey),
    title VARCHAR(500),
    isbn VARCHAR(20),
    pages INT,
    publication_year INT,
    UNIQUE(refid, expid, ryear)
);

-- Expedition Child Tables (Dimensions)
CREATE TABLE expedition_timeline (
    TimelineKey INT PRIMARY KEY IDENTITY(1,1),
    ExpeditionKey INT FOREIGN KEY REFERENCES exped(ExpeditionKey),
    basecamp_date DATE,
    highpoint_date DATE,
    termination_date DATE,
    termination_reason VARCHAR(100)
);

CREATE TABLE expedition_statistics (
    StatisticsKey INT PRIMARY KEY IDENTITY(1,1),
    ExpeditionKey INT FOREIGN KEY REFERENCES exped(ExpeditionKey),
    totmembers INT,
    smtmembers INT,
    hired INT,
    deaths INT
);

CREATE TABLE expedition_incidents (
    IncidentKey INT PRIMARY KEY IDENTITY(1,1),
    ExpeditionKey INT FOREIGN KEY REFERENCES exped(ExpeditionKey),
    nonlocaldeaths INT,
    nondeaths INT,
    firstascentdate DATE
);
