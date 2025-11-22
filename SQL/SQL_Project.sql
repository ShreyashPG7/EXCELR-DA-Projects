CREATE DATABASE bank_analytics;
USE bank_analytics; 

CREATE TABLE debit_credit (
  Customer_ID VARCHAR(100),
  Customer_Name VARCHAR(255),
  Account_Number VARCHAR(50),
  Transaction_Date DATE,
  Transaction_Type VARCHAR(20),
  Amount DECIMAL(18,2),
  Balance DECIMAL(18,2),
  Description VARCHAR(255),
  Branch VARCHAR(100),
  Transaction_Method VARCHAR(50),
  Currency VARCHAR(10),
  Bank_Name VARCHAR(100)
);

CREATE TABLE banking_data (
  State_Abbr VARCHAR(10),
  Account_ID VARCHAR(50),
  Age_Group VARCHAR(20),
  BH_Name VARCHAR(100),
  Bank_Name VARCHAR(100),
  Branch_Name VARCHAR(100),
  Caste VARCHAR(50),
  Center_Id INT,
  City VARCHAR(100),
  Client_Id INT,
  Client_Name VARCHAR(100),
  Close_Client VARCHAR(10),
  Closed_Date VARCHAR(50),
  Credit_Officer_Name VARCHAR(100),
  Date_of_Birth VARCHAR(50),
  Disb_By VARCHAR(100),
  Disbursement_Date VARCHAR(50),
  Disbursement_Year VARCHAR(20),
  Gender VARCHAR(20),
  Home_Ownership VARCHAR(50),
  Loan_Status VARCHAR(50),
  Loan_Transferdate VARCHAR(20),
  NextMeetingDate VARCHAR(50),
  Product_Code VARCHAR(50),
  Grade VARCHAR(10),
  Sub_Grade VARCHAR(10),
  Product_Id VARCHAR(50),
  Purpose_Category VARCHAR(100),
  Region_Name VARCHAR(100),
  Religion VARCHAR(50),
  Verification_Status VARCHAR(50),
  State_Name VARCHAR(100),
  Transfer_Logic VARCHAR(10),
  Is_Delinquent_Loan VARCHAR(5),
  Is_Default_Loan VARCHAR(5),
  Age_T INT,
  Delinq_2_Yrs INT,
  Application_Type VARCHAR(50),
  Loan_Amount DECIMAL(10,2),
  Funded_Amount DECIMAL(10,2),
  Funded_Amount_Inv DECIMAL(10,2),
  Term VARCHAR(20),
  Int_Rate DECIMAL(10,4),
  Total_Pymnt DECIMAL(12,2),
  Total_Pymnt_Inv DECIMAL(12,2),
  Total_Rec_Prncp DECIMAL(12,2),
  Total_Fees DECIMAL(12,2),
  Total_Rec_Int DECIMAL(12,2),
  Total_Rec_Late_Fee DECIMAL(12,2),
  Recoveries DECIMAL(12,2),
  Collection_Recovery_Fee DECIMAL(12,2)
);

DROP TABLE IF EXISTS banking_data;

CREATE TABLE banking_data (
  State_Abbr VARCHAR(10),
  Account_ID VARCHAR(50),
  Age_Group VARCHAR(20),
  BH_Name VARCHAR(100),
  Bank_Name VARCHAR(100),
  Branch_Name VARCHAR(100),
  Caste VARCHAR(50),
  Center_Id INT,
  City VARCHAR(100),
  Client_Id INT,
  Client_Name VARCHAR(100),
  Close_Client VARCHAR(10),
  Closed_Date VARCHAR(50),
  Credit_Officer_Name VARCHAR(100),
  Date_of_Birth VARCHAR(50),
  Disb_By VARCHAR(100),
  Disbursement_Date VARCHAR(50),
  Disbursement_Year VARCHAR(20),
  Gender VARCHAR(20),
  Home_Ownership VARCHAR(50),
  Loan_Status VARCHAR(50),
  Loan_Transferdate VARCHAR(20),
  NextMeetingDate VARCHAR(50),
  Product_Code VARCHAR(50),
  Grade VARCHAR(10),
  Sub_Grade VARCHAR(10),
  Product_Id VARCHAR(50),
  Purpose_Category VARCHAR(100),
  Region_Name VARCHAR(100),
  Religion VARCHAR(50),
  Verification_Status VARCHAR(50),
  State_Name VARCHAR(100),
  Transfer_Logic VARCHAR(10),
  Is_Delinquent_Loan VARCHAR(5),
  Is_Default_Loan VARCHAR(5),
  Age_T INT,
  Delinq_2_Yrs INT,
  Application_Type VARCHAR(50),
  Loan_Amount DECIMAL(10,2),
  Funded_Amount DECIMAL(10,2),
  Funded_Amount_Inv DECIMAL(10,2),
  Term VARCHAR(20),
  Int_Rate DECIMAL(10,4),
  Total_Pymnt DECIMAL(12,2),
  Total_Pymnt_Inv DECIMAL(12,2),
  Total_Rec_Prncp DECIMAL(12,2),
  Total_Fees DECIMAL(12,2),
  Total_Rec_Int DECIMAL(12,2),
  Total_Rec_Late_Fee DECIMAL(12,2),
  Recoveries DECIMAL(12,2),
  Collection_Recovery_Fee DECIMAL(12,2)
);

DROP TABLE IF EXISTS loan_data;
ALTER TABLE loan_data MODIFY COLUMN `Bank Name` VARCHAR(255);

SELECT * FROM debit_credit LIMIT 10;
SELECT * FROM loan_data LIMIT 10;

CREATE TABLE debit_credit_backup AS SELECT * FROM debit_credit;
DESCRIBE debit_credit;

UPDATE debit_credit
SET
  Customer_ID = TRIM(Customer_ID),
  Customer_Name = TRIM(Customer_Name),
  Account_Number = TRIM(Account_Number),
  Transaction_Type = TRIM(Transaction_Type),
  Description = TRIM(Description),
  Branch = TRIM(Branch),
  Transaction_Method = TRIM(Transaction_Method),
  Currency = TRIM(Currency),
  Bank_Name = TRIM(Bank_Name);

SELECT 
  SUM(Customer_ID IS NULL OR Customer_ID = '') AS Missing_CustomerID,
  SUM(Customer_Name IS NULL OR Customer_Name = '') AS Missing_CustomerName,
  SUM(Account_Number IS NULL OR Account_Number = '') AS Missing_AccountNumber,
  SUM(Transaction_Type IS NULL OR Transaction_Type = '') AS Missing_Type,
  SUM(Amount IS NULL) AS Missing_Amount,
  SUM(Transaction_Date IS NULL) AS Missing_Date
FROM debit_credit;

SELECT DISTINCT Transaction_Type FROM debit_credit;

SELECT Customer_ID, Transaction_Date, Amount, Description, COUNT(*) AS cnt
FROM debit_credit
GROUP BY Customer_ID, Transaction_Date, Amount, Description
HAVING cnt > 1;

ALTER TABLE debit_credit
MODIFY COLUMN Transaction_Date DATE;

SELECT COUNT(*) AS Total_Rows,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers,
       MIN(Transaction_Date) AS Earliest_Date,
       MAX(Transaction_Date) AS Latest_Date
FROM debit_credit;

ALTER TABLE debit_credit
ADD COLUMN Transaction_Month INT,
ADD COLUMN Transaction_Year INT;

UPDATE debit_credit
SET Transaction_Month = MONTH(Transaction_Date),
    Transaction_Year = YEAR(Transaction_Date);
    
ALTER TABLE debit_credit
ADD COLUMN Transaction_Month_Name VARCHAR(20);
UPDATE debit_credit
SET Transaction_Month_Name = MONTHNAME(Transaction_Date);

ALTER TABLE debit_credit
DROP COLUMN Transaction_Month;

CREATE TABLE debit_credit_final AS
SELECT
    Customer_ID,
    Customer_Name,
    Account_Number,
    Transaction_Date,
    Transaction_Month_Name,
    Transaction_Year,
    Transaction_Type,
    Amount,
    Description
FROM debit_credit;


-- For Loan_data 

ALTER TABLE loan_data RENAME COLUMN `ï»¿ State Abbr` TO State_Abbr;

DELETE FROM loan_data
WHERE `Account ID` IS NULL 
   OR `Client id` IS NULL 
   OR `Loan Amount` IS NULL 
   OR `Disbursement Date` IS NULL;
   
DELETE FROM loan_data
WHERE (`Account ID`, `Client id`, `Loan Amount`, `Disbursement Date`) IN (
  SELECT `Account ID`, `Client id`, `Loan Amount`, `Disbursement Date`
  FROM (
    SELECT `Account ID`, `Client id`, `Loan Amount`, `Disbursement Date`,
           ROW_NUMBER() OVER (PARTITION BY `Account ID`, `Client id`, `Loan Amount`, `Disbursement Date` ORDER BY `Account ID`) AS rn
    FROM loan_data
  ) AS temp
  WHERE rn > 1
);

UPDATE loan_data
SET `Disbursement Date` = STR_TO_DATE(`Disbursement Date`, '%d-%m-%Y')
WHERE `Disbursement Date` IS NOT NULL 
  AND `Disbursement Date` != '';
  
ALTER TABLE loan_data ADD COLUMN Disbursement_Year INT;
ALTER TABLE loan_data ADD COLUMN Disbursement_Month_Name VARCHAR(20);

SELECT DISTINCT `Disbursement Date`
FROM loan_data
LIMIT 50;

ALTER TABLE loan_data
ADD COLUMN disbursement_date_dt DATE;

UPDATE loan_data
SET disbursement_date_dt = COALESCE(
    STR_TO_DATE(`Disbursement Date`, '%Y-%m-%d'),  -- 2023-03-15
    STR_TO_DATE(`Disbursement Date`, '%d-%m-%Y'),  -- 15-03-2023 or 15/03/2023 if separators are '-'
    STR_TO_DATE(`Disbursement Date`, '%d/%m/%Y'),  -- 15/03/2023
    STR_TO_DATE(`Disbursement Date`, '%m/%d/%Y'),  -- 03/15/2023
    STR_TO_DATE(`Disbursement Date`, '%d %b %Y'),  -- 15 Mar 2023
    STR_TO_DATE(`Disbursement Date`, '%d %M %Y')   -- 15 March 2023
)
WHERE `Disbursement Date` IS NOT NULL AND TRIM(`Disbursement Date`) <> '';

SELECT `Disbursement Date`
FROM loan_data
WHERE disbursement_date_dt IS NULL
  AND `Disbursement Date` IS NOT NULL
  AND TRIM(`Disbursement Date`) <> ''
LIMIT 100;

ALTER TABLE loan_data
ADD COLUMN disbursement_year INT,
ADD COLUMN disbursement_month_name VARCHAR(20);

UPDATE loan_data
SET disbursement_year = YEAR(disbursement_date_dt),
    disbursement_month_name = MONTHNAME(disbursement_date_dt)
WHERE disbursement_date_dt IS NOT NULL;

SELECT `Disbursement Date`, disbursement_date_dt, disbursement_year, disbursement_month_name
FROM loan_data
ORDER BY disbursement_date_dt DESC
LIMIT 20;

ALTER TABLE loan_data 
RENAME COLUMN `Account ID` TO Account_ID,
RENAME COLUMN `Client id` TO Client_ID,
RENAME COLUMN `Loan Amount` TO Loan_Amount,
RENAME COLUMN `Funded Amount` TO Funded_Amount,
RENAME COLUMN `Branch Name` TO Branch_Name,
RENAME COLUMN `Bank Name` TO Bank_Name,
RENAME COLUMN `Disbursement Date` TO Disbursement_Date_Text;

-- remove '%' from Interest Rate values and convert to numeric
UPDATE loan_data
SET `Int Rate` = REPLACE(`Int Rate`, '%', '')
WHERE `Int Rate` IS NOT NULL AND TRIM(`Int Rate`) <> '';

-- now convert the column type to DOUBLE
ALTER TABLE loan_data MODIFY COLUMN `Int Rate` DOUBLE;

UPDATE loan_data
SET 
  `Loan Status` = TRIM(`Loan Status`),
  `Branch Name` = TRIM(`Branch Name`),
  `Bank Name` = TRIM(`Bank Name`);
  
SHOW COLUMNS FROM loan_data;

ALTER TABLE loan_data
RENAME COLUMN `BH Name` TO BH_Name,
RENAME COLUMN `Client Name` TO Client_Name,
RENAME COLUMN `Close Client` TO Close_Client,
RENAME COLUMN `Closed Date` TO Closed_Date,
RENAME COLUMN `Credif Officer Name` TO Credit_Officer_Name,
RENAME COLUMN `Dateof Birth` TO Date_of_Birth,
RENAME COLUMN `Disb By` TO Disb_By,
RENAME COLUMN `Disbursement Date (Years)` TO Disbursement_Date_Years,
RENAME COLUMN `Gender ID` TO Gender_ID,
RENAME COLUMN `Home Ownership` TO Home_Ownership,
RENAME COLUMN `Loan Status` TO Loan_Status,
RENAME COLUMN `Loan Transferdate` TO Loan_Transfer_Date,
RENAME COLUMN `NextMeetingDate` TO Next_Meeting_Date,
RENAME COLUMN `Product Code` TO Product_Code,
RENAME COLUMN `Grrade` TO Grade,
RENAME COLUMN `Sub Grade` TO Sub_Grade,
RENAME COLUMN `Product Id` TO Product_ID,
RENAME COLUMN `MyUnknownColumn` TO Unknown_Column,
RENAME COLUMN `Purpose Category` TO Purpose_Category,
RENAME COLUMN `Region Name` TO Region_Name,
RENAME COLUMN `State Name` TO State_Name,
RENAME COLUMN `Tranfer Logic` TO Transfer_Logic,
RENAME COLUMN `Is Delinquent Loan` TO Is_Delinquent_Loan,
RENAME COLUMN `Is Default Loan` TO Is_Default_Loan,
RENAME COLUMN `Delinq 2 Yrs` TO Delinq_2_Yrs,
RENAME COLUMN `Funded Amount Inv` TO Funded_Amount_Inv,
RENAME COLUMN `Int Rate` TO Int_Rate,
RENAME COLUMN `Total Pymnt` TO Total_Pymnt,
RENAME COLUMN `Total Pymnt inv` TO Total_Pymnt_Inv,
RENAME COLUMN `Total Rec Prncp` TO Total_Rec_Prncp,
RENAME COLUMN `Total Fees` TO Total_Fees,
RENAME COLUMN `Total Rrec int` TO Total_Rec_Int,
RENAME COLUMN `Total Rec Late fee` TO Total_Rec_Late_Fee,
RENAME COLUMN `Collection Recovery fee` TO Collection_Recovery_Fee;

SELECT DISTINCT `Is_Default_Loan` FROM loan_data;
SELECT DISTINCT `Is Delinquent Loan` FROM loan_data;




