# Wine Quality Analysis

## Project Overview
Exploratory analysis of wine physicochemical properties and their relationship 
with quality using SQL (MySQL) and Tableau. The original single-table dataset 
was normalized into 4 relational tables to demonstrate database design skills 
and enable multi-table JOIN analysis.

---

## Dataset
- **Source:** [Wine Quality Dataset - Kaggle](https://www.kaggle.com/datasets/yasserh/wine-quality-dataset)
- **Records:** 1,143 wine samples
- **Original format:** Single table normalized into 4 relational tables

## Database Schema
```
wines          → Id, quality, alcohol
acidity        → Id, fixed_acidity, volatile_acidity, citric_acid, pH
chemical_props → Id, residual_sugar, chlorides, sulphates, density
sulfur         → Id, free_sulfur_dioxide, total_sulfur_dioxide
```
All tables relate through `Id` (Primary Key)

---

## Tools
- **MySQL** — database normalization, querying and analysis
- **Tableau** — dashboard and data visualization

---

## File Structure
```
wine_quality_analysis.sql
│
├── 1. OVERVIEW
├── 2. ACIDITY ANALYSIS
├── 3. CHEMICAL PROPERTIES ANALYSIS
├── 4. SULFUR ANALYSIS
└── 5. ADVANCED ANALYSIS
```
---

## Key Findings

### 1. Overview
- The dataset contains **1,143 wine samples** with quality scores ranging from 
  **3 to 8**, averaging **5.66**
- **82.68% of wines score 5 or 6**, indicating a heavily concentrated 
  medium-quality distribution
- Only **1.40% of wines achieve a score of 8** (the highest in the dataset)
- A clear positive relationship exists between **alcohol content and quality**: 
  low quality wines average 10.17% alcohol vs 11.53% for high quality wines

### 2. Acidity Analysis
- **Volatile acidity decreases consistently as quality increases**: from 0.90 
  in quality 3 wines down to 0.41 in quality 8, confirming its role as a 
  key negative quality driver
- **Citric acid increases with quality**: from 0.21 in quality 3 up to 0.43 
  in quality 8, suggesting it contributes positively to wine quality
- **544 out of 1,143 wines** (47.6%) have above-average volatile acidity, 
  and these wines concentrate heavily in quality scores 5 and 6
- pH remains relatively stable across quality segments (3.28–3.39), 
  suggesting it is not a primary quality differentiator

### 3. Chemical Properties Analysis
- **Sulphates increase with quality**: from 0.55 in quality 3 to 0.77 in 
  quality 8, acting as a positive quality driver through their antimicrobial 
  and antioxidant properties
- **Chlorides decrease as quality increases**: from 0.105 in quality 3 down 
  to 0.070 in quality 8, indicating lower salt content in better wines
- **Density decreases slightly with quality**: high quality wines (0.9960) 
  are marginally less dense than low quality ones (0.9968), consistent 
  with their higher alcohol content
- **444 wines** exceed average sulphate levels, with the majority 
  concentrated in quality scores 5, 6 and 7

### 4. Sulfur Analysis
- Average **free SO2 is 15.62 mg/L** and **total SO2 is 45.91 mg/L** 
  across all wines
- Medium quality wines show the **highest total SO2** (47.79 mg/L), 
  while high quality wines average only 36.67 mg/L
- The **free-to-total SO2 ratio is highest in high quality wines** (38.69%), 
  suggesting more effective preservation with less total sulfur usage

### 5. Advanced Analysis
- **267 wines exceed the average** in alcohol, sulphates and citric acid 
  simultaneously, and these wines skew strongly toward quality scores 6, 7 and 8
- **Chemical anomalies** (values beyond 2 standard deviations) were detected 
  in volatile acidity, residual sugar and total SO2, representing potential 
  outliers worth investigating
- The comprehensive quality profile confirms that **quality 8 wines** 
  consistently show: highest alcohol (11.94%), lowest volatile acidity (0.41), 
  highest sulphates (0.77) and lowest chlorides (0.070)

---

## Key Quality Drivers
| Property | Direction | Impact |
|---|---|---|
| Alcohol | ↑ higher = better | Strong positive |
| Volatile acidity | ↓ lower = better | Strong negative |
| Sulphates | ↑ higher = better | Positive |
| Citric acid | ↑ higher = better | Positive |
| Chlorides | ↓ lower = better | Negative |
| Total SO2 | ↓ lower = better | Negative |

---

## Business Recommendations
- Focus production on wines with **alcohol > 11%** and **volatile acidity < 0.5** 
  to maximize quality scores
- Review wines with **total SO2 > 100 mg/L** as they consistently score lower quality
- The 82% concentration in medium quality (5-6) suggests significant room for 
  improvement through targeted adjustments in volatile acidity and sulphate levels
