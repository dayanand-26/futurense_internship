use healthcare;

#PS-1
SELECT
 CASE
 WHEN TIMESTAMPDIFF(YEAR, pa.dob, '2022-01-01') BETWEEN 0 AND 14 THEN 'Children'
 WHEN TIMESTAMPDIFF(YEAR, pa.dob, '2022-01-01') BETWEEN 15 AND 24 THEN 'Youth'
 WHEN TIMESTAMPDIFF(YEAR, pa.dob, '2022-01-01') BETWEEN 25 AND 64 THEN 'Adults'
 WHEN TIMESTAMPDIFF(YEAR, pa.dob, '2022-01-01') >= 65 THEN 'Seniors'
 END AS age_category,
 COUNT(t.treatmentID) AS treatment_count
FROM
 Treatment t
JOIN
 Patient pa ON t.patientID = pa.patientID
JOIN
 Person p ON pa.patientID = p.personID
WHERE
 YEAR(t.date) = 2022
GROUP BY
 age_category
ORDER BY
 FIELD(age_category, 'Children', 'Youth', 'Adults', 'Seniors');
 
 
 #PS-2
 SELECT
 d.diseaseName,
 SUM(CASE WHEN p.gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
 SUM(CASE WHEN p.gender = 'Female' THEN 1 ELSE 0 END) AS female_count,
 CASE
 WHEN SUM(CASE WHEN p.gender = 'Female' THEN 1 ELSE 0 END) = 0 THEN 'Male Only'
 WHEN SUM(CASE WHEN p.gender = 'Male' THEN 1 ELSE 0 END) = 0 THEN 'Female Only'
 ELSE CAST(SUM(CASE WHEN p.gender = 'Male' THEN 1 ELSE 0 END) AS DECIMAL) /
 CAST(SUM(CASE WHEN p.gender = 'Female' THEN 1 ELSE 0 END) AS DECIMAL)
 END AS male_to_female_ratio
FROM
 Disease d
JOIN
 Treatment t ON d.diseaseID = t.diseaseID
JOIN
 Person p ON t.patientID = p.personID
GROUP BY
 d.diseaseName
ORDER BY
 male_to_female_ratio DESC;
 
 
 #PS-3
 SELECT
 p.gender,
 COUNT(t.treatmentID) AS number_of_treatments,
 COUNT(c.claimID) AS number_of_claims,
 IFNULL(COUNT(c.claimID) / NULLIF(COUNT(t.treatmentID), 0), 0) AS treatment_to_claim_ratio
FROM
 Treatment t
LEFT JOIN
 Claim c ON t.claimID = c.claimID
JOIN
 Patient pa ON t.patientID = pa.patientID
JOIN
 Person p ON pa.patientID = p.personID
GROUP BY
 p.gender
ORDER BY
 p.gender;
 
 
 #PS-4
 SELECT
 p.pharmacyName,
 SUM(k.quantity) AS total_units,
 SUM(m.maxPrice) AS total_max_retail_price,
 SUM(m.maxPrice * (1 - k.discount / 100) * k.quantity) AS total_price_after_discount
FROM
 Pharmacy p
JOIN
 Keep k ON p.pharmacyID = k.pharmacyID
JOIN
 Medicine m ON k.medicineID = m.medicineID
GROUP BY
 p.pharmacyName;
 
 
 #PS-5
 SELECT
 p.pharmacyName,
 MAX(prescriptionItemCount) AS max_prescribed,
 MIN(prescriptionItemCount) AS min_prescribed,
 AVG(prescriptionItemCount) AS avg_prescribed
FROM
 Pharmacy p
JOIN (
 SELECT
 pharmacyID,
 COUNT(*) AS prescriptionItemCount
 FROM
 Prescription
 GROUP BY
 pharmacyID
) AS prescription_count ON p.pharmacyID = prescription_count.pharmacyID
GROUP BY
 p.pharmacyName;