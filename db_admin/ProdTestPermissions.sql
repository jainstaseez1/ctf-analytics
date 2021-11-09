-- Use this file to run an end to end test

------------------
-- Replace <USERNAME> with your current user
------------------

-- USE ROLE ACCOUNTADMIN;

-- GRANT ROLE ROLE_INGEST TO USER <USERNAME>;
-- GRANT ROLE ROLE_TRANSFORM TO USER <USERNAME>;
-- GRANT ROLE ROLE_REPORT TO USER <USERNAME>;


------------------
-- TEST LOAD
------------------
-- By default, all DE users have the DE role which means we can do sandbox queries
-- USE ROLE prod_db_sndbx_rwx_rl; 
USE WAREHOUSE PROD_ADHOC_WH;
CREATE OR REPLACE SCHEMA prod_sbx_raw.SOURCE_NAME;

CREATE OR REPLACE TABLE prod_sbx_raw.SOURCE_NAME.MYTABLE (AMOUNT NUMBER);

INSERT INTO MYTABLE VALUES(1);

SELECT * FROM MYTABLE;


------------------
-- TEST TRANSFORM
------------------
USE ROLE prod_db_trf_rwx_rl; 
USE WAREHOUSE PROD_ADHOC_WH;
CREATE OR REPLACE SCHEMA prod_sbx_clean.BUSINESS;

CREATE OR REPLACE TABLE prod_sbx_clean.BUSINESS.MATERIALISED_TABLE AS (SELECT AMOUNT*2.5 AS SALES_AMOUNT FROM RAW.SOURCE_NAME.MYTABLE);
CREATE OR REPLACE VIEW prod_sbx_clean.BUSINESS.BUSINESS_VIEW AS (SELECT * FROM MATERIALISED_TABLE);

SELECT * FROM BUSINESS_VIEW;


------------------
-- TEST REPORT
------------------
USE ROLE prod_usr_ba_rl; 
USE WAREHOUSE PROD_ADHOC_WH;
USE SCHEMA prod_usr_ba_rl.BUSINESS;

SELECT * FROM MATERIALISED_TABLE;
SELECT * FROM BUSINESS_VIEW;

