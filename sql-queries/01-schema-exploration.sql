-- Himalayan Expeditions Database - Schema Exploration Queries
-- Date: March 30, 2026
-- Purpose: Database structure and table overview

-- Get list of all tables with row counts
SELECT 
    TABLE_NAME,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES t2 WHERE t2.TABLE_NAME = t.TABLE_NAME) AS RowEstimate
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;

-- Sample queries for each table (TOP 5 rows)
-- Core and modified tables
SELECT TOP 5 * FROM exped ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM peaks ORDER BY peakid;
SELECT TOP 5 * FROM members ORDER BY MemberKey;
SELECT TOP 5 * FROM refer ORDER BY ReferenceKey;

-- Lookup tables
SELECT TOP 5 * FROM citizenship_lookup ORDER BY CitizenshipKey;
SELECT TOP 5 * FROM season_lookup ORDER BY SeasonKey;

-- Expedition decomposition tables
SELECT TOP 5 * FROM expedition_timeline ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_routes ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_outcomes ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_statistics ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_style ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_oxygen ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_camps ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_incidents ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_reference_summary ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_admin ORDER BY ExpeditionKey;

-- Member normalization tables
SELECT TOP 5 * FROM member_person ORDER BY PersonKey;
SELECT TOP 5 * FROM member_participation ORDER BY MemberParticipationKey;
SELECT TOP 5 * FROM member_routes ORDER BY MemberRouteKey;
SELECT TOP 5 * FROM member_summits ORDER BY MemberSummitKey;

-- Audit tables
SELECT TOP 5 * FROM audit_deleted_references ORDER BY AuditID;

-- VALIDATION SUMMARY: Expected table count
PRINT '========================================';
PRINT 'TABLE CREATION VALIDATION';
PRINT '========================================';

SELECT 
    'TOTAL TABLES IN SCHEMA' AS check_name,
    COUNT(*) AS expected_count,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo') AS actual_count
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo'
GROUP BY TABLE_SCHEMA;

PRINT '';
PRINT 'Expected tables (21 total):';
PRINT '  Core: exped, peaks, members, refer (4)';
PRINT '  Lookup: season_lookup, citizenship_lookup (2)';
PRINT '  Expedition: expedition_timeline, expedition_routes, expedition_outcomes,';
PRINT '             expedition_statistics, expedition_style, expedition_oxygen,';
PRINT '             expedition_camps, expedition_incidents, expedition_reference_summary,';
PRINT '             expedition_admin (10)';
PRINT '  Member: member_person, member_participation, member_routes, member_summits (4)';
PRINT '  Audit: audit_deleted_references (1)';
PRINT '';

-- Confirm all tables exist
SELECT 
    TABLE_NAME,
    CASE 
        WHEN TABLE_NAME IN ('exped', 'peaks', 'members', 'refer') THEN 'CORE'
        WHEN TABLE_NAME IN ('season_lookup', 'citizenship_lookup') THEN 'LOOKUP'
        WHEN TABLE_NAME LIKE 'expedition_%' THEN 'EXPEDITION'
        WHEN TABLE_NAME LIKE 'member_%' THEN 'MEMBER'
        WHEN TABLE_NAME LIKE 'audit_%' THEN 'AUDIT'
        ELSE 'OTHER'
    END AS table_type
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY table_type, TABLE_NAME;
