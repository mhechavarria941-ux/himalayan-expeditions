param(
    [string]$Server = "",
    [string]$Database = "Final_Project",
    [string]$Username = "",
    [string]$Password = ""
)

# EXIT if credentials not provided
if (-not $Server -or -not $Username -or -not $Password) {
    Write-Host "ERROR: Missing credentials!" -ForegroundColor Red
    Write-Host "Usage: powershell -File bulk_load_csv.ps1 -Server YOUR_SERVER.database.windows.net -Username YOUR_USERNAME -Password YOUR_PASSWORD"
    exit 1
}

function Escape-SqlString {
    param([string]$value)
    if ($null -eq $value -or $value -eq "") {
        return "NULL"
    }
    return "'" + $value.Replace("'", "''") + "'"
}

$connectionString = "Server=$Server;Database=$Database;User Id=$Username;Password=$Password;"
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString

Write-Host "Connecting to Azure SQL Database..."
try {
    $connection.Open()
    Write-Host "[OK] Connected successfully"
}
catch {
    Write-Host "[ERROR] Connection failed: $_"
    exit 1
}

Write-Host "`nDisabling foreign key constraints..."
$cmd = $connection.CreateCommand()
$cmd.CommandText = @"
ALTER TABLE dbo.refer NOCHECK CONSTRAINT ALL;
ALTER TABLE dbo.members NOCHECK CONSTRAINT ALL;
ALTER TABLE dbo.exped NOCHECK CONSTRAINT ALL;
ALTER TABLE dbo.peaks NOCHECK CONSTRAINT ALL;
"@
$cmd.ExecuteNonQuery() | Out-Null
Write-Host "[OK] FK constraints disabled"

Write-Host "`nTruncating tables..."
$cmd.CommandText = @"
TRUNCATE TABLE dbo.refer;
TRUNCATE TABLE dbo.members;
TRUNCATE TABLE dbo.exped;
TRUNCATE TABLE dbo.peaks;
"@
$cmd.ExecuteNonQuery() | Out-Null
Write-Host "[OK] Tables truncated"

function Load-CsvToDatabase {
    param(
        [string]$CsvFile,
        [string]$TableName,
        [System.Data.SqlClient.SqlConnection]$Connection
    )
    
    Write-Host "`nLoading $CsvFile into $TableName..."
    
    try {
        $csvData = Import-Csv -Path $CsvFile -Encoding UTF8
        $headers = $csvData[0].PSObject.Properties.Name
        
        Write-Host "  Columns: $($headers.Count)"
        Write-Host "  Total rows: $($csvData.Count)"
        
        $batchSize = 500
        $batch = @()
        $insertedRows = 0
        $rowCounter = 0
        
        foreach ($row in $csvData) {
            $rowCounter++
            
            if ($rowCounter % 5000 -eq 0) {
                Write-Host "  Progress: $rowCounter rows processed..."
            }
            
            $columns = @()
            $values = @()
            
            foreach ($header in $headers) {
                $columns += "[$header]"
                $cellValue = $row.$header
                $values += (Escape-SqlString $cellValue)
            }
            
            $columnList = $columns -join ", "
            $valueList = $values -join ", "
            $insertStmt = "INSERT INTO dbo.$TableName ($columnList) VALUES ($valueList);"
            
            $batch += $insertStmt
            
            if ($batch.Count -eq $batchSize -or $rowCounter -eq $csvData.Count) {
                try {
                    $batchSQL = $batch -join " "
                    $cmd.CommandText = $batchSQL
                    $cmd.CommandTimeout = 300
                    $rowsAffected = $cmd.ExecuteNonQuery()
                    $insertedRows += $rowsAffected
                    $batch = @()
                }
                catch {
                    Write-Host "  [ERROR] Batch failed: $_"
                    return 0
                }
            }
        }
        
        Write-Host "  [OK] $TableName : $insertedRows rows inserted"
        return $insertedRows
    }
    catch {
        Write-Host "  [ERROR] Load failed: $_"
        return 0
    }
}

$peaksRows = Load-CsvToDatabase "data\himalayan_sources\peaks.csv" "peaks" $connection
$expedRows = Load-CsvToDatabase "data\himalayan_sources\exped.csv" "exped" $connection
$membersRows = Load-CsvToDatabase "data\himalayan_sources\members.csv" "members" $connection
$referRows = Load-CsvToDatabase "data\himalayan_sources\refer.csv" "refer" $connection

Write-Host "`nRe-enabling foreign key constraints..."
$cmd.CommandText = @"
ALTER TABLE dbo.peaks CHECK CONSTRAINT ALL;
ALTER TABLE dbo.exped CHECK CONSTRAINT ALL;
ALTER TABLE dbo.members CHECK CONSTRAINT ALL;
ALTER TABLE dbo.refer CHECK CONSTRAINT ALL;
"@
$cmd.ExecuteNonQuery() | Out-Null
Write-Host "[OK] FK constraints re-enabled"

Write-Host "`n==================================="
Write-Host "FINAL ROW COUNTS (VERIFICATION)"
Write-Host "==================================="

$cmd.CommandText = @"
SELECT 'peaks' AS TableName, COUNT(*) AS RowCount FROM dbo.peaks
UNION ALL
SELECT 'exped', COUNT(*) FROM dbo.exped
UNION ALL
SELECT 'members', COUNT(*) FROM dbo.members
UNION ALL
SELECT 'refer', COUNT(*) FROM dbo.refer
ORDER BY TableName;
"@

$reader = $cmd.ExecuteReader()

while ($reader.Read()) {
    $tableName = $reader[0]
    $rowCount = $reader[1]
    Write-Host "$tableName : $rowCount rows"
}

$reader.Close()
$connection.Close()

Write-Host "`n[OK] Data load complete!"
