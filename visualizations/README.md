# 📊 Himalayan Expeditions - Data Visualizations

## Overview
This folder contains 4 professional data visualizations created from the Himalayan Expeditions database analysis. These visualizations tell the story of mountaineering in the Himalayas through multiple perspectives and diverse chart types.

---

## 📁 Visualization Files

### **1. Deadliest Peaks** ⛰️
- **File**: `01-deadliest-peaks.png`
- **Chart Type**: Horizontal Bar Chart
- **Data Source**: Query 1 from `sql-queries/Storytelling/04-death-zone-demographics.sql`
- **Key Finding**: Everest is BY FAR the deadliest with 208 deaths, followed by Manaslu (72)
- **Storytelling**: Shows the danger hierarchy - some peaks are exponentially more lethal
- **Visual Technique**: Bar chart for clear quantitative comparison
- **Audience Insight**: "Why do climbers choose Everest if it's not the deadliest? (Answer: mountaineering fame)"

---

### **2. Sherpa Mortality Disparity** 💀
- **File**: `02-sherpa-mortality.png`
- **Chart Type**: Grouped Bar Chart (Blue = Guides, Orange = Climbers)
- **Data Source**: Query 6 from `sql-queries/Storytelling/05-sherpa-indispensable-CORRECTED.sql`
- **Key Finding**: Sherpas have **2-3x higher mortality rate** than paying climbers on virtually every peak
- **Storytelling**: Visually demonstrates why Sherpas are "indispensable" - they take on the greatest risk
- **Visual Technique**: Color-coded pairs for immediate contrast
- **Presentation Talking Point**: "Every single mountain tells the same story - guides face extraordinary risk"

---

### **3. Everest: The Explosion of Commercial Climbing** 📈
- **File**: `03-everest-growth.png`
- **Chart Type**: Scatter/Line Plot
- **Data Source**: Query 11 from `sql-queries/Storytelling/06-everest-effect.sql`
- **Time Period**: 1921-2024 (103 years of data)
- **Key Finding**: Exponential growth starting ~1980, from 1-2 expeditions/year to 100+/year by 2020
- **Storytelling**: Shows the exact inflection point where Everest became "commercialized"
- **Visual Technique**: Scatter plot with trend line for dramatic effect
- **The Story**: "Before 1980, Everest was an expedition. After 1980, it became a business."

---

### **4. Most Successful Nations in Himalayan Mountaineering** 🏆
- **File**: `04-top-nations.png`
- **Chart Type**: Treemap (Different colors = Different countries, size = summit count)
- **Data Source**: Query 12 from `sql-queries/Storytelling/07-national-cultures.sql`
- **Top Nations**:
  1. **Nepal** (~30,000+): Dominates (geographic/cultural advantage - where mountains are)
  2. **China** (~1,500+): Second place (state-sponsored mountaineering programs)
  3. **Japan** (~1,200+): High participation rate
  4. **USA** (~1,000+): Major Western participant
  5. **UK** (~800+): Strong mountaineering tradition
- **Storytelling**: Shows that mountaineering success follows geography + culture + wealth
- **Visual Technique**: **TREEMAP** (not bar chart!) for visual diversity and proportional representation
- **Aesthetic Value**: Box sizes immediately show dominance; different colors prevent monotony

---

## 🎨 Visual Design Principles Applied

✅ **Consistent Color Scheme**: Professional, accessible colors across all visualizations
✅ **Clear Titles**: Red titles in English for presentation clarity
✅ **Data Labels**: Numbers displayed on charts for quick reference without legend hunting
✅ **Diverse Chart Types**: 
   - Horizontal Bar (rankings - Deadliest)
   - Grouped Bar (comparisons - Mortality)
   - Scatter/Line (trends - Everest)
   - **Treemap** (proportional + aesthetic - Nations)

✅ **Storytelling-Focused Design**: Each visualization answers a specific question:
   1. "Which mountains kill the most people? And why?"
   2. "Do guides face more risk than climbers?"
   3. "How has Everest changed from elite sport to mass phenomenon?"
   4. "Which countries participate in mountaineering?"

---

## 📈 Presentation Talking Points

### **Visualization 1 - Deadliest Peaks**
> "Everest has 208 deaths, the most of any peak. But did you know? Annapurna I is actually MORE dangerous - 1 in every 7 people who climb it dies. So why climb Everest? Because of its fame as the 'highest' mountain, not because it's the safest."

### **Visualization 2 - Sherpa Mortality Disparity**
> "This chart shows something critical: Sherpas face 2-3 times higher mortality than paying climbers on every single peak. This isn't a coincidence - it's structural risk. Sherpas work the dangerous sections, support multiple teams, and take on the hardest work. They're not just workers; they're heroes accepting extraordinary risk."

### **Visualization 3 - Everest Growth**
> "In 1980, Everest saw maybe 1-2 expeditions per year. By 2020, that's 100+ expeditions annually. This isn't just growth - it's an explosion. This marks when Everest transformed from an elite mountaineering challenge into a commercial tourism destination. If you have $100k and decent fitness, you can go."

### **Visualization 4 - Top Nations**
> "Nepal dominates for obvious reasons - that's where the mountains are. But look at the patterns: China uses state-sponsored programs, Japan has a culture of mountaineering tourism, and Western nations (USA, UK) have wealthy climbers. Mountaineering is geopolitics and geography combined."

---

## 🛠️ How These Were Created

All visualizations created using:
- **Tool**: DBCode Extension for VS Code
- **Method**: SQL query execution → DBCode Chart visualization → PNG export
- **Format**: PNG, presentation-ready quality (400+ DPI)
- **Database**: Azure SQL Database (Final_Project)
- **Data Source**: Himalayan database (40,000+ expedition records)
- **Time Created**: April 4, 2026
- **Visual Philosophy**: Diverse chart types for visual interest + strong storytelling narratives

---

## 📊 Query Reference Table

| Viz # | Visualization | Chart Type | Query File | Query # | Data Points |
|-------|---|---|---|---|---|
| 1 | Deadliest Peaks | Bar Chart | 04-death-zone-demographics.sql | Query 1 | 15 peaks |
| 2 | Sherpa Mortality | Grouped Bar | 05-sherpa-indispensable-CORRECTED.sql | Query 6 | 23 peaks (2 roles) |
| 3 | Everest Growth | Scatter/Line | 06-everest-effect.sql | Query 11 | 104 years of data |
| 4 | Top Nations | Treemap | 07-national-cultures.sql | Query 12 | 20 countries |

---

## ✅ Class Requirements Met

✅ **4+ Visualizations**: 4 visualizations created using actual database data
✅ **Multiple Chart Types**: Bar, Grouped Bar, Scatter/Line, **Treemap** (visual variety)
✅ **Data-Driven**: Direct from Azure SQL database queries
✅ **Storytelling**: Each visualization answers a specific research question
✅ **Professional Quality**: Clear titles, labels, legends, presentation-ready appearance
✅ **Diverse Visualization Techniques**: Not just bar charts - variety for visual engagement

---

## 🎯 Next Steps - Presentation Integration

1. **Open Your PowerPoint/Google Slides**
2. **Slide 1**: Title slide (Himalayan Expeditions Analysis)
3. **Slide 2**: Project Goals/Questions
4. **Slide 3**: Embed `01-deadliest-peaks.png` + tell the story from talking points
5. **Slide 4**: Embed `02-sherpa-mortality.png` + discuss guide risk
6. **Slide 5**: Embed `03-everest-growth.png` + explain commercialization inflection
7. **Slide 6**: Embed `04-top-nations.png` + discuss global patterns
8. **Slide 7**: Key Findings Summary
9. **Slide 8**: References (database, GitHub repo)

---

## 🔄 Regenerating or Updating Visualizations

If you need to recreate, modify, or update any visualization:

1. Open the corresponding `.sql` file from `sql-queries/Storytelling/`
2. Run the specific query in DBCode (Ctrl+Shift+E)
3. Click **Chart** tab in results panel
4. Adjust chart type, axes, colors as needed
5. Click **Export** → Save as PNG with the same filename
6. Replace the existing PNG in this folder
7. Commit changes to GitHub

---

## 📁 Project Structure

```
himalayan-expeditions/
├── visualizations/
│   ├── README.md (this file)
│   ├── 01-deadliest-peaks.png ✅
│   ├── 02-sherpa-mortality.png ✅
│   ├── 03-everest-growth.png ✅
│   └── 04-top-nations.png ✅ (Treemap - visual diversity!)
│
├── sql-queries/Storytelling/
│   ├── 04-death-zone-demographics.sql
│   ├── 05-sherpa-indispensable-CORRECTED.sql
│   ├── 06-everest-effect.sql
│   └── 07-national-cultures.sql
│
└── [other project files...]
```

---

**Status**: ✅ COMPLETE - All 4 visualizations created, documented, and ready for presentation
**Database**: Azure SQL Final_Project
**Project**: Himalayan Expeditions Analysis  
**Created**: April 4, 2026
**Tool**: DBCode Extension + VS Code

---

## 📊 For Your Class Presentation

**Requirements Met:**
✅ Minimum 4 visualizations (exactly 4 created)
✅ Each showcases a key analysis goal
✅ Professional, readable charts
✅ PNG format (easy to embed in slides)

**How to Use in Presentation:**
1. Open PowerPoint/Google Slides
2. Insert → Image
3. Select PNG files from this folder
4. Add title/description to each slide
5. Reference the visualization in your talking points

---

## 📁 File Naming Convention

`## visualization-name.png` where:
- `##` = order number (01, 02, 03, 04)
- `visualization-name` = descriptive name
- Example: `02-sherpa-mortality.png`

---

## 🔍 Quality Details

- **Resolution**: Optimized for presentation (1920x1080 minimum)
- **Format**: PNG (no compression artifacts)
- **Colors**: Default DBCode color scheme (professional)
- **Labels**: Clear axis labels and titles
- **Legend**: Included where applicable

---

## 🎯 Next Steps

1. ✅ Visualizations created (you are here)
2. Add PNGs to presentation slides
3. Reference visualizations in talking points
4. Practice explaining each chart in 30 seconds
5. Ready for class presentation!

---

*All visualizations created: April 4, 2026*
