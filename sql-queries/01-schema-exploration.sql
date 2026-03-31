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
SELECT TOP 5 * FROM exped ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM members ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM peaks ORDER BY peakid;
SELECT TOP 5 * FROM refer ORDER BY expid;
SELECT TOP 5 * FROM expedition_oxygen ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_style ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_timeline ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_statistics ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_admin ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_incidents ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM expedition_camps ORDER BY ExpeditionKey;
SELECT TOP 5 * FROM citizenship_lookup ORDER BY CitizenshipKey;
SELECT TOP 5 * FROM season_lookup ORDER BY SeasonKey;
