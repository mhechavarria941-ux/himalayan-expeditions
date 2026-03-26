-- Import Himalayan Expeditions data from CSV files
-- This script contains INSERT statements for all tables

-- =========================================================
-- Insert peaks data (sample from peaks.csv)
-- =========================================================
INSERT INTO dbo.peaks (peakid, pkname, pkname2, location, heightm, heightf, himal, region, [open], unlisted, trekking, trekyear, [restrict], phost, pstatus, pyear, pseason, pmonth, pday, pexpid, pcountry, psummiters, psmtnote)
VALUES
('ACHN', 'Aichyn', 'Aychin, Ashvin', 'Chandi Himal (SW of Changwathang)', '6055', '19865', 'Nalakankar/Chandi/Changla', 'Kanjiroba-Far West', 'TRUE', 'FALSE', 'FALSE', NULL, 'Opened in 2014', 'Nepal only', 'Climbed', '2015', 'Autumn', 'Sep', '3', 'ACHN15301', 'Japan', 'Hiroki Senda, et al', NULL),
('AMAD', 'Ama Dablam', 'Amai Dablang', 'Khumbu Himal', '6814', '22356', 'Khumbu', 'Khumbu-Rolwaling-Makalu', 'TRUE', 'FALSE', 'FALSE', NULL, NULL, 'Nepal only', 'Climbed', '1961', 'Spring', 'Mar', '13', 'AMAD61101', 'New Zealand, USA, UK', 'Mike Gill, Wally Romanes, Barry Bishop, Michael Ward', NULL),
('AMOT', 'Amotsang', 'Amatson', 'Damodar Himal (NW of Pokharhan)', '6393', '20974', 'Damodar', 'Annapurna-Damodar-Peri', 'TRUE', 'FALSE', 'FALSE', NULL, 'Opened in 2002', 'Nepal only', 'Climbed', '2019', 'Autumn', 'Oct', '24', 'AMOT19301', 'Germany', 'Jost Kobusch', 'Possibly climbed earlier'),
('AMPG', 'Amphu Gyabjen', 'Amphu Gyabien', 'Khumbu Himal (N of Ama Dablam)', '5630', '18471', 'Khumbu', 'Khumbu-Rolwaling-Makalu', 'TRUE', 'FALSE', 'FALSE', NULL, 'Opened in 2002', 'Nepal only', 'Climbed', '1953', 'Spring', 'Apr', '11', 'AMPG53101', 'UK', 'John Hunt, Tom Bourdillon', NULL);

-- =========================================================
-- Insert exped data (sample from exped.csv)
-- =========================================================
INSERT INTO dbo.exped (expid, peakid, [year], season, host, route1, route2, route3, route4, nation, leaders, sponsor, success1, success2, success3, success4, ascent1, ascent2, ascent3, ascent4, claimed, disputed, countries, approach, bcdate, smtdate, smttime, smtdays, totdays, termdate, termreason, termnote, highpoint, traverse, ski, parapente, camps, rope, totmembers, smtmembers, mdeaths, tothired, smthired, hdeaths, nohired, o2used, o2none, o2climb, o2descent, o2sleep, o2medical, o2taken, o2unkwn, othersmts, campsites, accidents, achievment, agency, comrte, stdrte, primrte, primmem, primref, primid, chksum)
VALUES
('ANN260101', 'ANN2', '1960', 'Spring', 'Nepal', 'NW Ridge-W Ridge', NULL, NULL, NULL, 'UK', 'J. O. M. Roberts', NULL, 'TRUE', 'FALSE', 'FALSE', 'FALSE', '1st', NULL, NULL, NULL, 'FALSE', 'FALSE', 'India, Nepal', 'Marshyangdi->Hongde->Sabje Khola', '1960-03-15', '1960-05-17', '1530', '63', NULL, NULL, 'Success (main peak)', NULL, '7937', 'FALSE', 'FALSE', 'FALSE', '6', '0', '10', '2', '0', '9', '1', '0', 'FALSE', 'TRUE', 'FALSE', 'TRUE', 'FALSE', 'TRUE', 'FALSE', 'FALSE', 'FALSE', 'Climbed Annapurna IV (ANN4-601-01)', 'BC(15/03,3350m),ABC(4575m),C1(5365m),C2(5800m),C3(26/04,6400m),C4(30/04,6900m),C5(15/05,7270m),C6(16/05,7200m),Smt(17/05)', NULL, NULL, NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL, '2442047'),
('ANN269301', 'ANN2', '1969', 'Autumn', 'Nepal', 'NW Ridge-W Ridge', NULL, NULL, NULL, 'Yugoslavia', 'Ales Kunaver', 'Mountaineering Club of Slovenia', 'TRUE', 'FALSE', 'FALSE', 'FALSE', '2nd', NULL, NULL, NULL, 'FALSE', 'FALSE', NULL, 'Marshyangdi->Hongde->Sabje Khola', '1969-09-25', '1969-10-22', '1800', '27', '31', '1969-10-26', 'Success (main peak)', NULL, '7937', 'FALSE', 'FALSE', 'FALSE', '6', '0', '10', '2', '0', '0', '0', '0', 'FALSE', 'FALSE', 'TRUE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'Climbed Annapurna IV (ANN4-693-02)', 'LowBC(25/09,3950m),BC(27/09,4650m),C1(27/09,5300m),C2(6000m),C3(6400m),C4,C5(7350m),C6(7250m),Smt(22/10)', 'Draslar frostbitten hands and feet', NULL, NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL, '2445501');

-- =========================================================
-- Insert data dictionary
-- =========================================================
INSERT INTO dbo.himalayan_data_dictionary (Column1, Column2, Column3)
VALUES
('peaks', NULL, 'Peak master table'),
('peaks', 'peakid', 'Peak ID (primary key)'),
('peaks', 'pkname', 'Foreign (common) name of the peak'),
('exped', NULL, 'Expedition table'),
('exped', 'expid', 'Expedition ID (primary key)'),
('exped', 'peakid', 'Peak ID (foreign key)'),
('members', NULL, 'Member participation table'),
('members', 'expid', 'Expedition ID (foreign key)'),
('members', 'membid', 'Member ID'),
('refer', NULL, 'Reference table'),
('refer', 'expid', 'Expedition ID (foreign key)'),
('refer', 'refid', 'Reference ID');

SELECT 'Sample data inserted' AS Status;
SELECT 'peaks' AS TableName, COUNT(*) AS RowCount FROM dbo.peaks
UNION ALL SELECT 'exped', COUNT(*) FROM dbo.exped
UNION ALL SELECT 'members', COUNT(*) FROM dbo.members
UNION ALL SELECT 'refer', COUNT(*) FROM dbo.refer
UNION ALL SELECT 'himalayan_data_dictionary', COUNT(*) FROM dbo.himalayan_data_dictionary;
