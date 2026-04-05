# ⚠️ SECURITY INCIDENT - CREDENTIALS EXPOSED

## What Happened

Database credentials were accidentally committed to the public GitHub repository in the following files on April 2, 2026:
- `FINAL_STATUS.md`
- `TEST_VERIFICATION_REPORT.md`
- `sql/Database-Schema/README.md`
- `sql/Database-Schema/HOW-TO-EXPORT-SCHEMAS.md`

## Credentials Exposed
- **Server**: cap2761cricardomolina.database.windows.net
- **Database**: Final_Project
- **Username**: admin_ct
- **Passwords**: demo123, Demo123456

## Actions Taken

### ✅ Immediate Actions
1. Removed all hardcoded credentials from public files
2. Replaced with generic placeholders: `<YOUR_SERVER>`, `<YOUR_USERNAME>`, etc.
3. Updated all files to use environment variables instead
4. Committed fixes to GitHub

### ⚠️ REQUIRED: Immediate Actions by User

**YOU MUST DO THIS IMMEDIATELY:**

1. **ROTATE DATABASE CREDENTIALS** 
   - Change the password for `admin_ct` user immediately
   - Go to Azure Portal → SQL Database → Connection strings
   - Use new credentials moving forward

2. **INVALIDATE OLD PASSWORD**
   - Do NOT use `demo123` or `Demo123456` anymore
   - Any previous access with these credentials is now compromised

3. **VERIFY NO DATA WAS ACCESSED**
   - Check Azure SQL audit logs for unauthorized access
   - Navigate to: Azure Portal → SQL Database → Auditing → View audit logs

4. **ROTATE API TOKENS/KEYS** (if any)
   - If connection strings were used elsewhere, rotate them too
   - Check all development machines for cached credentials

---

## Security Best Practices Going Forward

### ✅ DO:
```powershell
# Use environment variables
$password = $env:AZURE_SQL_PASSWORD
sqlcmd -S $server -U $user -P $password

# Use .env files (locally, never commit)
# Use Azure Key Vault for production
# Use Managed Identity in Azure
# Use Azure CLI for authentication
```

### ❌ DON'T:
```powershell
# Never hardcode credentials
sqlcmd -S "server" -U "user" -P "password123"

# Never commit .env files
# Never share passwords in code
# Never expose credentials in documentation
```

---

## Files With Credentials Removed

| File | Change | Status |
|------|--------|--------|
| FINAL_STATUS.md | Removed passwords | ✅ Fixed |
| TEST_VERIFICATION_REPORT.md | Removed passwords | ✅ Fixed |
| sql/Database-Schema/README.md | Removed credentials | ✅ Fixed |
| sql/Database-Schema/HOW-TO-EXPORT-SCHEMAS.md | Removed server name + creds | ✅ Fixed |

---

## How to Handle in Future

### For Your Class Project:
1. **Store credentials locally only** (in .env file, never committed)
2. **Get connection string from instructor** during presentation
3. **Use environment variables** when running scripts:
   ```powershell
   $env:AZURE_SQL_SERVER = "your-server"
   $env:AZURE_SQL_DB = "your-db"
   $env:AZURE_SQL_USER = "your-user"
   $env:AZURE_SQL_PASSWORD = "your-password"
   ```

### For Production Systems:
- Use Azure Key Vault
- Use Managed Identities
- Use Azure CLI authentication
- Never commit secrets to repository

---

## Commit History

- **Commit 9635256** (April 2, 2026): Added schema export scripts (WITH credentials - removed in next commit)
- **Commit [NEXT]** (April 2, 2026): SECURITY FIX - Removed all credentials from repository

---

## References

- [Azure Key Vault Documentation](https://docs.microsoft.com/en-us/azure/key-vault/)
- [GitHub - Managing Sensitive Data](https://docs.github.com/en/code-security/secret-scanning)
- [OWASP - Secrets Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)

---

**Status**: ⚠️ FIXED BUT REQUIRES CREDENTIAL ROTATION
**Last Updated**: April 2, 2026
