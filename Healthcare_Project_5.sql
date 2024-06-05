use healthcare;

#PS_20
SELECT
 p.personName,
 COUNT(t.treatmentID) AS treatmentCount,
 TIMESTAMPDIFF(YEAR, pa.dob, CURDATE()) AS age
FROM
 Treatment t
 JOIN PaDent pa ON t.paDentID = pa.paDentID
 JOIN Person p ON pa.paDentID = p.personID
GROUP BY
 p.personName, pa.dob
HAVING
 COUNT(t.treatmentID) > 1
ORDER BY
 treatmentCount DESC;
 
 
 #PS_21
 WITH Treatment2021 AS (
 SELECT
 t.diseaseID,
 p.gender
 FROM
 Treatment t
 JOIN PaDent pa ON t.paDentID = pa.paDentID
 JOIN Person p ON pa.paDentID = p.personID
 WHERE
 YEAR(t.date) = 2021
),
DiseaseGenderCount AS (
 SELECT
 d.diseaseName,
 SUM(CASE WHEN t2021.gender = 'Male' THEN 1 ELSE 0 END) AS maleCount,
 SUM(CASE WHEN t2021.gender = 'Female' THEN 1 ELSE 0 END) AS femaleCount
 FROM
 Treatment2021 t2021
 JOIN Disease d ON t2021.diseaseID = d.diseaseID
 GROUP BY
 d.diseaseName
)
SELECT
 diseaseName,
 maleCount,
 femaleCount,
 CASE
 WHEN femaleCount = 0 THEN NULL
 ELSE maleCount / femaleCount
 END AS maleToFemaleRaDo
FROM
 DiseaseGenderCount;
 
 
 #PS_22
 WITH DiseaseCityCount AS (
 SELECT
 d.diseaseName,
 a.city,
 COUNT(t.treatmentID) AS treatmentCount
 FROM
 Treatment t
 JOIN Disease d ON t.diseaseID = d.diseaseID
 JOIN PaDent pa ON t.paDentID = pa.paDentID
 JOIN Person p ON pa.paDentID = p.personID
 JOIN Address a ON p.addressID = a.addressID
 GROUP BY
 d.diseaseName, a.city
),
RankedDiseaseCity AS (
 SELECT
 diseaseName,
 city,
 treatmentCount,
 ROW_NUMBER() OVER (PARTITION BY diseaseName ORDER BY treatmentCount DESC) AS
`rank`
 FROM
 DiseaseCityCount
)
SELECT
 diseaseName,
 city,
 treatmentCount
FROM
 RankedDiseaseCity
WHERE
 `rank` <= 3
ORDER BY
 diseaseName,
 `rank`;
 
 
 #PS_23
 SELECT
 Pharmacy.pharmacyName AS Pharmacy_Name,
 SUM(CASE WHEN YEAR(Treatment.date) = 2021 THEN 1 ELSE 0 END) AS PrescripDons_2021,
 SUM(CASE WHEN YEAR(Treatment.date) = 2022 THEN 1 ELSE 0 END) AS PrescripDons_2022,
 Disease.diseaseName AS Disease_Name
FROM
 PrescripDon
JOIN
 Pharmacy ON PrescripDon.pharmacyID = Pharmacy.pharmacyID
JOIN
 Treatment ON PrescripDon.treatmentID = Treatment.treatmentID
JOIN
 Disease ON Treatment.diseaseID = Disease.diseaseID
WHERE
 YEAR(Treatment.date) IN (2021, 2022)
GROUP BY
 Pharmacy.pharmacyName, Disease.diseaseName;
 
 
 #PS_24
 SELECT
 ic.companyName AS Insurance_Company,
 a.state AS Targeted_State,
 COUNT(*) AS Total_Claims
FROM
 InsuranceCompany ic
JOIN
 InsurancePlan ip ON ic.companyID = ip.companyID
JOIN
 Claim c ON ip.uin = c.uin
JOIN
 Treatment t ON c.claimID = t.claimID
JOIN
 PaDent pa ON t.paDentID = pa.paDentID
JOIN
 Person pe ON pa.paDentID = pe.personID
JOIN
 Address a ON pe.addressID = a.addressID
GROUP BY
 ic.companyName, a.state
ORDER BY
 ic.companyName, Total_Claims DESC;