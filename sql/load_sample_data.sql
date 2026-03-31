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
('ANN269301', 'ANN2', '1969', 'Autumn', 'Nepal', 'NW Ridge-W Ridge', NULL, NULL, NULL, 'Yugoslavia', 'Ales Kunaver', 'Mountaineering Club of Slovenia', 'TRUE', 'FALSE', 'FALSE', 'FALSE', '2nd', NULL, NULL, NULL, 'FALSE', 'FALSE', NULL, 'Marshyangdi->Hongde->Sabje Khola', '1969-09-25', '1969-10-22', '1800', '27', '31', '1969-10-26', 'Success (main peak)', NULL, '7937', 'FALSE', 'FALSE', 'FALSE', '6', '0', '10', '2', '0', '0', '0', '0', 'FALSE', 'FALSE', 'TRUE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'Climbed Annapurna IV (ANN4-693-02)', 'LowBC(25/09,3950m),BC(27/09,4650m),C1(27/09,5300m),C2(6000m),C3(6400m),C4,C5(7350m),C6(7250m),Smt(22/10)', 'Draslar frostbitten hands and feet', NULL, NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL, '2445501'),
('ANN273101', 'ANN2', '1973', 'Spring', 'Nepal', 'W Ridge-N Face', NULL, NULL, NULL, 'Japan', 'Yukio Shimamura', 'Sangaku Doshikai Annapurna II Expedition 1973', 'TRUE', 'FALSE', 'FALSE', 'FALSE', '3rd', NULL, NULL, NULL, 'FALSE', 'FALSE', NULL, 'Marshyangdi->Pisang->Salatang Khola', '1973-03-16', '1973-05-06', '2030', '51', NULL, NULL, 'Success (main peak)', NULL, '7937', 'FALSE', 'FALSE', 'FALSE', '5', '0', '6', '1', '0', '8', '0', '0', 'FALSE', 'FALSE', 'TRUE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL, 'BC(16/03,3300m),C1(21/03,4200m),C2(10/04,5000m),C3(14/04,6000m),C4(23/04,6750m),C5(04/05,7300m),Smt(06/05)', NULL, NULL, NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL, '2446797'),
('ANN278301', 'ANN2', '1978', 'Autumn', 'Nepal', 'N Face-W Ridge', NULL, NULL, NULL, 'UK', 'Richard J. Isherwood', 'British Annapurna II Expedition', 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL, NULL, NULL, NULL, 'FALSE', 'FALSE', NULL, 'Marshyangdi->Pisang->Salatang Khola', '1978-09-08', '1978-10-02', NULL, '24', '27', '1978-10-05', 'Bad weather (storms, high winds)', 'Abandoned at 7000m (on A-IV) due to bad weather', '7000', 'FALSE', 'FALSE', 'FALSE', '0', '0', '2', '0', '0', '0', '0', '0', 'TRUE', 'FALSE', 'TRUE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL, 'BC(08/09,5190m),xxx(02/10,7000m)', NULL, NULL, NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL, '2448822'),
('AMAD01101', 'AMAD', '2001', 'Spring', 'Australia', NULL, NULL, NULL, NULL, 'Australia', 'Marc Cameron Fairhead', NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL, NULL, NULL, NULL, 'FALSE', 'FALSE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Aborted at high camp', 'Bad conditions (deep snow, avalanches, falling rock/ice)', '6200', 'FALSE', 'FALSE', 'FALSE', NULL, NULL, '7', '0', '0', '0', '0', '0', 'FALSE', 'TRUE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL, 'FALSE', NULL, NULL, NULL, NULL, 'No summit bid', NULL, NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', NULL);

-- =========================================================
-- Insert members data (sample from members.csv)
-- =========================================================
INSERT INTO dbo.members (expid, membid, peakid, myear, mseason, fname, lname, sex, yob, citizen, [status], residence, occupation, leader, msuccess, mhighpt, msmtdate1, msmttime1, mascent1, mroute1, death, mchksum)
VALUES
('AMAD01101', '2', 'AMAD', '2001', 'Spring', 'Rohan', 'Buckley', 'M', '1972', 'Australia', 'Climber', 'Sale, Victoria, Australia', 'Air force navigator', 'FALSE', 'FALSE', 'FALSE', NULL, NULL, NULL, 'NW Ridge', 'FALSE', '2439554'),
('AMAD01101', '1', 'AMAD', '2001', 'Spring', 'Marc Cameron', 'Fairhead', 'M', '1968', 'Australia', 'Leader', 'Bridgewater, SA, Australia', 'Manager in Department of Defense', 'TRUE', 'FALSE', 'TRUE', '2001-04-11', '0800', 'First ascent via NW Ridge', 'NW Ridge', 'FALSE', '2438062'),
('AMAD01101', '3', 'AMAD', '2001', 'Spring', 'Mark', 'Schroeder', 'M', '1960', 'Australia', 'Climber', 'Woolhara, NSW, Australia', 'Advertising general manager', 'FALSE', 'FALSE', 'TRUE', '2001-04-11', '0900', 'Successfully summited', 'NW Ridge', 'FALSE', '2435183'),
('AMAD01101', '4', 'AMAD', '2001', 'Spring', 'Colin', 'Smith', 'M', '1966', 'Australia', 'Climber', 'Prospect, SA, Australia', 'Air force pilot', 'FALSE', 'FALSE', 'FALSE', NULL, NULL, NULL, 'W Face Approach', 'FALSE', '2437475');

-- =========================================================
-- Insert refer data (sample from refer.csv)
-- =========================================================
INSERT INTO dbo.refer (expid, refid, ryear, rtype, rjrnl, rauthor, rtitle, rpublisher, rpubdate, rlanguage, rcitation, ryak94)
VALUES
('KANG84101', '01', '1984', 'Journal', 'American Alpine Journal', 'Matsuzawa, Tetsuro', NULL, NULL, '1985', NULL, '59:247-249 (1985)', NULL),
('KANG84102', '01', '1984', 'Journal', 'American Alpine Journal', 'Ball, Gary', NULL, NULL, '1985', NULL, '59:249-250 (1985)', NULL),
('KANG84301', '01', '1984', 'Journal', 'American Alpine Journal', 'Marshall, Roger', NULL, NULL, '1985', NULL, '59:250 (1985)', NULL),
('KANG84401', '01', '1984', 'Book', NULL, 'Bremer-Kamp, Cherie', 'Living on the Edge', NULL, '1987', NULL, NULL, 'B558'),
('YALU84302', '01', '1984', 'Journal', 'American Alpine Journal', 'Muller, Bernard', NULL, NULL, '1985', NULL, '59:251 (1985)', NULL);

-- =========================================================
-- Insert data dictionary metadata
-- =========================================================
INSERT INTO dbo.himalayan_data_dictionary (TableName, ColumnName, DataType, SourceCSV)
VALUES
('peaks', 'peakid', 'NVARCHAR(255)', 'peaks.csv'),
('peaks', 'pkname', 'NVARCHAR(255)', 'peaks.csv'),
('exped', 'expid', 'NVARCHAR(255)', 'exped.csv'),
('exped', 'peakid', 'NVARCHAR(255)', 'exped.csv'),
('exped', 'season', 'NVARCHAR(255)', 'exped.csv'),
('exped', 'route1', 'NVARCHAR(MAX)', 'exped.csv'),
('exped', 'route2', 'NVARCHAR(MAX)', 'exped.csv'),
('exped', 'route3', 'NVARCHAR(MAX)', 'exped.csv'),
('exped', 'route4', 'NVARCHAR(MAX)', 'exped.csv'),
('members', 'membid', 'NVARCHAR(255)', 'members.csv'),
('members', 'expid', 'NVARCHAR(255)', 'members.csv'),
('members', 'fname', 'NVARCHAR(255)', 'members.csv'),
('members', 'mroute1', 'NVARCHAR(MAX)', 'members.csv'),
('refer', 'refid', 'NVARCHAR(255)', 'refer.csv'),
('refer', 'expid', 'NVARCHAR(255)', 'refer.csv'),
('refer', 'rtitle', 'NVARCHAR(MAX)', 'refer.csv');

SELECT 'Sample data inserted' AS Status;
SELECT 'peaks' AS TableName, COUNT(*) AS [RowCount] FROM dbo.peaks
UNION ALL SELECT 'exped' AS TableName, COUNT(*) AS [RowCount] FROM dbo.exped
UNION ALL SELECT 'members' AS TableName, COUNT(*) AS [RowCount] FROM dbo.members
UNION ALL SELECT 'refer' AS TableName, COUNT(*) AS [RowCount] FROM dbo.refer
UNION ALL SELECT 'himalayan_data_dictionary' AS TableName, COUNT(*) AS [RowCount] FROM dbo.himalayan_data_dictionary;
