SELECT COUNT(*) AS Total_Transactions
FROM debit_credit_final;


-- 1.Total Credit Amount
SELECT SUM(Amount) AS Total_Credit
FROM debit_credit_final
WHERE Transaction_Type = 'Credit';


-- 2.Total Debit Amount
SELECT SUM(ABS(Amount)) AS Total_Debit
FROM debit_credit_final
WHERE Transaction_Type = 'Debit';


-- 3️.Credit to Debit Ratio
SELECT 
    (SUM(CASE WHEN Transaction_Type = 'Credit' THEN Amount ELSE 0 END) /
     SUM(CASE WHEN Transaction_Type = 'Debit' THEN Amount ELSE 0 END)) AS Credit_to_Debit_Ratio
FROM debit_credit;


-- 4️.Net Transaction Amount
SELECT 
  (SUM(CASE WHEN Transaction_Type = 'Credit' THEN Amount ELSE 0 END)
 - SUM(CASE WHEN Transaction_Type = 'Debit' THEN ABS(Amount) ELSE 0 END)) AS Net_Balance
FROM debit_credit_final;


-- 5️.Account Activity Ratio
SELECT 
    Customer_ID,
    COUNT(*) / AVG(Balance) AS Account_Activity_Ratio
FROM debit_credit
GROUP BY Customer_ID;


-- 6️.Transactions per Day, Week, and Month
-- Transactions per Day
SELECT Transaction_Date, COUNT(*) AS Transactions_Per_Day
FROM debit_credit
GROUP BY Transaction_Date
ORDER BY Transaction_Date;

-- Transactions per Week
SELECT
    ROW_NUMBER() OVER (ORDER BY MIN(Transaction_Date)) AS Week_Index,
    COUNT(*) AS Transactions_Per_Week
FROM debit_credit
GROUP BY YEARWEEK(Transaction_Date, 1)
ORDER BY Week_Index;

-- Transactions per Month 
SELECT 
    YEAR(Transaction_Date) AS Transaction_Year,
    MONTH(Transaction_Date) AS Transaction_Month_Number,
    MONTHNAME(Transaction_Date) AS Transaction_Month_Name,
    COUNT(*) AS Transactions_Per_Month
FROM debit_credit
GROUP BY 
    YEAR(Transaction_Date),
    MONTH(Transaction_Date),
    MONTHNAME(Transaction_Date)
ORDER BY 
    YEAR(Transaction_Date),
    MONTH(Transaction_Date);
    

-- 7️.Total Transaction Amount by Branch
SELECT Branch, SUM(Amount) AS Total_Transaction_Amount
FROM debit_credit
GROUP BY Branch
ORDER BY Total_Transaction_Amount DESC;


-- 8️.Transaction Volume by Bank
SELECT Bank_Name, SUM(Amount) AS Total_Transaction_Volume
FROM debit_credit
GROUP BY Bank_Name
ORDER BY Total_Transaction_Volume DESC;


-- 9️.Transaction Method Distribution
SELECT Transaction_Method, COUNT(*) AS Transaction_Count,
       ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM debit_credit), 2) AS Percentage_Share
FROM debit_credit
GROUP BY Transaction_Method
ORDER BY Transaction_Count DESC;


-- 10. Branch Transaction Growth (Month-over-Month)
SELECT 
    Branch,
    Transaction_Year,
    Transaction_Month_Name,
    SUM(Amount) AS Total_Amount,
    ROUND(
        (SUM(Amount) - LAG(SUM(Amount)) OVER (PARTITION BY Branch ORDER BY Transaction_Year, MONTH(STR_TO_DATE(Transaction_Month_Name, '%M'))))
        / LAG(SUM(Amount)) OVER (PARTITION BY Branch ORDER BY Transaction_Year, MONTH(STR_TO_DATE(Transaction_Month_Name, '%M'))) * 100, 
    2) AS Growth_Percentage
FROM debit_credit
GROUP BY Branch, Transaction_Year, Transaction_Month_Name
ORDER BY Branch, Transaction_Year, MONTH(STR_TO_DATE(Transaction_Month_Name, '%M'));


-- 11.High-Risk Transaction Flag
SELECT *,
       CASE 
           WHEN Amount > 4500 THEN 'High Risk'
           ELSE 'Normal'
       END AS Risk_Flag
FROM debit_credit;


-- 12.Suspicious Transaction Frequency
SELECT 
    Account_Number,
    COUNT(*) AS Suspicious_Transaction_Count
FROM (
    SELECT Account_Number
    FROM debit_credit
    WHERE Amount > 4500  -- same threshold as above
) AS suspicious
GROUP BY Account_Number
ORDER BY Suspicious_Transaction_Count DESC;


