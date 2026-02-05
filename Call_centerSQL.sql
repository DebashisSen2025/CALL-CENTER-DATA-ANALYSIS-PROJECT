-- =====================================
-- CALL CENTER DATA ANALYSIS PROJECT
-- CORRECTED SQL CODE
-- =====================================

-- =====================================================
-- SOLUTION TO YOUR ERROR:
-- The error occurs because MySQL cannot find the CSV file
-- at the path: C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Call_Center.csv
--
-- THREE SOLUTIONS BELOW - CHOOSE ONE:
-- =====================================================

-- =====================================
-- SOLUTION 1: FIX THE FILE PATH (RECOMMENDED)
-- =====================================
-- 1a) First, check where MySQL expects files:
SHOW VARIABLES LIKE 'secure_file_priv';
-- This will show you the exact folder path (e.g., C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/)

-- 1b) Copy your CSV file to that exact folder
--     Make sure the file is named: Call_Center.csv (without __1_)

-- 1c) Then run the LOAD DATA command below:
-- (Uncomment and modify the path based on what SHOW VARIABLES returned)

/*
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Call_Center.csv'
INTO TABLE call_center
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
*/

-- =====================================
-- SOLUTION 2: USE LOCAL FILE (IF SOLUTION 1 FAILS)
-- =====================================
-- If you get permission errors, use LOAD DATA LOCAL INFILE instead:
-- Note: You need to enable local_infile first

/*
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/YourUsername/Downloads/Call_Center__1_.csv'
INTO TABLE call_center
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
*/

-- =====================================
-- SOLUTION 3: IMPORT USING WORKBENCH GUI
-- =====================================
-- If both SQL methods fail, use MySQL Workbench's Table Data Import Wizard:
-- 1. Right-click on 'call_center' table
-- 2. Select "Table Data Import Wizard"
-- 3. Browse to your Call_Center__1_.csv file
-- 4. Follow the wizard steps
-- 5. Click "Next" and "Finish"

-- =====================================
-- COMPLETE SQL SCRIPT STARTS HERE
-- =====================================

-- 1) Check secure file path
SHOW VARIABLES LIKE 'secure_file_priv';

-- 2) CREATE DATABASE
CREATE DATABASE IF NOT EXISTS call_centerdata;
USE call_centerdata;

-- 3) DROP TABLE IF EXISTS
DROP TABLE IF EXISTS call_center;

-- 4) CREATE TABLE
CREATE TABLE call_center (
    id VARCHAR(100),
    customer_name VARCHAR(100),
    sentiment VARCHAR(50),
    csat_score VARCHAR(20),
    call_timestamp VARCHAR(50),
    reason VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    channel VARCHAR(50),
    response_time VARCHAR(50),
    `call duration in minutes` INT,
    call_center VARCHAR(50)
);

-- 5) LOAD CSV FILE INTO TABLE
-- *** IMPORTANT: CHOOSE ONE OF THE SOLUTIONS ABOVE ***
-- After loading, verify with:
SELECT COUNT(*) AS total_rows FROM call_center;
SELECT * FROM call_center LIMIT 10;

-- If you see rows, continue with the rest of the script below

-- =====================================
-- 6) DATA CLEANING
-- =====================================
SET SQL_SAFE_UPDATES = 0;

-- Add new datetime column
ALTER TABLE call_center ADD COLUMN call_datetime DATETIME;

-- Convert call_timestamp to datetime
UPDATE call_center
SET call_datetime = STR_TO_DATE(call_timestamp, '%m/%d/%Y');

-- Replace blank CSAT with NULL
UPDATE call_center
SET csat_score = NULL
WHERE csat_score = '' OR csat_score IS NULL OR csat_score = '0';

-- Add numeric CSAT column
ALTER TABLE call_center ADD COLUMN csat_numeric INT;

-- Convert csat_score to numeric
UPDATE call_center
SET csat_numeric = CAST(csat_score AS UNSIGNED);

-- Remove 0 values if any
UPDATE call_center
SET csat_numeric = NULL
WHERE csat_numeric = 0;

SET SQL_SAFE_UPDATES = 1;

-- =====================================
-- 7) VERIFY DATA LOADED
-- =====================================
SELECT COUNT(*) AS num_rows FROM call_center;

SELECT COUNT(*) AS num_columns
FROM information_schema.columns
WHERE table_schema = 'call_centerdata'
AND table_name = 'call_center';

-- =====================================
-- 8) DISTINCT VALUES CHECK
-- =====================================
SELECT DISTINCT sentiment FROM call_center;
SELECT DISTINCT city FROM call_center;
SELECT DISTINCT state FROM call_center;
SELECT DISTINCT channel FROM call_center;
SELECT DISTINCT reason FROM call_center;
SELECT DISTINCT response_time FROM call_center;
SELECT DISTINCT call_center FROM call_center;

-- =====================================
-- 9) CITY WISE CALL COUNT + PERCENTAGE
-- =====================================
SELECT 
    city,
    COUNT(*) AS total_calls,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM call_center), 2) AS percentage
FROM call_center
GROUP BY city
ORDER BY total_calls DESC;

-- =====================================
-- 10) CALLS BY DAY OF WEEK
-- =====================================
SELECT 
    DAYNAME(call_datetime) AS day_of_week,
    COUNT(*) AS call_count
FROM call_center
GROUP BY day_of_week
ORDER BY call_count DESC;

-- =====================================
-- 11) CALLS BY DATE
-- =====================================
SELECT 
    DATE(call_datetime) AS call_date,
    COUNT(*) AS call_count
FROM call_center
GROUP BY call_date
ORDER BY call_date;

-- =====================================
-- 12) CALL DURATION SUMMARY
-- =====================================
SELECT
    MIN(`call duration in minutes`) AS min_duration,
    MAX(`call duration in minutes`) AS max_duration,
    ROUND(AVG(`call duration in minutes`), 2) AS avg_duration
FROM call_center;

-- =====================================
-- 13) CSAT SUMMARY
-- =====================================
SELECT
    MIN(csat_numeric) AS min_csat,
    MAX(csat_numeric) AS max_csat,
    ROUND(AVG(csat_numeric), 2) AS avg_csat
FROM call_center
WHERE csat_numeric IS NOT NULL;

-- =====================================
-- 14) CALL CENTER & RESPONSE TIME ANALYSIS
-- =====================================
SELECT 
    call_center,
    response_time,
    COUNT(*) AS total_calls
FROM call_center
GROUP BY call_center, response_time
ORDER BY call_center, total_calls DESC;

-- =====================================
-- 15) MAX CALL DURATION PER DAY
-- =====================================
SELECT
    DATE(call_datetime) AS call_day,
    MAX(`call duration in minutes`) AS max_call_duration
FROM call_center
GROUP BY call_day
ORDER BY call_day;

-- =====================================
-- 16) AVG CALL DURATION BY SENTIMENT
-- =====================================
SELECT
    sentiment,
    ROUND(AVG(`call duration in minutes`), 2) AS avg_call_duration
FROM call_center
GROUP BY sentiment
ORDER BY avg_call_duration DESC;

-- =====================================
-- 17) AVG CSAT BY SENTIMENT
-- =====================================
SELECT
    sentiment,
    ROUND(AVG(csat_numeric), 2) AS avg_csat
FROM call_center
WHERE csat_numeric IS NOT NULL
GROUP BY sentiment
ORDER BY avg_csat DESC;

-- =====================================
-- 18) TOP 10 LONGEST CALLS
-- =====================================
SELECT 
    id,
    customer_name,
    city,
    sentiment,
    `call duration in minutes`,
    call_datetime
FROM call_center
ORDER BY `call duration in minutes` DESC
LIMIT 10;

-- =====================================
-- 19) CHANNEL DISTRIBUTION
-- =====================================
SELECT
    channel,
    COUNT(*) AS total_calls,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM call_center), 2) AS percentage
FROM call_center
GROUP BY channel
ORDER BY total_calls DESC;

-- =====================================
-- 20) REASON DISTRIBUTION
-- =====================================
SELECT
    reason,
    COUNT(*) AS total_calls
FROM call_center
GROUP BY reason
ORDER BY total_calls DESC;

-- =====================================
-- 21) SENTIMENT DISTRIBUTION
-- =====================================
SELECT
    sentiment,
    COUNT(*) AS total_calls,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM call_center), 2) AS percentage
FROM call_center
GROUP BY sentiment
ORDER BY total_calls DESC;

-- =====================================
-- 22) STATE WISE ANALYSIS
-- =====================================
SELECT
    state,
    COUNT(*) AS total_calls,
    ROUND(AVG(`call duration in minutes`), 2) AS avg_duration,
    ROUND(AVG(csat_numeric), 2) AS avg_csat
FROM call_center
GROUP BY state
ORDER BY total_calls DESC;

-- =====================================
-- 23) RESPONSE TIME ANALYSIS
-- =====================================
SELECT
    response_time,
    COUNT(*) AS total_calls,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM call_center), 2) AS percentage,
    ROUND(AVG(csat_numeric), 2) AS avg_csat
FROM call_center
GROUP BY response_time
ORDER BY total_calls DESC;

-- =====================================
-- END OF SQL SCRIPT
-- =====================================