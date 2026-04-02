# 📋 How to Export All Table Schemas from Azure

This folder now contains scripts to help you export and visualize all table schemas from your Azure database.

---

## 📁 Files in This Folder

### **00-create-main-tables-from-csv.sql**
Primary schema creation script - Creates the core tables from CSV data
- 4 core tables: peaks, exped, members, refer
- 2 supporting tables: data dictionary, audit
- 2 lookup tables: season, citizenship
- **Total: 8 tables** (what the project creates from scratch)

### **01-export-all-table-schemas.sql** ⭐ NEW
Export script to view **all actual tables** in your Azure database
- Lists every table currently in Final_Project database
- Shows column counts
- Generates CREATE TABLE statements

### **02-export-clean-schemas.sql** ⭐ NEW
Clean export script for ChartDB visualization
- Better formatted output
- Easy to copy-paste into ChartDB
- Shows table statistics

---

## 🚀 How to Get All Your Table Schemas

### **Step 1: Connect to Azure SQL Database**

⚠️ **SECURITY WARNING**: Never commit credentials to GitHub!

```powershell
# Use Azure CLI or environment variables instead
# Get connection string from Azure Portal (Contact instructor)

sqlcmd -S <YOUR_SERVER> -d <YOUR_DATABASE> -U <YOUR_USERNAME> -P <YOUR_PASSWORD>
```

### **Step 2: Run the Schema Export Query**

Choose **ONE** of these:

**OPTION A - Simple List (Recommended First)**
```sql
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
```

**OPTION B - Detailed View**
```sql
SELECT 
    TABLE_NAME,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS c WHERE c.TABLE_NAME = t.TABLE_NAME) AS ColumnCount
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
```

**OPTION C - Full Script (Use environment variables)**

```powershell
# Never hardcode credentials - use environment variables
sqlcmd -S $env:AZURE_SQL_SERVER -d $env:AZURE_SQL_DB -U $env:AZURE_SQL_USER -P $env:AZURE_SQL_PASSWORD -i Database-Schema/02-export-clean-schemas.sql
```

---

## 📊 What You'll See

When you run these queries, you'll get a list like:

```
TABLE_NAME              ColumnCount
=====================================
audit_deleted_references    8
himalayan_data_dictionary   4
members                     61
peaks                       23
refer                       12
season_lookup               4
citizenship_lookup          4
exped                       65

Total: ~8 tables (may vary if more were added)
```

---

## 🎨 To Get Full CREATE TABLE Statements for ChartDB

### **Method 1: Using SQL Query (RECOMMENDED)**

Run this simple query in Azure SQL:

```sql
-- Step 1: List all tables
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Step 2: For each table, generate schema
-- Run this for each table name from Step 1:
sp_helptext '[TableName]'  -- Shows definition
-- OR
SELECT OBJECT_DEFINITION(OBJECT_ID('[TableName]'))  -- Shows exact CREATE TABLE
```

### **Method 2: Export via Azure Portal**

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to your SQL Database resource
3. Select your database
4. Click **Query Editor**
5. Run: 
```sql
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo'
```
6. Click **Export** button → Download as CSV or Excel

### **Method 3: Use SQL Server Management Studio (if installed)**

1. Connect to your SQL Server (credentials from Azure Portal)
2. Right-click your database → **Tasks** → **Generate Scripts**
3. Select all tables
4. Choose options:
   - ✅ Script DROP and CREATE
   - ✅ Include Primary Keys
   - ✅ Include Foreign Keys
5. Finish → Save as .sql file

### **Method 4: Use Visual Studio**

1. Open SQL Server Object Explorer
2. Connect to Azure SQL (use credentials from Azure Portal)
3. Browse to your database and tables
4. Right-click tables → **View Definition**
5. Copy the CREATE TABLE statements

---

## 📥 To Use Exported Schema with ChartDB

1. Copy all CREATE TABLE statements
2. Go to [ChartDB.io](https://chartdb.io)
3. Create new diagram
4. **SQL** tab → Paste your schema
5. ChartDB will parse and display all relationships

---

## 🔍 Quick SQL Commands

Get table info quickly:

```sql
-- Count all tables
SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE';

-- Get all column names for a table
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'members' 
ORDER BY ORDINAL_POSITION;

-- Get row counts for all tables
SP_SPACEUSED;

-- Get exact table definition
SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.exped'));
```

---

## 💡 For Your Project

- **4 Core Tables** (focus here): peaks, exped, members, refer
- **All Tables** (for complete schema): Use export scripts above
- **ChartDB**: Use Method 3 or 4 to get full CREATE TABLE statements

---

## 🎯 Next Steps

1. **Run Option C** (execute one of the .sql files)
2. **Copy the output**
3. **Paste into ChartDB** to visualize
4. **Save the schema** to your repository

---

*Last updated: April 2, 2026*
