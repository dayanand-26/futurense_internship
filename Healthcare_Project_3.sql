use healthcare;

#PS_11
SELECT
 ph.pharmacyName,
 COUNT(*) AS
hospital_exclusive_prescrip4ons
FROM
 Prescrip4on p
JOIN
 Contain c ON p.prescrip4onID =
c.prescrip4onID
JOIN
 Medicine m ON c.medicineID =
m.medicineID
JOIN
 Pharmacy ph ON p.pharmacyID =
ph.pharmacyID
JOIN
 Treatment t ON p.treatmentID =
t.treatmentID
WHERE
 m.hospitalExclusive = 'S'
 AND t.date BETWEEN '2021-01-01' AND
'2022-12-31'
GROUP BY
 ph.pharmacyName
ORDER BY
 hospital_exclusive_prescrip4ons DESC;
 
 
 #PS_12
 SELECT
 ip.planName,
 ic.companyName,
 COUNT(t.treatmentID) AS treatment_count
FROM
 InsurancePlan ip
JOIN
 InsuranceCompany ic ON ip.companyID = ic.companyID
JOIN
 Claim c ON ip.uin = c.uin
JOIN
 Treatment t ON c.claimID = t.claimID
GROUP BY
 ip.planName, ic.companyName
ORDER BY
 treatment_count DESC;
 
 
 #PS_13
 WITH PlanClaims AS (
 SELECT
 ic.companyName,
 ip.planName,
 COUNT(t.treatmentID) AS claim_count
 FROM
 InsurancePlan ip
 JOIN
 InsuranceCompany ic ON ip.companyID =
ic.companyID
 JOIN
 Claim c ON ip.uin = c.uin
 JOIN
 Treatment t ON c.claimID = t.claimID
 GROUP BY
 ic.companyName, ip.planName
),
RankedPlans AS (
 SELECT
 companyName,
 planName,
 claim_count,
 ROW_NUMBER() OVER (PARTITION BY
companyName ORDER BY claim_count DESC)
AS rank_desc,
 ROW_NUMBER() OVER (PARTITION BY
companyName ORDER BY claim_count ASC)
AS rank_asc
 FROM
 PlanClaims
)
SELECT
 companyName,
 MAX(CASE WHEN rank_desc = 1 THEN
planName END) AS most_claimed_plan,
 MAX(CASE WHEN rank_desc = 1 THEN
claim_count END) AS most_claimed_count,
 MAX(CASE WHEN rank_asc = 1 THEN
planName END) AS least_claimed_plan,
 MAX(CASE WHEN rank_asc = 1 THEN
claim_count END) AS least_claimed_count
FROM
 RankedPlans
GROUP BY
 companyName
ORDER BY
 companyName;
 
 
 #PS_14
 SELECT
 a.state,
 COUNT(DISTINCT p.personID) AS registered_people,
 COUNT(DISTINCT pa.pa4entID) AS registered_pa4ents,
 COUNT(DISTINCT p.personID) / NULLIF(COUNT(DISTINCT pa.pa4entID), 0) AS
people_to_pa4ent_ra4o
FROM
 Address a
JOIN
 Person p ON a.addressID = p.addressID
LEFT JOIN
 Pa4ent pa ON p.personID = pa.pa4entID
GROUP BY
 a.state
ORDER BY
 people_to_pa4ent_ra4o;
 
 
 #PS_15
 SELECT
 ph.pharmacyName,
 SUM(c.quan4ty) AS total_quan4ty
FROM
 Pharmacy ph
JOIN
 Address a ON ph.addressID = a.addressID
JOIN
 Prescrip4on p ON ph.pharmacyID = p.pharmacyID
JOIN
 Contain c ON p.prescrip4onID = c.prescrip4onID
JOIN
 Medicine m ON c.medicineID = m.medicineID
JOIN
 Treatment t ON p.treatmentID = t.treatmentID
WHERE
 a.state = 'AZ'
 AND m.taxCriteria = 'I'
 AND t.date BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY
 ph.pharmacyName
ORDER BY
 total_quan4ty DESC;
 