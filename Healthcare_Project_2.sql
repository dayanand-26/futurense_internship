use healthcare;

#PS-6
SELECT * FROM internship2024.pharmacy;
WITH city_pharmacy_count AS (
 SELECT
 a.city,
 COUNT(DISTINCT p.pharmacyID) AS pharmacy_count
 FROM
 pharmacy p
 JOIN address a ON p.addressID = a.addressID
 GROUP BY
 a.city
),
city_prescription_count AS (
 SELECT
 a.city,
 COUNT(pr.prescriptionID) AS prescription_count
 FROM
 prescription pr
 JOIN pharmacy p ON pr.pharmacyID = p.pharmacyID
 JOIN address a ON p.addressID = a.addressID
 GROUP BY
 a.city
)
SELECT
 cpc.city,
 cpc.pharmacy_count,
 cpc2.prescription_count,
 cpc.pharmacy_count / cpc2.prescription_count AS pharmacy_to_prescription_ratio
FROM
 city_pharmacy_count cpc
 JOIN city_prescription_count cpc2 ON cpc.city = cpc2.city
WHERE
 cpc2.prescription_count > 100
ORDER BY
 pharmacy_to_prescription_ratio ASC
LIMIT 3;


#PS-7
SELECT
 cdc.city,
 cdc.diseaseName,
 cdc.treatmentCount
FROM (
 SELECT
 a.city,
 d.diseaseName,
 COUNT(t.treatmentID) AS treatmentCount
 FROM
 Treatment t
 JOIN
 Disease d ON t.diseaseID = d.diseaseID
 JOIN
 Patient pt ON t.patientID = pt.patientID
 JOIN
 Person p ON pt.patientID = p.personID
 JOIN
 Address a ON p.addressID = a.addressID
 WHERE
 a.state = 'AL'
 GROUP BY
 a.city, d.diseaseName
) AS cdc
JOIN (
 SELECT
 city,
 MAX(treatmentCount) AS maxTreatmentCount
 FROM (
 SELECT
 a.city,
 d.diseaseName,
 COUNT(t.treatmentID) AS treatmentCount
 FROM
 Treatment t
 JOIN
 Disease d ON t.diseaseID = d.diseaseID
 JOIN
 Patient pt ON t.patientID = pt.patientID
 JOIN
 Person p ON pt.patientID = p.personID
 JOIN
 Address a ON p.addressID = a.addressID
 WHERE
 a.state = 'AL'
 GROUP BY
 a.city, d.diseaseName
 ) AS subquery
 GROUP BY
 city
) AS mcdc ON cdc.city = mcdc.city AND
cdc.treatmentCount = mcdc.maxTreatmentCount
ORDER BY
 cdc.city desc limit 1;
 
 
 #PS-8
 WITH ClaimCounts AS (
 SELECT
 d.diseaseName,
 ip.planName,
 COUNT(c.claimID) AS claim_count
 FROM
 claim c
 JOIN
 treatment t ON c.claimID = t.claimID
 JOIN
 disease d ON t.diseaseID = d.diseaseID
 JOIN
 insuranceplan ip ON c.UIN = ip.UIN
 GROUP BY
 d.diseaseName,
 ip.planName
),
MaxClaims AS (
 SELECT
 diseaseName,
 MAX(claim_count) AS max_claims
 FROM
 ClaimCounts
 GROUP BY
 diseaseName
),
MinClaims AS (
 SELECT
 diseaseName,
 MIN(claim_count) AS min_claims
 FROM
 ClaimCounts
 GROUP BY
 diseaseName
)
SELECT
 cc.diseaseName,
 cc.planName AS most_claimed_plan,
 cc_max.max_claims,
 cc_min.planName AS least_claimed_plan,
 cc_min.min_claims
FROM
 ClaimCounts cc
JOIN
 MaxClaims cc_max ON cc.diseaseName =
cc_max.diseaseName AND cc.claim_count =
cc_max.max_claims
JOIN
 (SELECT
 cc1.diseaseName,
 cc1.planName,
 cc1.claim_count AS min_claims
 FROM
 ClaimCounts cc1
 JOIN
 MinClaims cc2 ON cc1.diseaseName =
cc2.diseaseName AND cc1.claim_count =
cc2.min_claims
 ) cc_min ON cc.diseaseName =
cc_min.diseaseName;


#PS-9
SELECT
 d.diseaseName,
 COUNT(DISTINCT a.addressID) AS
households_count
FROM
 Treatment t1
JOIN
 Patient p1 ON t1.patientID = p1.patientID
JOIN
 Person ps1 ON p1.patientID = ps1.personID
JOIN
 Address a ON ps1.addressID = a.addressID
JOIN
 Disease d ON t1.diseaseID = d.diseaseID
WHERE
 EXISTS (
 SELECT
 1
 FROM
 Treatment t2
 JOIN
 Patient p2 ON t2.patientID = p2.patientID
 JOIN
 Person ps2 ON p2.patientID = ps2.personID
 WHERE
 ps2.addressID = a.addressID
 AND t2.diseaseID = t1.diseaseID
 AND t2.patientID <> t1.patientID
 )
GROUP BY
 d.diseaseID, d.diseaseName;
 
 
 #PS-10
 SELECT
 a.state,
 COUNT(DISTINCT t.treatmentID) AS total_treatments,
 COUNT(DISTINCT c.claimID) AS total_claims,
 ROUND(COUNT(DISTINCT t.treatmentID) / NULLIF(COUNT(DISTINCT c.claimID), 0), 2) AS
treatment_to_claim_ratio
FROM
 Treatment t
JOIN
 Patient p ON t.patientID = p.patientID
JOIN
 Person ps ON p.patientID = ps.personID
JOIN
 Address a ON ps.addressID = a.addressID
LEFT JOIN
 Claim c ON t.claimID = c.claimID
WHERE
 t.date BETWEEN '2021-04-01' AND '2022-03-31'
GROUP BY
a.state;
