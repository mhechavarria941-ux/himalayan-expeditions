# 📊 Creating Visualizations with DBCode Extension

## Step-by-Step Guide to Visualize Your Queries

### Prerequisites
✅ VS Code installed
✅ DBCode extension installed (search "dbcode" in VS Code Extensions)
✅ Your Azure SQL queries ready to run
✅ Credentials set up (environment variables or Azure Portal)

---

## 🚀 Quick Start: 4 Steps to Create Chart

### **Step 1: Open Your Query File**
1. In VS Code, open any `.sql` file from `sql-queries/Storytelling/`
2. Example: `04-death-zone-demographics.sql`

### **Step 2: Select and Run Query**
1. Highlight the query code you want to visualize
2. Press `Ctrl+Shift+P` (Command Palette)
3. Search for: `DBCode: Run Query`
4. Select your connection (or create new)
5. Query results appear in bottom panel

### **Step 3: Switch to Visualization Tab**
1. In the results panel, look for tabs at the bottom
2. Click on the **"Chart"** or **"Visualize"** tab (not Results tab)
3. Select chart type:
   - **Bar Chart** - Great for comparisons (deadliest peaks, top countries)
   - **Line Chart** - Great for trends (Everest growth over years)
   - **Pie/Donut** - Great for percentages (Sherpa participation %)
   - **Scatter Plot** - Great for correlations

### **Step 4: Customize & Export**
1. Click chart type dropdown to choose visualization
2. Click "X" axis and "Y" axis dropdowns to select columns
3. Click **Export** or **Screenshot** button
4. Save as PNG to `visualizations/` folder (create folder if needed)

---

## 📈 Recommended Visualizations (4 Created ✅)

### **Visualization 1: Deadliest Peaks** ⛰️ ✅ COMPLETE
- **Query**: Query 1 from `04-death-zone-demographics.sql`
- **Chart Type**: Horizontal Bar Chart
- **X-Axis**: Peak Name (pkname)
- **Y-Axis**: Total Deaths (SUM mdeaths)
- **Top**: 15 peaks
- **Title**: "15 Deadliest Himalayan Peaks by Fatality Count"
- **File**: `visualizations/01-deadliest-peaks.png`
- **Story**: Everest dominates with 208 deaths, but Annapurna I is MORE dangerous per summit attempt

### **Visualization 2: Sherpa Mortality Disparity** 💀 ✅ COMPLETE
- **Query**: Query 6 from `05-sherpa-indispensable-CORRECTED.sql`
- **Chart Type**: Grouped Bar Chart (Blue = Guides, Orange = Climbers)
- **X-Axis**: Peak Name
- **Y-Axis**: Mortality Rate (%)
- **Title**: "Mortality Rate: Sherpas vs Paying Climbers"
- **File**: `visualizations/02-sherpa-mortality.png`
- **Story**: 2-3x higher mortality for guides on EVERY peak - they accept the greatest risk

### **Visualization 3: Everest Expedition Growth** 📈 ✅ COMPLETE
- **Query**: Query 11 from `06-everest-effect.sql`
- **Chart Type**: Scatter/Line Plot
- **X-Axis**: Year (1921-2024)
- **Y-Axis**: Number of Expeditions
- **Title**: "Everest: The Explosion of Commercial Climbing (1921-2024)"
- **File**: `visualizations/03-everest-growth.png`
- **Story**: Exponential growth after 1980 - the exact inflection point where Everest became commercialized

### **Visualization 4: Top Summiting Nations** 🏆 ✅ COMPLETE
- **Query**: Query 12 from `07-national-cultures.sql`
- **Chart Type**: TREEMAP (not bar chart - visual diversity!)
- **Visual Encoding**: Box size = summit count, Color = different country
- **Top Nations**: Nepal dominates, followed by China, Japan, USA, UK
- **Title**: "Most Successful Nations in Himalayan Mountaineering"
- **File**: `visualizations/04-top-nations.png`
- **Story**: Mountaineering follows geography (where mountains are) + culture + wealth
- **Why Treemap?** Provides visual variety, makes proportional differences immediately obvious, more engaging than 4 identical bar charts

---

## 🎨 DBCode Features

### **Chart Customization**
- Change colors
- Add title
- Toggle legend
- Change axis labels
- Adjust scale

### **Export Options**
- 📸 Screenshot (PNG)
- 📄 Export Data (CSV)
- 🎨 Copy as Image (clipboard)

### **Connection Management**
1. `Ctrl+Shift+P` → "DBCode: Show Connections"
2. Add connection if needed:
   - Server: `<YOUR_SERVER>.database.windows.net`
   - Database: `Final_Project`
   - Username/Password: From environment variables or Azure Portal

---

## ⚡ Quick Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Run Query | `Ctrl+Shift+E` or `Cmd+Shift+E` |
| Open DBCode | `Ctrl+Shift+D` |
| Command Palette | `Ctrl+Shift+P` |
| Save Screenshot | `Ctrl+S` (when visualization open) |

---

## 🛠️ Troubleshooting

**Problem**: "No connection found"
- Solution: Create new connection via Command Palette → "DBCode: Add Connection"

**Problem**: "Query returns no results"
- Solution: Check that you're using correct environment variables or Azure Portal credentials

**Problem**: "Chart won't display"
- Solution: Make sure query has aggregated data (GROUP BY), not raw rows

**Problem**: "Can't export as PNG"
- Solution: Right-click on chart → Save Image, or use browser DevTools screenshot

---

## 📁 File Structure After Creating Visuals

```
himalayan-expeditions/
├── visualizations/ (NEW FOLDER - create this)
│   ├── 01-deadliest-peaks.png
│   ├── 02-sherpa-mortality.png
│   ├── 03-everest-growth.png
│   └── 04-top-nations.png
│
└── [all other project files...]
```

---

## ✅ Next Steps

1. Open VS Code with your project
2. Ensure DBCode extension is installed
3. Open first query file: `sql-queries/Storytelling/04-death-zone-demographics.sql`
4. Run Query 1 (Deadliest Peaks)
5. Switch to Chart tab
6. Create Bar Chart
7. Export as PNG
8. Repeat for 3 more visualizations
9. Add PNGs to GitHub in `visualizations/` folder

---

**Ready?** Let's create your first visualization! 🚀
