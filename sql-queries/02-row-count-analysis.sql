-- Row count analysis across all tables
-- Purpose: Quick reference for data volume in each table

SELECT 'exped' AS TableName, COUNT(*) AS [Row Count] FROM exped
UNION ALL
SELECT 'members', COUNT(*) FROM members
UNION ALL
SELECT 'peaks', COUNT(*) FROM peaks
UNION ALL
SELECT 'refer', COUNT(*) FROM refer
UNION ALL
SELECT 'expedition_oxygen', COUNT(*) FROM expedition_oxygen
UNION ALL
SELECT 'expedition_style', COUNT(*) FROM expedition_style
UNION ALL
SELECT 'expedition_timeline', COUNT(*) FROM expedition_timeline
UNION ALL
SELECT 'expedition_statistics', COUNT(*) FROM expedition_statistics
UNION ALL
SELECT 'expedition_admin', COUNT(*) FROM expedition_admin
UNION ALL
SELECT 'expedition_incidents', COUNT(*) FROM expedition_incidents
UNION ALL
SELECT 'expedition_camps', COUNT(*) FROM expedition_camps
UNION ALL
SELECT 'citizenship_lookup', COUNT(*) FROM citizenship_lookup
UNION ALL
SELECT 'season_lookup', COUNT(*) FROM season_lookup
UNION ALL
SELECT 'himalayan_data_dictionary', COUNT(*) FROM himalayan_data_dictionary
ORDER BY [Row Count] DESC;
