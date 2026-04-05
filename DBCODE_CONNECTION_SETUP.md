# DBCode Database Connection Setup Guide

## Overview
This guide walks you through setting up a secure database connection in VS Code using the DBCode extension to connect to your Azure SQL Database.

---

## Step 1: Install DBCode Extension

### Option A: Via VS Code Marketplace (Recommended)
1. Open VS Code
2. Click **Extensions** icon in left sidebar (or press `Ctrl+Shift+X`)
3. Search for **"DBCode"**
4. Click **Install** on the DBCode extension
5. Wait for installation to complete (you may see "Install" change to "Uninstall")

### Option B: Via Command Palette
1. Press `Ctrl+Shift+P` to open Command Palette
2. Type: `Extensions: Install Extensions`
3. Search for "DBCode"
4. Click Install

### Option C: Direct Link
- Go to: https://marketplace.visualstudio.com/items?itemName=DBCode.dbcode
- Click "Install"

---

## Step 2: Create Connection to Azure SQL Database

### Access Connection Manager
1. Press `Ctrl+Shift+P` (Command Palette)
2. Type: `DBCode: Open Database Connection Manager`
3. Click the command to open the connection panel

*Alternatively:* Look for the database icon in the left sidebar of VS Code

### Configure New Connection

#### Using Connection String (RECOMMENDED - Most Secure)

**Connection String Format:**
```
Server=tcp:cap2761cricardomolina.database.windows.net,1433;Initial Catalog=Final_Project;Persist Security Info=False;User ID=<YOUR_USERNAME>;Password=<YOUR_PASSWORD>;Encrypt=True;Connection Timeout=30;

```

**Steps:**
1. In DBCode Connection Manager, click **"+ New Connection"** or **"Add Connection"**
2. Select connection type: **SQL Server** (Azure)
3. In the connection dialog:
   - **Connection String**: Paste the connection string above
   - Replace `<YOUR_USERNAME>` with your actual username
   - Replace `<YOUR_PASSWORD>` with your actual password
   - Click **"Test Connection"**

#### Using Individual Fields (Alternative)

If DBCode offers individual field entry:

| Field | Value |
|-------|-------|
| **Server** | `cap2761cricardomolina.database.windows.net` |
| **Port** | `1433` |
| **Database** | `Final_Project` |
| **Authentication** | SQL Authentication |
| **Username** | Your admin username |
| **Password** | Your admin password |
| **Encrypt** | ✅ Yes (for Azure) |

---

## Step 3: Secure Credential Management (IMPORTANT ⚠️)

### NEVER Store Passwords in Code/Git

⚠️ **CRITICAL**: After the recent security incident, DO NOT hardcode credentials in any files that get committed to GitHub.

### Option A: Use Environment Variables (RECOMMENDED)

**1. Create .env file in project root:**
```
AZURE_SQL_SERVER=cap2761cricardomolina.database.windows.net
AZURE_SQL_DB=Final_Project
AZURE_SQL_USER=<YOUR_USERNAME>
AZURE_SQL_PASSWORD=<YOUR_PASSWORD>
```

**2. Ensure .env is in .gitignore:**
Check that your `.gitignore` file contains:
```
.env
.env.local
*.env
```

**3. In DBCode, use the environment variables:**
```
Server=tcp:$AZURE_SQL_SERVER,1433;Initial Catalog=$AZURE_SQL_DB;User ID=$AZURE_SQL_USER;Password=$AZURE_SQL_PASSWORD;Encrypt=True;
```

### Option B: Use Windows Credential Manager

1. Open **Credential Manager** (search in Windows Start menu)
2. Click **Windows Credentials**
3. Click **Add a generic credential**
4. Fill in:
   - **Internet or network address**: `azure-sql-final-project`
   - **Username**: Your Azure SQL username
   - **Password**: Your Azure SQL password
5. Click **OK**

Then in DBCode, reference: `DBCode-AzureSQL`

### Option C: Use Azure CLI Authentication

If you have Azure CLI installed:
```powershell
az login
```

Then DBCode may auto-detect and use your Azure credentials without storing passwords locally.

---

## Step 4: Test the Connection

### Method 1: In DBCode UI
1. In the Connections panel, right-click your new connection
2. Select **"Test Connection"**
3. Wait for confirmation message:
   - ✅ "Connection successful!" → Ready to use
   - ❌ Error message → Check credentials and server name

### Method 2: Run a Test Query
1. Create a new SQL file: `test-connection.sql`
2. Add simple query:
   ```sql
   SELECT 'Connection Successful!' AS status;
   ```
3. With the file open, press `Ctrl+Shift+E` (or `DBCode: Run Query`)
4. Select your connection from the dropdown
5. If query runs and shows result → ✅ Connection working!

### Common Connection Errors

| Error | Solution |
|-------|----------|
| **"Server not found"** | Check server name spelling: `cap2761cricardomolina.database.windows.net` |
| **"Login failed"** | Verify username/password credentials (may have expired) |
| **"Cannot connect to database"** | Ensure database name is `Final_Project` (exact spelling) |
| **"Connection timeout"** | Check internet connection, port 1433 may be firewall-blocked |
| **"Encryption error"** | Ensure `Encrypt=True` is in connection string |

---

## Step 5: Using the Connection in Queries

### Run Queries Against Your Database

**To execute a query:**

1. Open a `.sql` file from your project (e.g., `sql-queries/Storytelling/04-death-zone-demographics.sql`)
2. Select your query text (or leave it selected if only one query)
3. Press **`Ctrl+Shift+E`** or:
   - Press `Ctrl+Shift+P`
   - Type: `DBCode: Run Query`
   - Select your connection
4. Results appear in the **Results** panel
5. Click **Chart** tab to visualize the results

### Switch Between Connections

If you have multiple database connections:
1. Click the connection name in DBCode sidebar
2. Or use `Ctrl+Shift+P` → `DBCode: Select Connection`

---

## Step 6: Verify Your Connection Works with Your Queries

### Test with Actual Project Query

```sql
-- Copy the first query from your 04-death-zone-demographics.sql file
-- It should look like:

SELECT TOP 15
    p.pkname,
    COUNT(m.MemberID) as total_climbers,
    SUM(CASE WHEN m.died = 'TRUE' THEN 1 ELSE 0 END) as total_deaths,
    CAST(SUM(CASE WHEN m.died = 'TRUE' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(m.MemberID) as mortality_rate
FROM peaks p
INNER JOIN exped e ON p.PkID = e.PkID
INNER JOIN members m ON e.ExpID = m.ExpID
WHERE e.ClimbingSeason >= 1995
GROUP BY p.pkname
HAVING COUNT(m.MemberID) >= 5
ORDER BY total_deaths DESC;
```

**If this query runs successfully:**
- ✅ Connection is working
- ✅ Database has correct tables
- ✅ Data is loaded
- ✅ Ready for visualizations!

---

## What's Next?

Once your connection is working:

1. **Load Your Queries**: Open any file from `sql-queries/Storytelling/` folder
2. **Run Visualizations**: Follow [DBCODE_VISUALIZATION_GUIDE.md](DBCODE_VISUALIZATION_GUIDE.md)
3. **Export Charts**: Save visualizations to `visualizations/` folder
4. **Create Presentation**: Add visualizations to your PowerPoint/slides

---

## Troubleshooting

### Connection Shows But Tests Fail

**Action**: 
1. Double-check your credentials (especially password)
2. Verify you haven't been locked out in Azure Portal
3. Check if your IP is whitelisted in Azure SQL firewall

**To check IP whitelist:**
1. Go to https://portal.azure.com
2. Navigate to your SQL Server: cap2761cricardomolina
3. Look for **Firewalls and virtual networks**
4. Add your current IP if not present

### Can't Find DBCode Extension

**Action**:
1. Ensure VS Code is version 1.60 or higher: `Help → About`
2. Clear VS Code cache: `Ctrl+Shift+P` → `Developer: Reload Window`
3. Restart VS Code completely
4. Try reinstalling the extension

### Connection Works But No Tables Visible

**Action**:
1. Ensure you selected the correct database: `Final_Project`
2. Check database has tables: Run `SELECT * FROM INFORMATION_SCHEMA.TABLES`
3. Verify tables exist: Should show peaks, exped, members, refer

---

## Security Reminders ⚠️

✅ **DO:**
- Store credentials in .env files (with .env in .gitignore)
- Use environment variables in VS Code settings
- Rotate credentials regularly
- Use HTTPS/Encrypted connections only
- Review who has database access in Azure Portal

❌ **DON'T:**
- Hardcode passwords in .sql files
- Commit connection strings to GitHub
- Share credentials via email/messages
- Use the same password as other accounts
- Leave firewalls open to 0.0.0.0/0

---

## Quick Reference

| Task | Command | Keyboard |
|------|---------|----------|
| Open Connections | Ctrl+Shift+P → DBCode: Open Database Connection Manager | — |
| Run Query | Select SQL, then Run Query | Ctrl+Shift+E |
| New Connection | Click + in Connections panel | — |
| Test Connection | Right-click connection → Test | — |
| Format Query | Ctrl+Shift+P → Format Document | — |
| Switch Connection | Ctrl+Shift+P → DBCode: Select Connection | — |

---

## Next Steps

1. ✅ Install DBCode extension
2. ✅ Create new connection to Azure SQL
3. ✅ Test with sample query from step 6
4. ✅ Run one of your Storytelling queries
5. → Start creating visualizations (see DBCODE_VISUALIZATION_GUIDE.md)

**Questions?** Check the full visualization guide or retry the test query to identify the exact error message.
