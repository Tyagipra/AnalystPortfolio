Select * from rfm_data


--Calculate how recently each customer made a purchase--
SELECT 
    CustomerID, 
    MAX(PurchaseDate) AS Recency
FROM 
    rfm_data
GROUP BY 
    CustomerID

--Calculate how often each customer makes a purchase--

Select CustomerID,
Count(*) as Frequency 
from rfm_data
group by CustomerID

---Calculate the total money spent by each customer---

Select CustomerID,
Round(Sum(TransactionAmount),2) as Monetary
from rfm_data
group by CustomerID


--Giving Scores to customers--
With CombinedRFMTable As
(Select R.CustomerID, R.Recency, F.Frequency, M.Monetary
from (Select CustomerID,MAX(PurchaseDate) As Recency
      from rfm_data
      group by CustomerID) R
JOIN (Select CustomerID, COUNT(*) As Frequency
      from rfm_data
      group by CustomerID) F ON R.CustomerID = F.CustomerID
JOIN (Select CustomerID, Round(SUM(TransactionAmount),2) As Monetary
      from rfm_data
      group by CustomerID) M ON R.CustomerID = M.CustomerID)
Select CustomerID,
       CASE
           WHEN DATEPART(day,Recency) <= 30 THEN 'High'
           WHEN DATEPART(day,Recency) BETWEEN 31 AND 60 THEN 'Medium'
           ELSE 'Low'
       END AS RecencyScore,
       CASE
           WHEN Frequency >= 10 THEN 'High'
           WHEN Frequency BETWEEN 5 AND 9 THEN 'Medium'
           ELSE 'Low'
       END AS FrequencyScore,
       CASE
           WHEN Monetary >= 500 THEN 'High'
           WHEN Monetary BETWEEN 200 AND 499 THEN 'Medium'
           ELSE 'Low'
       END AS MonetaryScore
FROM CombinedRFMTable




