USE Final_Project;
GO

SELECT mdeaths, COUNT(*) FROM exped GROUP BY mdeaths ORDER BY mdeaths;
