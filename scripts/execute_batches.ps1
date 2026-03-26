# Execute batched SQL files to import CSV data

$server = "cap2761cricardomolina.database.windows.net"
$database = "Final_Project"
$username = "admin_ct"  
$password = "Demo123456"
$project_path = "C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT"

Write-Host "Starting batched SQL import..."
Write-Host "Project path: $project_path`n"

# Get all SQL files in order
$sqlFiles = @()
$sqlFiles += Get-ChildItem "$project_path\insert_peaks_*.sql" | Sort-Object Name
$sqlFiles += Get-ChildItem "$project_path\insert_exped_*.sql" | Sort-Object Name
$sqlFiles += Get-ChildItem "$project_path\insert_himalayan_data_dictionary_*.sql" | Sort-Object Name
$sqlFiles += Get-ChildItem "$project_path\insert_refer_*.sql" | Sort-Object Name
$sqlFiles += Get-ChildItem "$project_path\insert_members_*.sql" | Sort-Object Name

Write-Host "Found $($sqlFiles.Count) SQL batch files to execute`n"

$successCount = 0
$errorCount = 0

foreach ($sqlFile in $sqlFiles) {
    Write-Host "Executing $($sqlFile.Name)..." -ForegroundColor Cyan
    
    try {
        sqlcmd -S $server -d $database -U $username -P $password -i $sqlFile.FullName -t 60 | Out-Null
        Write-Host "  [OK] Completed" -ForegroundColor Green
        $successCount++
    }
    catch {
        Write-Host "  [ERROR] Failed: $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`n========================================="
Write-Host "Import Summary:"
Write-Host "  Successful: $successCount"
Write-Host "  Failed: $errorCount"
Write-Host "=========================================" 

# Verify data was imported
Write-Host "`nVerifying imported data..."
$checkSql = @"
SELECT 'peaks' AS TableName, COUNT(*) AS RowCount FROM dbo.peaks
UNION ALL SELECT 'exped', COUNT(*) FROM dbo.exped
UNION ALL SELECT 'members', COUNT(*) FROM dbo.members
UNION ALL SELECT 'refer', COUNT(*) FROM dbo.refer
UNION ALL SELECT 'himalayan_data_dictionary', COUNT(*) FROM dbo.himalayan_data_dictionary
"@

$checkSql | sqlcmd -S $server -d $database -U $username -P $password
