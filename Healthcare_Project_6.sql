use healthcare;

#PS_25
SELECT
 ph.pharmacyID AS Pharmacy_ID,
 ph.pharmacyName AS Pharmacy_Name,
 SUM(c.quan=ty) AS Total_Quan=ty_2022,
 SUM(CASE WHEN m.hospitalExclusive = 'Y' THEN c.quan=ty ELSE 0 END) AS
Hospital_Exclusive_Quan=ty_2022,
 (SUM(CASE WHEN m.hospitalExclusive = 'Y' THEN c.quan=ty ELSE 0 END) * 100.0 /
SUM(c.quan=ty)) AS Percentage_Hospital_Exclusive
FROM
 Prescrip=on p
JOIN
 Contain c ON p.prescrip=onID = c.prescrip=onID
JOIN
 Medicine m ON c.medicineID = m.medicineID
JOIN
 Pharmacy ph ON p.pharmacyID = ph.pharmacyID
JOIN
 Treatment t ON p.treatmentID = t.treatmentID
WHERE
 YEAR(t.date) = 2022
GROUP BY
 ph.pharmacyID, ph.pharmacyName
ORDER BY
 Percentage_Hospital_Exclusive DESC;
 
 
 #PS_26
 SELECT * FROM healthcare.treatment;
SELECT
 COUNT(*) AS null_count
FROM
 treatment
WHERE
 claimID IS NULL;

 SELECT
 (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM treatment)) AS percentage_null_claim
FROM
 treatment
WHERE
 claimID IS NULL;
 
 
 #PS_27
 WITH DiseaseCounts AS (
SELECT
ad.state,
tmt.diseaseID,
 d.diseaseName,
 count(d.diseaseID) as treatmentCount
FROM disease d
 JOIN treatment tmt ON d.diseaseID = tmt.diseaseID
 JOIN pa=ent pt ON tmt.pa=entID = pt.pa=entID
 JOIN person p ON pt.pa=entID = p.personID
 JOIN address ad ON p.addressID = ad.addressID
 WHERE YEAR(tmt.date) = 2022
 GROUP BY
 ad.state,
 tmt.diseaseID
), RankedDiseases AS (
 SELECT
 state,
 diseaseID,
 diseaseName,
 treatmentCount,
 RANK() OVER (PARTITION BY state ORDER BY treatmentCount DESC) AS rank_desc,
 RANK() OVER (PARTITION BY state ORDER BY treatmentCount ASC) AS rank_asc
 FROM DiseaseCounts
)
SELECT
 state,
 MAX(CASE WHEN rank_desc = 1 THEN diseaseName ELSE NULL END) AS mostTreatedDisease,
 MAX(CASE WHEN rank_desc = 1 THEN treatmentCount ELSE NULL END) AS mostTreatedCount,
 MAX(CASE WHEN rank_asc = 1 THEN diseaseName ELSE NULL END) AS leastTreatedDisease,
 MAX(CASE WHEN rank_asc = 1 THEN treatmentCount ELSE NULL END) AS leastTreatedCount
FROM RankedDiseases
GROUP BY state
ORDER BY state;


#PS_28
SELECT
 a.city AS City,
 COUNT(pe.personID) AS Total_Registered,
 COUNT(pa.pa=entID) AS Total_Pa=ents,
 (COUNT(pa.pa=entID) * 100.0 / COUNT(pe.personID)) AS Pa=ent_Percentage
FROM
 Person pe
LEFT JOIN
 Pa=ent pa ON pe.personID = pa.pa=entID
JOIN
 Address a ON pe.addressID = a.addressID
GROUP BY
 a.city
HAVING
 COUNT(pe.personID) >= 10
ORDER BY
 Pa=ent_Percentage DESC;
 