USE Final_Project;
GO

SELECT TOP 30
    m.citizen AS 'Country of Origin',
    SUM(CASE WHEN m.sherpa = 'T' THEN 1 ELSE 0 END) AS 'Sherpa Count',
    SUM(CASE WHEN m.sherpa = 'F' OR m.sherpa IS NULL THEN 1 ELSE 0 END) AS 'Climber Count',
    SUM(CASE WHEN m.sherpa = 'T' AND m.msuccess = 'T' THEN 1 ELSE 0 END) AS 'Sherpa Summits',
    SUM(CASE WHEN (m.sherpa = 'F' OR m.sherpa IS NULL) AND m.msuccess = 'T' THEN 1 ELSE 0 END) AS 'Climber Summits'
FROM members m
WHERE m.citizen IS NOT NULL
GROUP BY m.citizen
ORDER BY (SUM(CASE WHEN m.sherpa = 'T' THEN 1 ELSE 0 END) + SUM(CASE WHEN m.sherpa = 'F' OR m.sherpa IS NULL THEN 1 ELSE 0 END)) DESC;
