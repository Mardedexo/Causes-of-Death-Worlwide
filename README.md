# Causes-of-Death-Worlwide (Year 2021)
Analysis of the top ten causes of death worldwide
Data downloaded from https://data.who.int/countries/ (the file containing all the information can be downloaded from any country) as CSV file.
Correlation of country codes and country name exported as CSV file from https://apps.who.int/gho/data/node.searo-metadata.COUNTRY?lang=en 
Data process and cleaning performed in Excel using Pivot Tables
Data process and cleaning performed with SQL, as
CREATE DATABASE CausesOfDeathWorldwide

Import file after saved as .CSV to MySQL Workbench

SET @current_country := NULL;
SET @row_num := 0;

SELECT
    DIM_COUNTRY_CODE,
    DIM_GHECAUSE_TITLE,
    VAL_DTHS_RATE100K_NUMERIC
FROM (
    SELECT
        DIM_COUNTRY_CODE,
        DIM_GHECAUSE_TITLE,
        VAL_DTHS_RATE100K_NUMERIC,
        @row_num :=
            IF(@current_country = DIM_COUNTRY_CODE,
               @row_num + 1,
               1)                                  AS rn,
        @current_country := DIM_COUNTRY_CODE       AS dummy
    FROM test
    ORDER BY DIM_COUNTRY_CODE,
             VAL_DTHS_RATE100K_NUMERIC DESC
) AS ranked
WHERE rn <= 10;

To export those results back to a file:

NEXT

Changing country codes by full name of the country.

SELECT 
    t.DIM_COUNTRY_CODE AS country_code,
    c.country AS country_name,
    t.DIM_GHECAUSE_TITLE,
    t.VAL_DTHS_RATE100K_NUMERIC
FROM 
    Top10ByCountry_all t
JOIN 
    codelist c
ON 
    t.DIM_COUNTRY_CODE = c.code;
