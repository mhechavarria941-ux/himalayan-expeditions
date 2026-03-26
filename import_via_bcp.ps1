# PowerShell script to import CSV files to Azure SQL Database

$server = "cap2761cricardomolina.database.windows.net"
$database = "Final_Project"
$username = "admin_ct"
$password = "Demo123456"
$csvPath = "C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT\Himalayan+Expeditions"

# SQL Server connection string
$connStr = "Server=$server;Database=$database;User Id=$username;Password=$password;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"

Write-Host "Starting CSV import to Azure SQL Database..."
Write-Host "Connection String: $connStr"
Write-Host "CSV Path: $csvPath"

# Import using bcp
$tables = @(
    @{name="peaks"; file="peaks.csv"},
    @{name="exped"; file="exped.csv"},
    @{name="members"; file="members.csv"},
    @{name="refer"; file="refer.csv"},
    @{name="himalayan_data_dictionary"; file="himalayan_data_dictionary.csv"}
)

foreach ($table in $tables) {
    $csvFile = Join-Path $csvPath $table.file
    if (Test-Path $csvFile) {
        Write-Host "Importing $($table.name) from $($table.file)..."
        
        # Use bcp to bulk import
        $bcpCmd = "bcp $database.dbo.$($table.name) in `"$csvFile`" -S $server -U $username -P $password -c -t, -F 2 -m 5000"
        
        try {
            Invoke-Expression $bcpCmd
            Write-Host "  [OK] Successfully imported $($table.name)"
        }
        catch {
            Write-Host "  [ERROR] Error importing $($table.name): $_"
        }
    }
    else {
        Write-Host "  [ERROR] File not found: $csvFile"
    }
}

Write-Host "CSV import completed!"
