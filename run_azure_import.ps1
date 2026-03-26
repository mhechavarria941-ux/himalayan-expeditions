# PowerShell Script to Execute Azure Import SQL
# This script connects to Azure SQL and runs the import

param(
    [string]$Server = "cap2761cricardomolina.database.windows.net",
    [string]$Database = "Final_Project",
    [string]$Username = "ricardomolina",
    [string]$Password = "Ricardo_2002",
    [string]$SqlFilePath = "C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT\himalayan_azure_import.sql"
)

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Azure SQL Import Script" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if file exists
if (-not (Test-Path $SqlFilePath)) {
    Write-Host "ERROR: SQL file not found: $SqlFilePath" -ForegroundColor Red
    exit 1
}

Write-Host "File found: $SqlFilePath" -ForegroundColor Green
Write-Host "Connecting to: $Server.$Database" -ForegroundColor Yellow
Write-Host ""

# Build connection string
$ConnectionString = "Server=tcp:$Server,1433;Initial Catalog=$Database;User ID=$Username;Password=$Password;Encrypt=True;Connection Timeout=30;TrustServerCertificate=False;"

try {
    # Create SQL connection
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $SqlConnection.ConnectionString = $ConnectionString
    
    Write-Host "Connecting..." -ForegroundColor Yellow
    $SqlConnection.Open()
    Write-Host "✓ Connection successful!" -ForegroundColor Green
    Write-Host ""
    
    # Read SQL file
    $SqlScript = Get-Content -Path $SqlFilePath -Raw
    
    # Split script by GO statements
    $SqlStatements = $SqlScript -split "GO\r?\n" | Where-Object { $_.Trim() -ne "" }
    
    Write-Host "Executing SQL script..." -ForegroundColor Yellow
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    
    $statementCount = 0
    foreach ($statement in $SqlStatements) {
        if ($statement.Trim() -ne "") {
            $SqlCmd = $SqlConnection.CreateCommand()
            $SqlCmd.CommandText = $statement
            $SqlCmd.CommandTimeout = 300  # 5 minute timeout per statement
            
            try {
                $result = $SqlCmd.ExecuteReader()
                
                # Read and display results
                while ($result.Read()) {
                    for ($i = 0; $i -lt $result.FieldCount; $i++) {
                        $value = $result.GetValue($i)
                        Write-Host "$($result.GetName($i)): $value"
                    }
                    Write-Host ""
                }
                
                $result.Close()
                $statementCount++
            } catch {
                if ($_.Exception.Message -like "*PRINT*" -or $_.Exception.Message -like "*already exists*") {
                    Write-Host "⊗ $_" -ForegroundColor Yellow
                } else {
                    Write-Host "ERROR: $_" -ForegroundColor Red
                }
            }
        }
    }
    
    Write-Host ""
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "✓ Import script execution completed!" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Verify row counts above" -ForegroundColor White
    Write-Host "2. Run himalayan_expedition_cleaning.sql to normalize the data" -ForegroundColor White
    Write-Host ""
    
    $SqlConnection.Close()

} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Inner Exception: $($_.Exception.InnerException.Message)" -ForegroundColor Red
    exit 1
}
