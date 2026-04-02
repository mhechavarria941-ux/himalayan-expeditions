USE Final_Project;
GO

SELECT TOP 5
    e.expid,
    e.peakid,
    e.mdeaths,
    e.success1,
    p.pkname,
    p.heightm
FROM exped e
INNER JOIN peaks p ON e.peakid = p.peakid;
