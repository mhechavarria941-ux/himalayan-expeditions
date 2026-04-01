-- =========================================================
-- POPULATE DECOMPOSITION TABLES
-- Now that CSV data is fully loaded with all source columns
-- =========================================================

USE [Final_Project];
GO

-- =========================================================
-- 1) POPULATE MEMBER_PERSON
-- Extract unique members from members table
-- =========================================================
PRINT '========== POPULATING MEMBER_PERSON ==========';

INSERT INTO dbo.member_person (membid, CitizenshipKey, fname, lname, sex, yob, residence, occupation, hcn)
SELECT DISTINCT
    m.membid,
    cr.CitizenshipKey,
    m.fname,
    m.lname,
    m.sex,
    m.yob,
    m.residence,
    m.occupation,
    m.hcn
FROM dbo.members m
LEFT JOIN dbo.citizenship_lookup cr ON m.citizen = cr.CitizenName
WHERE m.membid IS NOT NULL
GROUP BY m.membid, m.fname, m.lname, m.sex, m.yob, m.residence, m.occupation, m.hcn, cr.CitizenshipKey;

PRINT 'member_person rows inserted: ' + CAST(@@ROWCOUNT AS VARCHAR(10));
GO

-- =========================================================
-- 2) POPULATE MEMBER_PARTICIPATION
-- One row per member participation in expedition
-- =========================================================
PRINT '========== POPULATING MEMBER_PARTICIPATION ==========';

INSERT INTO dbo.member_participation (
    LegacyMemberKey, PersonKey, ExpeditionKey, 
    expid, peakid, myear, mseason,
    [status], leader, deputy, bconly, nottobc, support, disabled, hired, sherpa, tibetan,
    msuccess, mclaimed, mdisputed, msolo, mtraverse, mski, mparapente, mspeed, 
    mhighpt, mperhighpt,
    mo2used, mo2none, mo2climb, mo2descent, mo2sleep, mo2medical, mo2note,
    death, deathdate, deathtime, deathtype, deathhgtm, deathclass, msmtbid, msmtterm
)
SELECT 
    m.MemberKey,
    p.PersonKey,
    e.ExpeditionKey,
    m.expid,
    m.peakid,
    m.myear,
    m.mseason,
    m.[status],
    m.leader,
    m.deputy,
    m.bconly,
    m.nottobc,
    m.support,
    m.disabled,
    m.hired,
    m.sherpa,
    m.tibetan,
    m.msuccess,
    m.mclaimed,
    m.mdisputed,
    m.msolo,
    m.mtraverse,
    m.mski,
    m.mparapente,
    m.mspeed,
    m.mhighpt,
    m.mperhighpt,
    m.mo2used,
    m.mo2none,
    m.mo2climb,
    m.mo2descent,
    m.mo2sleep,
    m.mo2medical,
    m.mo2note,
    m.death,
    m.deathdate,
    m.deathtime,
    m.deathtype,
    m.deathhgtm,
    m.deathclass,
    m.msmtbid,
    m.msmtterm
FROM dbo.members m
LEFT JOIN dbo.member_person p ON m.membid = p.membid
LEFT JOIN dbo.exped e ON m.expid = e.expid AND m.myear = CAST(e.[year] AS NVARCHAR(50));

PRINT 'member_participation rows inserted: ' + CAST(@@ROWCOUNT AS VARCHAR(10));
GO

-- =========================================================
-- 3) POPULATE MEMBER_ROUTES
-- One row per route per member per expedition
-- =========================================================
PRINT '========== POPULATING MEMBER_ROUTES ==========';

INSERT INTO dbo.member_routes (MemberParticipationKey, RouteNumber, RouteDescription)
SELECT 
    mp.MemberParticipationKey,
    1 AS RouteNumber,
    m.mroute1 AS RouteDescription
FROM dbo.member_participation mp
INNER JOIN dbo.members m ON mp.LegacyMemberKey = m.MemberKey
WHERE m.mroute1 IS NOT NULL AND m.mroute1 <> ''

UNION ALL

SELECT 
    mp.MemberParticipationKey,
    2 AS RouteNumber,
    m.mroute2
FROM dbo.member_participation mp
INNER JOIN dbo.members m ON mp.LegacyMemberKey = m.MemberKey
WHERE m.mroute2 IS NOT NULL AND m.mroute2 <> ''

UNION ALL

SELECT 
    mp.MemberParticipationKey,
    3 AS RouteNumber,
    m.mroute3
FROM dbo.member_participation mp
INNER JOIN dbo.members m ON mp.LegacyMemberKey = m.MemberKey
WHERE m.mroute3 IS NOT NULL AND m.mroute3 <> '';

PRINT 'member_routes rows inserted: ' + CAST(@@ROWCOUNT AS VARCHAR(10));
GO

-- =========================================================
-- 4) POPULATE MEMBER_SUMMITS
-- One row per summit attempt slot per member per expedition
-- =========================================================
PRINT '========== POPULATING MEMBER_SUMMITS ==========';

INSERT INTO dbo.member_summits (MemberParticipationKey, SummitNumber, SummitDate, SummitTime, AscentDescription)
SELECT 
    mp.MemberParticipationKey,
    1 AS SummitNumber,
    m.msmtdate1 AS SummitDate,
    m.msmttime1 AS SummitTime,
    m.mascent1 AS AscentDescription
FROM dbo.member_participation mp
INNER JOIN dbo.members m ON mp.LegacyMemberKey = m.MemberKey
WHERE m.msmtdate1 IS NOT NULL OR m.mascent1 IS NOT NULL

UNION ALL

SELECT 
    mp.MemberParticipationKey,
    2 AS SummitNumber,
    m.msmtdate2,
    m.msmttime2,
    m.mascent2
FROM dbo.member_participation mp
INNER JOIN dbo.members m ON mp.LegacyMemberKey = m.MemberKey
WHERE m.msmtdate2 IS NOT NULL OR m.mascent2 IS NOT NULL

UNION ALL

SELECT 
    mp.MemberParticipationKey,
    3 AS SummitNumber,
    m.msmtdate3,
    m.msmttime3,
    m.mascent3
FROM dbo.member_participation mp
INNER JOIN dbo.members m ON mp.LegacyMemberKey = m.MemberKey
WHERE m.msmtdate3 IS NOT NULL OR m.mascent3 IS NOT NULL;

PRINT 'member_summits rows inserted: ' + CAST(@@ROWCOUNT AS VARCHAR(10));
GO

-- =========================================================
-- VERIFICATION
-- =========================================================
PRINT '';
PRINT '===================================';
PRINT 'DECOMPOSITION TABLE ROW COUNTS';
PRINT '===================================';

SELECT 'member_person' AS table_name, COUNT(*) AS row_count FROM dbo.member_person
UNION ALL
SELECT 'member_participation', COUNT(*) FROM dbo.member_participation
UNION ALL
SELECT 'member_routes', COUNT(*) FROM dbo.member_routes
UNION ALL
SELECT 'member_summits', COUNT(*) FROM dbo.member_summits
ORDER BY table_name;

GO
