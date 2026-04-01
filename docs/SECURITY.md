# 🔐 Security Best Practices

## ⚠️ Important: Never Share Credentials

This project has been sanitized to remove all hardcoded credentials from the public repository. This document explains how to securely manage your Azure SQL Database credentials.

---

## 🚨 Critical Rules

### ❌ DO NOT:
- Commit credentials to Git repositories
- Share connection strings in email or chat
- Store passwords in code files
- Use the same credentials for development and production
- Enable public access to your database (use firewall rules)

### ✅ DO:
- Keep credentials locally in environment variables
- Use Azure Key Vault for production secrets
- Rotate credentials regularly
- Use principle of least privilege (minimal required permissions)
- Store sensitive info in `.env` files (add to `.gitignore`)
- Enable Azure SQL Server auditing and threat detection
- Use strong passwords (minimum 12 characters, mixed case, numbers, symbols)

---

## 🔑 How to Use This Repository Securely

### Option 1: Command-Line Parameters (Recommended for Local Development)

```powershell
# Run the script with your credentials as parameters
powershell -File "scripts\bulk_load_csv.ps1" `
    -Server "YOUR_SERVER.database.windows.net" `
    -Username "YOUR_USERNAME" `
    -Password "YOUR_PASSWORD"
```

**Advantages:**
- Credentials not stored in files
- Works with different environments
- Easy to audit who has credentials

---

### Option 2: Environment Variables

Create a `.env` file in your project root (ensure it's in `.gitignore`):

```
AZURE_SERVER=YOUR_SERVER.database.windows.net
AZURE_USERNAME=YOUR_USERNAME
AZURE_PASSWORD=YOUR_PASSWORD
```

Add to `.gitignore`:
```
.env
*.env
config/credentials*
```

Then in PowerShell:
```powershell
$env:AZURE_SERVER = "YOUR_SERVER.database.windows.net"
$env:AZURE_USERNAME = "YOUR_USERNAME"
$env:AZURE_PASSWORD = "YOUR_PASSWORD"

powershell -File "scripts\bulk_load_csv.ps1"
```

---

### Option 3: Azure Key Vault (Production)

For production environments, use Azure Key Vault:

```powershell
# Authenticate to Azure
Connect-AzAccount

# Get secret from Key Vault
$secret = Get-AzKeyVaultSecret -VaultName "MyVault" `
    -Name "SqlPassword" -AsPlainText
```

**Advantages:**
- Centralized secret management
- Audit logging
- Auto-rotation support
- Per-user role-based access

---

## 🔒 Azure SQL Server Security Checklist

**After deploying your database:**

- [ ] Set firewall rules (restrict IP addresses)
- [ ] Enable Transparent Data Encryption (TDE)
- [ ] Enable SQL Server auditing
- [ ] Enable Advanced Threat Protection
- [ ] Use SQL authentication with strong passwords
- [ ] Consider Azure AD authentication for users
- [ ] Regularly review access logs
- [ ] Backup database daily
- [ ] Test restore procedures

---

## 📝 .gitignore Template

Ensure these files are ignored in Git:

```
# Security & Credentials
.env
.env.local
*.pem
*.key
credentials.*
secrets.*
config/local.*

# Sensitive Scripts
scripts/deploy-prod.ps1
scripts/reset-db.ps1

# Logs & Temporary Files
*.log
*.tmp
*.bak
```

---

## 🚀 Credentials Rotation

### Every 90 days:

1. **Generate new password** in Azure Portal
2. **Update Key Vault/environment** with new credentials
3. **Test connection** before deploying
4. **Update all scripts** to use new credentials
5. **Disable old credentials** in Azure Portal
6. **Document the change** with timestamp

---

## 🆘 If Credentials Are Exposed

**Immediately:**
1. Go to Azure Portal → SQL Database → Connection strings
2. Click "Change password" 
3. Generate strong new password
4. Update all connection strings
5. Check Azure activity logs for unauthorized access
6. Review database audit logs
7. Notify your team

---

## 📚 Resources

- [Azure SQL Security Best Practices](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-security-best-practice)
- [Azure Key Vault Documentation](https://docs.microsoft.com/en-us/azure/key-vault/)
- [SQL Server Auditing](https://docs.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-database-engine)
- [OWASP Top 10 - Security Risks](https://owasp.org/www-project-top-ten/)

---

## ✨ Summary

**Remember:** Credentials in this repository have been removed and replaced with `YOUR_SERVER`, `YOUR_USERNAME`, and `YOUR_PASSWORD` placeholders. 

When running scripts, always provide your actual credentials securely via command-line parameters or environment variables.

**Your security is your responsibility.** 🔐
