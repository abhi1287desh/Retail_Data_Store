CREATE OR ALTER VIEW v_PerformanceAnalytics AS
SELECT 
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    LineTotal,
    CustomerID,
    Country,
    IsActive,
    MaterialType,
    -- Group into basic transaction brackets for deep visual slicing
    CASE 
        WHEN LineTotal < 15 THEN 'Low Value (<$15)'
        WHEN LineTotal BETWEEN 15 AND 75 THEN 'Mid Value ($15-$75)'
        ELSE 'High Value (>$75)'
    END AS TransactionBracket
FROM Cust_Payment_Details;
GO

-- 2. Audit/Validation Query to verify pipeline match totals
SELECT 
    Country,
    COUNT(DISTINCT Invoice) AS TotalInvoices,
    SUM(Quantity) AS TotalUnitsSold,
    ROUND(SUM(LineTotal), 2) AS GrossRevenue
FROM v_PerformanceAnalytics
GROUP BY Country
ORDER BY GrossRevenue DESC;