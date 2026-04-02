# 📈 VISUALIZATION GUIDE - Creating Charts from Query Results

## 🎯 RECOMMENDED VISUALIZATIONS (4+)

Select these 4 queries to create your visualizations using DBCode extension in VS Code:

---

## 📊 VISUALIZATION 1: "Deadliest Peaks" (Horizontal Bar Chart)
**Query:** `04-death-zone-demographics.sql` → Query 1  
**File:** `sql-queries/04-death-zone-demographics.sql`

**What to visualize:**
```
Columns:
  X-axis: Total Deaths (numeric)
  Y-axis: Peak Name (top 15)
  Color: Deaths Per Expedition (gradient)
```

**Expected chart:**
- Everest leads in absolute deaths (100+)
- K2 shows high deaths-per-expedition ratio
- Creates visual "fear factor"

**Why this chart:**
- Opens the story: "These mountains kill people" 
- **Story Phase:** Act 1 - The Human Cost

---

## 📊 VISUALIZATION 2: "Commercialization Boom" (Line Chart)
**Query:** `06-everest-effect.sql` → Query 10  
**File:** `sql-queries/06-everest-effect.sql`

**What to visualize:**
```
Columns:
  X-axis: Era (time periods)
  Y-axis: Hired (%) of Total (numeric %)
  Line: Secondary Y: Success Rate (%)
  
Lines to show:
  - Green line: Hired % trend (exponential growth)
  - Blue line: Success Rate trend (relatively flat)
```

**Expected chart:**
- 1960s: <5% hired staff
- 2010s: 30-50% hired staff
- Success rates stay similar (commercialization ≠ more summits)

**Why this chart:**
- Shows transformation: "Climbing became a business"
- **Story Phase:** Act 3 - The Everest Effect

---

## 📊 VISUALIZATION 3: "National Success Scorecard" (Scatter Plot)
**Query:** `07-national-cultures.sql` → Query 12  
**File:** `sql-queries/07-national-cultures.sql`

**What to visualize:**
```
Columns:
  X-axis: Mortality Rate (%) - numeric
  Y-axis: Summit Success Rate (%) - numeric
  Bubble Size: Total Participants (count)
  Color: Country/Region (categorical)
```

**Expected chart:**
- Nepal/Tibet: High success, low mortality (upper-left quadrant)
- USA/UK: High success, moderate mortality (upper-middle)
- Some nations: High mortality, lower success (problematic pattern)

**Why this chart:**
- Compares nations: "Who climbs best?"
- Shows risk vs. reward tradeoff
- **Story Phase:** Act 4 - National Cultures

---

## 📊 VISUALIZATION 4: "Experience Progression" (Stacked Column Chart)
**Query:** `07-national-cultures.sql` → Query 15  
**File:** `sql-queries/07-national-cultures.sql`

**What to visualize:**
```
Columns:
  X-axis: Experience Level (categories)
  Y-axis: Success Rate (%) - stacked
  
Stack segments:
  - Success (green)
  - Failure/Incomplete (orange)
  - Deaths (red)
```

**Expected chart:**
- First-timers: ~40% success, ~2% mortality
- Veterans (5+ summits): ~70% success, ~0.5% mortality
- Clear progression showing experience matters

**Why this chart:**
- Shows outcome correlation: "Skill matters"
- Optional: overlay line for mortality trend
- **Story Phase:** Act 4 - Experience effect

---

## 🛠️ HOW TO CREATE VISUALIZATIONS IN VS CODE

### Step 1: Install DBCode Extension (if needed)
```
VS Code → Extensions → Search "DBCode" → Install
```

### Step 2: Run Query & Export Results
```sql
-- In VS Code SQL Query window:
1. Open file: sql-queries/04-death-zone-demographics.sql
2. Highlight Query 1 (Which Peaks Kill Most?)
3. Execute query (Ctrl+Shift+E or right-click → Execute)
4. In results pane: Right-click → Export as CSV
5. Save as: viz1-deadliest-peaks.csv
```

### Step 3: Create Chart with DBCode
```
1. Right-click results panel → "Visualize"
2. Select chart type (Horizontal Bar)
3. Configure axes:
   - Category: pkname
   - Value: "Total Deaths"
4. Add secondary series: "Deaths Per Expedition" (optional)
5. Click "Save as Image" → Choose PNG format
6. Save to: docs/visualizations/
```

---

## 📸 SCREENSHOT EXPORT GUIDE

**For inclusion in GitHub README:**

```
1. After creating chart in DBCode:
   - Right-click visualization → "Save as Image"
   - OR use Windows Snip & Sketch (Win+Shift+S)
   - Save as: deadliest-peaks.png

2. Create docs/visualizations/ folder:
   mkdir docs/visualizations

3. Save 2 best charts for README:
   - docs/visualizations/deadliest-peaks.png
   - docs/visualizations/commercialization-timeline.png

4. Update README.md:
   ![Deadliest Peaks](docs/visualizations/deadliest-peaks.png)
```

---

## 📋 ALTERNATIVE: Using Other Tools

If DBCode visualization doesn't work smoothly, export CSV and use:

### **Option A: Excel/Google Sheets**
```
1. Export query results as CSV
2. Open in Excel/Google Sheets
3. Insert → Chart
4. Select chart type
5. Screenshot chart
```

### **Option B: Python + Matplotlib** (if you prefer)
```python
import pandas as pd
import matplotlib.pyplot as plt

# Read CSV from query export
df = pd.read_csv('query_results.csv')

# Create chart
plt.figure(figsize=(12, 8))
plt.barh(df['Peak Name'], df['Total Deaths'])
plt.xlabel('Total Deaths')
plt.title('Deadliest Mountains in Himalayan History')
plt.tight_layout()
plt.savefig('deadliest-peaks.png', dpi=150)
```

### **Option C: Power BI / Tableau**
```
1. Connect to Azure SQL Database
2. Create reports from views
3. Export visualizations
```

---

## 📊 EXPECTED CHART TYPES

| Visualization | Chart Type | Best For |
|---|---|---|
| Deadliest Peaks | Horizontal Bar | Comparing categorical values |
| Commercialization Trend | Line Chart | Time series / trends |
| National Comparison | Scatter Plot | 2D relationship analysis |
| Experience Progression | Stacked Column | Composition over time |

---

## 🎯 REQUIREMENTS CHECK

**For your project to meet minimum requirements:**

✅ At least 4 visualizations created  
✅ At least 2 visualizations as PNG in README  
✅ Visualizations showcase your analysis  
✅ Charts are publication-quality  

---

## 💡 STORYTELLING WITH VISUALS

**After creating charts:**

1. **Arrange visually** to follow narrative:
   - Act 1: Deadliest Peaks chart
   - Act 3: Commercialization chart
   - Act 4: National/Experience charts

2. **Add captions** explaining what we see:
   ```markdown
   ![Deadliest Peaks](...)
   **Figure 1:** Mount Everest leads in absolute deaths (100+), while K2 shows the highest death 
   rate per expedition. This reveals that popularity ≠ safety.
   ```

3. **Connect to research questions:**
   - Each chart answers a question
   - Each question advances the story

---

## 🚀 NEXT STEPS

1. **Run Query 1** from `04-death-zone-demographics.sql`
2. **Create first chart** (Deadliest Peaks)
3. **Export as PNG** to `docs/visualizations/`
4. **Repeat for 3 more queries**
5. **Update README** with 2 best charts
6. **Commit visualizations** to GitHub

**Ready to create your first chart?** Start with Query 1! 📊
