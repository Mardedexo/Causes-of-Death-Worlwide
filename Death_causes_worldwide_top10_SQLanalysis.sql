-- Use the existing database
USE `CausesOfDeathWorldwide`;

-- Top 10 causes of death per country
-- Using variables to rank rows per country

-- Initialize variables
SET @current_country := NULL;
SET @row_num := 0;

-- Select top 10 causes per country from 'test' table
SELECT
    DIM_COUNTRY_CODE,
    DIM_GHECAUSE_TITLE,
    VAL_DTHS_RATE100K_NUMERIC
FROM (
    SELECT
        DIM_COUNTRY_CODE,
        DIM_GHECAUSE_TITLE,
        VAL_DTHS_RATE100K_NUMERIC,
        @row_num := IF(@current_country = DIM_COUNTRY_CODE,
                       @row_num + 1,
                       1) AS rn,
        @current_country := DIM_COUNTRY_CODE AS dummy
    FROM test
    ORDER BY DIM_COUNTRY_CODE,
             VAL_DTHS_RATE100K_NUMERIC DESC
) AS ranked
WHERE rn <= 10;

-- Replace country codes with full country names
-- Join top 10 table with codelist table

SELECT 
    t.DIM_COUNTRY_CODE AS country_code,
    c.Country AS country_name,
    t.DIM_GHECAUSE_TITLE,
    t.VAL_DTHS_RATE100K_NUMERIC
FROM Top10ByCountry_all t
JOIN codelist c
ON t.DIM_COUNTRY_CODE = c.Code;