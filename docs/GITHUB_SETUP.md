# GitHub Setup Guide

## How to Create Your GitHub Repository

This guide will walk you through the steps to create a GitHub repository and push this project online.

---

## Prerequisites

- GitHub account (create at github.com if you don't have one)
- Git installed on your computer
- The project folder with all files

---

## Step 1: Create a New Repository on GitHub

1. Go to [github.com](https://github.com)
2. Sign in to your account
3. Click the **+** icon in the top right corner
4. Select **"New repository"**

### Configure Your Repository Settings

| Setting | Value |
|---------|-------|
| Repository name | `himalayan-expeditions` |
| Description | "Database normalization and analysis of Himalayan mountaineering expedition data" |
| Visibility | **Public** (or Private if you prefer) |
| Initialize repository | **Leave UNCHECKED** (we'll push existing files) |

5. Click **"Create repository"**

---

## Step 2: Prepare Local Git Repository

Open **PowerShell** in your project folder and run:

```powershell
# Navigate to your project folder
cd "C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT"

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Himalayan Expeditions database normalization project"
```

---

## Step 3: Connect to GitHub Repository

After creating the repository on GitHub, you'll see instructions. In PowerShell:

```powershell
# Add remote (replace YOUR_USERNAME with your actual GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/himalayan-expeditions.git

# Verify the remote was added
git remote -v
```

**You should see:**
```
origin  https://github.com/YOUR_USERNAME/himalayan-expeditions.git (fetch)
origin  https://github.com/YOUR_USERNAME/himalayan-expeditions.git (push)
```

---

## Step 4: Push to GitHub

```powershell
# Push to GitHub (you may be prompted for credentials)
git branch -M main
git push -u origin main
```

**First time users**: GitHub may prompt for authentication. Use one of:
- GitHub Personal Access Token (recommended)
- GitHub CLI authentication
- Username and password (if enabled)

---

## Step 5: Verify on GitHub

1. Go to your repository on GitHub: `https://github.com/YOUR_USERNAME/himalayan-expeditions`
2. You should see all your files there
3. The README.md will display automatically on the repository home page

---

## Additional GitHub Configuration (Optional but Recommended)

### Add a License

```powershell
# GitHub can auto-add licenses. Or add manually:
# Copy MIT License or other license to LICENSE file in project folder

git add LICENSE
git commit -m "Add MIT License"
git push
```

### Add Topics/Tags

On GitHub (web interface):
1. Go to your repository
2. Click **"About"** (gear icon on right)
3. Add topics like: `database`, `sql`, `normalization`, `analytics`, `mountaineering`

### Add Collaborators (Optional)

On GitHub (web interface):
1. Go Settings → Collaborators
2. Add collaborators by GitHub username

---

## Updating Your Repository

After making changes locally:

```powershell
# Check status of changes
git status

# Stage changes
git add .

# Commit changes
git commit -m "Descriptive commit message"

# Push to GitHub
git push
```

---

## Common Git Commands

```powershell
# View commit history
git log

# See changes that haven't been committed
git diff

# Create a new branch for features
git checkout -b feature-name

# Switch to main branch
git checkout main

# Merge a branch
git merge feature-name

# View all branches
git branch -a
```

---

## Troubleshooting

### Authentication Error: "fatal: Authentication failed"
```powershell
# Use git credentials to store authentication
git config credential.helper store

# Then try pushing again - you'll be prompted once, then it's remembered
git push
```

### Error: "fatal: could not read Username"
- Use GitHub Personal Access Token instead of password
- Create one at: Settings → Developer settings → Personal access tokens

### Remote URL is Wrong
```powershell
# Check current remote
git remote -v

# Update remote URL
git remote set-url origin https://github.com/NEW_USERNAME/himalayan-expeditions.git
```

### Large Files Warning
The .gitignore file already excludes large batch SQL files. If you get a LFS (Large File Storage) warning:
```powershell
# Don't add large files to git
# Or use GitHub LFS for files over 100MB
git lfs install
git lfs track "*.sql"
git add .gitattributes
```

---

## .gitignore Summary

The `.gitignore` file in this project excludes:
- ✅ Credentials and .env files
- ✅ Generated batch SQL files (can be regenerated)
- ✅ Python cache and compiled files
- ✅ IDE configuration files
- ✅ Large temporary files

This keeps your repository clean and focused on source code.

---

## Repository Best Practices

1. **Write clear commit messages**: Describe what and why, not just what changed
2. **Commit frequently**: Logical, related changes in single commits
3. **Use branches**: Create branches for features/fixes before merging to main
4. **Review before pushing**: Use `git diff` to verify changes
5. **Update README**: Keep documentation current
6. **Add .gitignore early**: Exclude unnecessary files from git

---

## Next Steps After Upload

1. **Share the link**: Your repository is now at `https://github.com/YOUR_USERNAME/himalayan-expeditions`
2. **Add to portfolio**: Link to your GitHub in your resume/portfolio
3. **Document progress**: Keep README updated as you work on features
4. **Enable GitHub Pages** (optional): Serve documentation as a website

---

## Using GitHub Desktop (Alternative to Command Line)

If you prefer a graphical interface:

1. Download [GitHub Desktop](https://desktop.github.com)
2. Sign in with your GitHub account
3. Go to File → Clone Repository
4. Find your repository and clone it
5. Make changes locally
6. Commit changes in GitHub Desktop
7. Click Publish/Push button

---

## Example Workflow

```powershell
# 1. Create feature branch
git checkout -b add-member-analytics

# 2. Make changes to files locally

# 3. Stage changes
git add .

# 4. Commit
git commit -m "Add member participation analytics queries"

# 5. Push to GitHub
git push -u origin add-member-analytics

# 6. On GitHub web interface, create Pull Request (PR)
# 7. After review, merge PR to main
# 8. Delete branch

git checkout main
git pull
git branch -d add-member-analytics
```

---

## Support Resources

- **Git Documentation**: https://git-scm.com/doc
- **GitHub Help**: https://docs.github.com
- **GitHub Learning Lab**: https://github.com/skills
- **Markdown Guide**: https://www.markdownguide.org

---

**Ready to share your project? Push it now!**

```powershell
git push -u origin main
```

Your Himalayan Expeditions project will be live on GitHub! 🚀

---

**Last Updated**: March 26, 2026
