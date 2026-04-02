USE Final_Project;
GO

SELECT
    SUM(CASE 
        WHEN m.sherpa = 'T' THEN 1 
        ELSE 0 
    END) AS 'Sherpa Count',
    
    SUM(CASE 
        WHEN m.sherpa = 'F' OR m.sherpa IS NULL THEN 1 
        ELSE 0 
    END) AS 'Paying Climber Count',
    
    SUM(CASE 
        WHEN m.sherpa = 'T' AND m.msuccess = 'T' THEN 1 
        ELSE 0 
    END) AS 'Sherpa Summits',
    
    SUM(CASE 
        WHEN (m.sherpa = 'F' OR m.sherpa IS NULL) AND m.msuccess = 'T' THEN 1 
        ELSE 0 
    END) AS 'Climber Summits',
    
    SUM(CASE 
        WHEN m.sherpa = 'T' AND m.death = 'T' THEN 1 
        ELSE 0 
    END) AS 'Sherpa Deaths',
    
    SUM(CASE 
        WHEN (m.sherpa = 'F' OR m.sherpa IS NULL) AND m.death = 'T' THEN 1 
        ELSE 0 
    END) AS 'Climber Deaths'

FROM members m;
