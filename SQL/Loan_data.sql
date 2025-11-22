-- 1 Total loan amount funded 
SELECT SUM(`Funded Amount Inv`) AS Total_Loan_Amount_Funded
FROM `bank analysis`;

-- 2 Total loans 
SELECT COUNT(*) AS Total_Number_of_Loans
FROM `bank analysis`;

-- 3 Total collection 
SELECT SUM(`Total Pymnt`) AS Total_Collection
FROM `bank analysis`;

-- 4 Total interst 
SELECT SUM(`Total Rrec int`) AS Total_Interest
FROM `bank analysis`;

-- 5 Branch-wise performance 
SELECT `Branch Name` AS Branch,
SUM(`Total Pymnt`) AS Total_Collected_Amount
FROM `bank_analysis`.`bank analysis`
GROUP BY `Branch Name`
ORDER BY Total_Collected_Amount DESC;


-- 6 State-wise loan 
SELECT (`State Name`) AS State,
COUNT(`Account ID`) AS Total_Accounts
FROM `bank_analysis`.`bank analysis`
GROUP BY (`State Name`)
ORDER BY Total_Accounts DESC;


-- 7 Religion-wise loan 
SELECT `Religion`,
COUNT(`Account ID`) AS Total_Accounts
FROM `bank_analysis`.`bank analysis`
GROUP BY `Religion`
ORDER BY 'Account ID' DESC;


-- 8 product group wise loan 
SELECT `Purpose Category`,
COUNT(*) AS Total_Loans
FROM `bank_analysis`.`bank analysis`
GROUP BY `Purpose Category`
ORDER BY Total_Loans DESC;

-- 9 Disbursement Trend
SELECT YEAR(STR_TO_DATE(`Disbursement Date`, '%d-%m-%Y')) AS Year,
SUM(`Loan Amount`) AS Total_Disbursed
FROM `bank_analysis`.`bank analysis`
GROUP BY YEAR(STR_TO_DATE(`Disbursement Date`, '%d-%m-%Y'))
ORDER BY Year;


-- 10 grade wise loan
SELECT Grrade AS credit_grade,
SUM(`Loan Amount`) AS total_loan_amount
FROM `bank_analysis`.`bank analysis`
GROUP BY Grrade;


-- 11 default loan count
SELECT COUNT(*) AS default_loan_count
FROM `bank_analysis`.`bank analysis`
WHERE TRIM(LOWER(`Is Default Loan`)) = 'N';


-- 12 deliquent clinet count 
SELECT COUNT(DISTINCT `Client id`) AS delinquent_client_count
FROM `bank_analysis`.`bank analysis`
WHERE TRIM(LOWER(`Is Delinquent Loan`)) = 'n';


-- 13 Delinquent Loan Rate
SELECT (SUM(CASE 
WHEN TRIM(LOWER(`Is Delinquent Loan`)) = 'y' 
THEN 1 ELSE 0 END) * 100.0) 
/ COUNT(*) AS delinquent_loan_rate
FROM `bank_analysis`.`bank analysis`;


-- 14 Default Loan Rate
SELECT (SUM(CASE 
WHEN TRIM(LOWER(`Is Delinquent Loan`)) = 'y' 
THEN 1 ELSE 0 
END) * 100.0) / COUNT(*) AS delinquent_loan_rate
FROM `bank_analysis`.`bank analysis`;

-- 15 Loan Status-Wise Loan
SELECT`Loan Status`,
SUM(`Loan Amount`) AS total_amount
FROM `bank_analysis`.`bank analysis`
GROUP BY `Loan Status`;


-- 16 Age Group-Wise Loan
SELECT CASE
	WHEN TRIM(`Age`) LIKE '%18-25%' THEN '18-25'
	WHEN TRIM(`Age`) LIKE '%26-35%' THEN '26-35'
	WHEN TRIM(`Age`) LIKE '%36-45%' THEN '36-45'
	WHEN TRIM(`Age`) LIKE '%46-55%' THEN '46-55'
	ELSE '56+'
    END AS age_group,
    SUM(`Loan Amount`) AS total_amount
FROM `bank_analysis`.`bank analysis`
GROUP BY age_group
ORDER BY age_group;


-- 17 product No Verified Loans
SELECT `Verification Status`,
SUM(`Loan Amount`) AS total_loan_amount
FROM `bank_analysis`.`bank analysis`
WHERE `Verification Status` = 'Not Verified'
GROUP BY `Verification Status`;