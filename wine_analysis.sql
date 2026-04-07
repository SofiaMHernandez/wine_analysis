-- ========================================================================================
-- Wine Quality Analysis
-- Dataset: Wine Quality Dataset (Kaggle)
-- Source: https://www.kaggle.com/datasets/yasserh/wine-quality-dataset
-- Author: Sofia Hernandez Bellone
-- Description: Exploratory analysis of wine quality based on physicochemical properties.
--              The original dataset was normalized into 4 relational tables covering
--              acidity, chemical properties, sulfur compounds and quality metrics.
--              Analysis includes quality drivers, chemical correlations, and
--              property distributions across 1,143 wine samples.
-- ========================================================================================

-- ========================================================================================
-- Create normalized tables from wineqt
-- ========================================================================================

-- Table 1: wines (main table)
CREATE TABLE wines AS
SELECT 
    Id,
    quality,
    alcohol
FROM wineqt;

-- Table 2: acidity
CREATE TABLE acidity AS
SELECT 
    Id,
    `fixed acidity`     AS fixed_acidity,
    `volatile acidity`  AS volatile_acidity,
    `citric acid`       AS citric_acid,
    pH
FROM wineqt;

-- Table 3: chemical_properties
CREATE TABLE chemical_properties AS
SELECT 
    Id,
    `residual sugar`    AS residual_sugar,
    chlorides,
    sulphates,
    density
FROM wineqt;

-- Table 4: sulfur
CREATE TABLE sulfur AS
SELECT 
    Id,
    `free sulfur dioxide`   AS free_sulfur_dioxide,
    `total sulfur dioxide`  AS total_sulfur_dioxide
FROM wineqt;

-- ========================================================================================
-- 1. OVERVIEW
-- ========================================================================================

-- 1.1 General Summary
-- High-level snapshot of the dataset.
SELECT
    COUNT(*)                        AS total_wines,
    ROUND(AVG(quality), 2)          AS avg_quality,
    MIN(quality)                    AS min_quality,
    MAX(quality)                    AS max_quality,
    ROUND(AVG(alcohol), 2)          AS avg_alcohol,
    MIN(alcohol)                    AS min_alcohol,
    MAX(alcohol)                    AS max_alcohol
FROM wines;

-- 1.2 Quality Distribution
-- Shows how wines are distributed across quality scores.
SELECT
    quality,
    COUNT(*)                                            AS total_wines,
    ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 2)   AS percentage
FROM wines
GROUP BY quality
ORDER BY quality;

-- 1.3 Quality Classification
-- Classifies wines into Low, Medium and High quality segments.
SELECT
    CASE
        WHEN quality <= 4   THEN 'Low (<=4)'
        WHEN quality <= 6   THEN 'Medium (5-6)'
        ELSE                     'High (>=7)'
    END                     AS quality_segment,
    COUNT(*)                AS total_wines,
    ROUND(AVG(alcohol), 2)  AS avg_alcohol
FROM wines
GROUP BY quality_segment
ORDER BY quality_segment;

-- 1.4 Alcohol Distribution by Quality
-- Explores whether higher quality wines tend to have more alcohol.
SELECT
    quality,
    ROUND(AVG(alcohol), 2)  AS avg_alcohol,
    ROUND(MIN(alcohol), 2)  AS min_alcohol,
    ROUND(MAX(alcohol), 2)  AS max_alcohol
FROM wines
GROUP BY quality
ORDER BY quality;

-- ========================================================================================
-- 2. ACIDITY ANALYSIS
-- ========================================================================================

-- 2.1 Acidity Overview
-- Summary statistics for all acidity-related properties.
SELECT
    ROUND(AVG(fixed_acidity), 2)    AS avg_fixed_acidity,
    ROUND(AVG(volatile_acidity), 2) AS avg_volatile_acidity,
    ROUND(AVG(citric_acid), 2)      AS avg_citric_acid,
    ROUND(AVG(pH), 2)               AS avg_pH
FROM acidity;

-- 2.2 Acidity by Quality
-- Analyzes how acidity properties differ across quality levels.
-- High volatile acidity is generally associated with lower quality wines.
SELECT
    w.quality,
    ROUND(AVG(a.fixed_acidity), 2)      AS avg_fixed_acidity,
    ROUND(AVG(a.volatile_acidity), 2)   AS avg_volatile_acidity,
    ROUND(AVG(a.citric_acid), 2)        AS avg_citric_acid,
    ROUND(AVG(a.pH), 2)                 AS avg_pH
FROM wines w
JOIN acidity a ON w.Id = a.Id
GROUP BY w.quality
ORDER BY w.quality;

-- 2.3 High Volatile Acidity Wines
-- Identifies wines with above-average volatile acidity and their quality scores.
-- High volatile acidity can lead to unpleasant vinegar taste.
SELECT
    w.quality,
    COUNT(*)                            AS total_wines,
    ROUND(AVG(a.volatile_acidity), 2)   AS avg_volatile_acidity
FROM wines w
JOIN acidity a ON w.Id = a.Id
WHERE a.volatile_acidity > (SELECT AVG(volatile_acidity) FROM acidity)
GROUP BY w.quality
ORDER BY w.quality;

-- 2.4 pH Range by Quality Segment
-- Compares pH levels across quality segments.
SELECT
    CASE
        WHEN w.quality <= 4 THEN 'Low (<=4)'
        WHEN w.quality <= 6 THEN 'Medium (5-6)'
        ELSE                     'High (>=7)'
    END                         AS quality_segment,
    ROUND(AVG(a.pH), 2)         AS avg_pH,
    ROUND(MIN(a.pH), 2)         AS min_pH,
    ROUND(MAX(a.pH), 2)         AS max_pH
FROM wines w
JOIN acidity a ON w.Id = a.Id
GROUP BY quality_segment
ORDER BY quality_segment;

-- ========================================================================================
-- 3. CHEMICAL PROPERTIES ANALYSIS
-- ========================================================================================

-- 3.1 Chemical Properties Overview
-- Summary statistics for all chemical properties.
SELECT
    ROUND(AVG(residual_sugar), 2)   AS avg_residual_sugar,
    ROUND(AVG(chlorides), 2)        AS avg_chlorides,
    ROUND(AVG(sulphates), 2)        AS avg_sulphates,
    ROUND(AVG(density), 4)          AS avg_density
FROM chemical_properties;

-- 3.2 Chemical Properties by Quality
-- Analyzes how chemical properties vary across quality levels.
SELECT
    w.quality,
    ROUND(AVG(cp.residual_sugar), 2)    AS avg_residual_sugar,
    ROUND(AVG(cp.chlorides), 4)         AS avg_chlorides,
    ROUND(AVG(cp.sulphates), 2)         AS avg_sulphates,
    ROUND(AVG(cp.density), 4)           AS avg_density
FROM wines w
JOIN chemical_properties cp ON w.Id = cp.Id
GROUP BY w.quality
ORDER BY w.quality;

-- 3.3 High Sulphates Wines
-- Sulphates act as antimicrobial agents and antioxidants.
-- Identifies whether higher sulphates correlate with higher quality.
SELECT
    w.quality,
    COUNT(*)                        AS total_wines,
    ROUND(AVG(cp.sulphates), 2)     AS avg_sulphates
FROM wines w
JOIN chemical_properties cp ON w.Id = cp.Id
WHERE cp.sulphates > (SELECT AVG(sulphates) FROM chemical_properties)
GROUP BY w.quality
ORDER BY w.quality;

-- 3.4 Density by Quality Segment
-- Higher density wines tend to have more residual sugar.
SELECT
    CASE
        WHEN w.quality <= 4 THEN 'Low (<=4)'
        WHEN w.quality <= 6 THEN 'Medium (5-6)'
        ELSE                     'High (>=7)'
    END                             AS quality_segment,
    ROUND(AVG(cp.density), 4)       AS avg_density,
    ROUND(AVG(cp.residual_sugar), 2) AS avg_residual_sugar
FROM wines w
JOIN chemical_properties cp ON w.Id = cp.Id
GROUP BY quality_segment
ORDER BY quality_segment;

-- ========================================================================================
-- 4. SULFUR ANALYSIS
-- ========================================================================================

-- 4.1 Sulfur Overview
-- Summary statistics for sulfur dioxide compounds.
SELECT
    ROUND(AVG(free_sulfur_dioxide), 2)      AS avg_free_so2,
    ROUND(AVG(total_sulfur_dioxide), 2)     AS avg_total_so2,
    ROUND(MIN(free_sulfur_dioxide), 2)      AS min_free_so2,
    ROUND(MAX(free_sulfur_dioxide), 2)      AS max_free_so2,
    ROUND(MIN(total_sulfur_dioxide), 2)     AS min_total_so2,
    ROUND(MAX(total_sulfur_dioxide), 2)     AS max_total_so2
FROM sulfur;

-- 4.2 Sulfur Dioxide by Quality
-- Analyzes how SO2 levels relate to wine quality.
-- Free SO2 prevents microbial growth and oxidation.
SELECT
    w.quality,
    ROUND(AVG(s.free_sulfur_dioxide), 2)    AS avg_free_so2,
    ROUND(AVG(s.total_sulfur_dioxide), 2)   AS avg_total_so2
FROM wines w
JOIN sulfur s ON w.Id = s.Id
GROUP BY w.quality
ORDER BY w.quality;

-- 4.3 SO2 Ratio by Quality Segment
-- Calculates the ratio of free to total SO2 as an indicator
-- of wine preservation effectiveness.
SELECT
    CASE
        WHEN w.quality <= 4 THEN 'Low (<=4)'
        WHEN w.quality <= 6 THEN 'Medium (5-6)'
        ELSE                     'High (>=7)'
    END                                                         AS quality_segment,
    ROUND(AVG(s.free_sulfur_dioxide), 2)                        AS avg_free_so2,
    ROUND(AVG(s.total_sulfur_dioxide), 2)                       AS avg_total_so2,
    ROUND(AVG(s.free_sulfur_dioxide) / 
          AVG(s.total_sulfur_dioxide) * 100, 2)                 AS free_to_total_pct
FROM wines w
JOIN sulfur s ON w.Id = s.Id
GROUP BY quality_segment
ORDER BY quality_segment;

-- ========================================================================================
-- 5. ADVANCED ANALYSIS
-- ========================================================================================

-- 5.1 Full Wine Profile (4-table JOIN)
-- Combines all tables to get a complete profile of each wine.
SELECT
    w.Id,
    w.quality,
    w.alcohol,
    a.fixed_acidity,
    a.volatile_acidity,
    a.citric_acid,
    a.pH,
    cp.residual_sugar,
    cp.chlorides,
    cp.sulphates,
    cp.density,
    s.free_sulfur_dioxide,
    s.total_sulfur_dioxide
FROM wines w
JOIN acidity a           ON w.Id = a.Id
JOIN chemical_properties cp ON w.Id = cp.Id
JOIN sulfur s            ON w.Id = s.Id
ORDER BY w.quality DESC, w.alcohol DESC;

-- 5.2 Quality Ranking by Alcohol within Quality Segment
-- Ranks wines by alcohol content within each quality segment
-- using window functions.
SELECT
    w.Id,
    w.quality,
    w.alcohol,
    CASE
        WHEN w.quality <= 4 THEN 'Low (<=4)'
        WHEN w.quality <= 6 THEN 'Medium (5-6)'
        ELSE                     'High (>=7)'
    END                                                     AS quality_segment,
    RANK() OVER (
        PARTITION BY CASE
            WHEN w.quality <= 4 THEN 'Low'
            WHEN w.quality <= 6 THEN 'Medium'
            ELSE 'High'
        END
        ORDER BY w.alcohol DESC
    )                                                       AS alcohol_rank
FROM wines w
ORDER BY quality_segment, alcohol_rank;

-- 5.3 Wines Above Average in All Key Properties
-- Identifies wines that exceed the average in alcohol, sulphates
-- and citric acid simultaneously, and checks if they score higher quality.
SELECT
    w.Id,
    w.quality,
    w.alcohol,
    cp.sulphates,
    a.citric_acid
FROM wines w
JOIN chemical_properties cp ON w.Id = cp.Id
JOIN acidity a ON w.Id = a.Id
WHERE w.alcohol     > (SELECT AVG(alcohol) FROM wines)
  AND cp.sulphates  > (SELECT AVG(sulphates) FROM chemical_properties)
  AND a.citric_acid > (SELECT AVG(citric_acid) FROM acidity)
ORDER BY w.quality DESC;

-- 5.4 Comprehensive Quality Score Summary
-- Aggregates all key properties by quality score with
-- a complete chemical profile for each quality level.
SELECT
    w.quality,
    COUNT(*)                                    AS total_wines,
    ROUND(AVG(w.alcohol), 2)                    AS avg_alcohol,
    ROUND(AVG(a.volatile_acidity), 2)           AS avg_volatile_acidity,
    ROUND(AVG(a.citric_acid), 2)                AS avg_citric_acid,
    ROUND(AVG(cp.sulphates), 2)                 AS avg_sulphates,
    ROUND(AVG(cp.density), 4)                   AS avg_density,
    ROUND(AVG(s.free_sulfur_dioxide), 2)        AS avg_free_so2,
    ROUND(AVG(s.total_sulfur_dioxide), 2)       AS avg_total_so2
FROM wines w
JOIN acidity a           ON w.Id = a.Id
JOIN chemical_properties cp ON w.Id = cp.Id
JOIN sulfur s            ON w.Id = s.Id
GROUP BY w.quality
ORDER BY w.quality;
