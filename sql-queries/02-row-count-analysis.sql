-- Row count analysis across ALL 21 tables
-- Purpose: Quick reference for data volume in each table
-- Updated: Complete normalized schema with all tables

SELECT 'exped' AS TableName, 'CORE' AS Category, COUNT(*) AS [Row Count] FROM exped
UNION ALL
SELECT 'members', 'CORE', COUNT(*) FROM members
UNION ALL
SELECT 'peaks', 'CORE', COUNT(*) FROM peaks
UNION ALL
SELECT 'refer', 'CORE', COUNT(*) FROM refer
UNION ALL
SELECT 'season_lookup', 'LOOKUP', COUNT(*) FROM season_lookup
UNION ALL
SELECT 'citizenship_lookup', 'LOOKUP', COUNT(*) FROM citizenship_lookup
UNION ALL
SELECT 'expedition_timeline', 'EXPEDITION', COUNT(*) FROM expedition_timeline
UNION ALL
SELECT 'expedition_routes', 'EXPEDITION', COUNT(*) FROM expedition_routes
UNION ALL
SELECT 'expedition_outcomes', 'EXPEDITION', COUNT(*) FROM expedition_outcomes
UNION ALL
SELECT 'expedition_statistics', 'EXPEDITION', COUNT(*) FROM expedition_statistics
UNION ALL
SELECT 'expedition_style', 'EXPEDITION', COUNT(*) FROM expedition_style
UNION ALL
SELECT 'expedition_oxygen', 'EXPEDITION', COUNT(*) FROM expedition_oxygen
UNION ALL
SELECT 'expedition_camps', 'EXPEDITION', COUNT(*) FROM expedition_camps
UNION ALL
SELECT 'expedition_incidents', 'EXPEDITION', COUNT(*) FROM expedition_incidents
UNION ALL
SELECT 'expedition_reference_summary', 'EXPEDITION', COUNT(*) FROM expedition_reference_summary
UNION ALL
SELECT 'expedition_admin', 'EXPEDITION', COUNT(*) FROM expedition_admin
UNION ALL
SELECT 'member_person', 'MEMBER', COUNT(*) FROM member_person
UNION ALL
SELECT 'member_participation', 'MEMBER', COUNT(*) FROM member_participation
UNION ALL
SELECT 'member_routes', 'MEMBER', COUNT(*) FROM member_routes
UNION ALL
SELECT 'member_summits', 'MEMBER', COUNT(*) FROM member_summits
UNION ALL
SELECT 'audit_deleted_references', 'AUDIT', COUNT(*) FROM audit_deleted_references
ORDER BY Category, [Row Count] DESC;

-- Summary statistics
PRINT '';
PRINT '========================================';
PRINT 'DATA STRUCTURE SUMMARY';
PRINT '========================================';

SELECT 
    Category,
    COUNT(DISTINCT TableName) AS [Table Count],
    SUM([Row Count]) AS [Total Rows]
FROM (
    SELECT 'CORE' AS Category, 'exped' AS TableName, COUNT(*) AS [Row Count] FROM exped
    UNION ALL
    SELECT 'CORE', 'members', COUNT(*) FROM members
    UNION ALL
    SELECT 'CORE', 'peaks', COUNT(*) FROM peaks
    UNION ALL
    SELECT 'CORE', 'refer', COUNT(*) FROM refer
    UNION ALL
    SELECT 'LOOKUP', 'season_lookup', COUNT(*) FROM season_lookup
    UNION ALL
    SELECT 'LOOKUP', 'citizenship_lookup', COUNT(*) FROM citizenship_lookup
    UNION ALL
    SELECT 'EXPEDITION', 'expedition_timeline', COUNT(*) FROM expedition_timeline
    UNION ALL
    SELECT 'EXPEDITION', 'expedition_routes', COUNT(*) FROM expedition_routes
    UNION ALL
    SELECT 'EXPEDITION', 'expedition_outcomes', COUNT(*) FROM expedition_outcomes
    UNION ALL
    SELECT 'EXPEDITION', 'expedition_statistics', COUNT(*) FROM expedition_statistics
    UNION ALL
    SELECT 'EXPEDITION', 'expedition_style', COUNT(*) FROM expedition_style
    UNION ALL
    SELECT 'EXPEDITION', 'expedition_oxygen', COUNT(*) FROM expedition_oxygen
    UNION ALL
    SELECT 'EXPEDITION', 'expedition_camps', COUNT(*) FROM expedition_camps
    UNION ALL
    SELECT 'EXPEDITION', 'expedition_incidents', COUNT(*) FROM expedition_incidents
    UNION ALL
    SELECT 'EXPEDITION', 'expedition_reference_summary', COUNT(*) FROM expedition_reference_summary
    UNION ALL
    SELECT 'EXPEDITION', 'expedition_admin', COUNT(*) FROM expedition_admin
    UNION ALL
    SELECT 'MEMBER', 'member_person', COUNT(*) FROM member_person
    UNION ALL
    SELECT 'MEMBER', 'member_participation', COUNT(*) FROM member_participation
    UNION ALL
    SELECT 'MEMBER', 'member_routes', COUNT(*) FROM member_routes
    UNION ALL
    SELECT 'MEMBER', 'member_summits', COUNT(*) FROM member_summits
    UNION ALL
    SELECT 'AUDIT', 'audit_deleted_references', COUNT(*) FROM audit_deleted_references
) x
GROUP BY Category
ORDER BY Category;
