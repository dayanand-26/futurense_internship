use healthcare;

#PS_16
WITH AllyPrescrip8ons AS (
 SELECT
 pr.prescrip8onID,
 SUM(c.quan8ty) AS totalQuan8ty
 FROM
 Pharmacy ph
 JOIN Prescrip8on pr ON ph.pharmacyID = pr.pharmacyID
 JOIN Contain c ON pr.prescrip8onID = c.prescrip8onID
 WHERE
 ph.pharmacyName = 'Ally Scripts'
 GROUP BY
 pr.prescrip8onID
)
SELECT
 prescrip8onID,
 totalQuan8ty,
 CASE
 WHEN totalQuan8ty < 20 THEN 'Low Quan8ty'
 WHEN totalQuan8ty BETWEEN 20 AND 49 THEN 'Medium Quan8ty'
 ELSE 'High Quan8ty'
 END AS Tag
FROM
 AllyPrescrip8ons;
 
 
 #PS_17
 WITH SpotRx AS (
 SELECT
 pharmacyID
 FROM
 Pharmacy
 WHERE
 pharmacyName = 'Spot Rx'
)
SELECT
 k.pharmacyID,
 k.medicineID,
 k.quan8ty,
 k.discount,
 CASE
 WHEN k.quan8ty < 1000 AND k.discount >= 30 THEN 'Low Quan8ty with High Discount'
 WHEN k.quan8ty > 7500 AND k.discount = 0 THEN 'High Quan8ty with No Discount'
 END AS Tag
FROM
 Keep k
JOIN
 SpotRx sr ON k.pharmacyID = sr.pharmacyID
WHERE
 (k.quan8ty < 1000 AND k.discount >= 30) OR
 (k.quan8ty > 7500 AND k.discount = 0);
 
 
 #PS_18
 WITH AvgPrice AS (
 SELECT AVG(maxPrice) AS avgMaxPrice
 FROM Medicine
),
CategorizedMedicines AS (
 SELECT
 m.medicineID,
 m.productName,
 m.maxPrice,
 CASE
 WHEN m.maxPrice < 0.5 * ap.avgMaxPrice THEN 'Affordable'
 WHEN m.maxPrice > 2 * ap.avgMaxPrice THEN 'Costly'
 END AS PriceCategory
 FROM
 Medicine m
 CROSS JOIN AvgPrice ap
 WHERE
 m.hospitalExclusive = 'Y' AND
 (m.maxPrice < 0.5 * ap.avgMaxPrice OR m.maxPrice > 2 * ap.avgMaxPrice)
)
SELECT
 medicineID,
 productName,
 maxPrice,
 PriceCategory
FROM
 CategorizedMedicines;
 
 
 #PS_19
 WITH AvgPrice AS (
 SELECT AVG(maxPrice) AS avgMaxPrice
 FROM Medicine
),
CategorizedMedicines AS (
 SELECT
 m.medicineID,
 m.productName,
 m.maxPrice,
 CASE
 WHEN m.maxPrice < 0.5 * ap.avgMaxPrice THEN 'Affordable'
 WHEN m.maxPrice > 2 * ap.avgMaxPrice THEN 'Costly'
 END AS PriceCategory,
 ROW_NUMBER() OVER (PARTITION BY CASE
 WHEN m.maxPrice < 0.5 * ap.avgMaxPrice THEN 'Affordable'
 WHEN m.maxPrice > 2 * ap.avgMaxPrice THEN 'Costly'
 END
 ORDER BY m.maxPrice) AS rn
 FROM
 Medicine m
 CROSS JOIN AvgPrice ap
 WHERE
 m.hospitalExclusive = 'Y' AND
 (m.maxPrice < 0.5 * ap.avgMaxPrice OR m.maxPrice > 2 * ap.avgMaxPrice)
)
SELECT
 medicineID,
 productName,
 maxPrice,
 PriceCategory
FROM CategorizedMedicines
WHERE
 (PriceCategory = 'Affordable' AND rn <= 5) OR
 (PriceCategory = 'Costly' AND rn <= 5);
