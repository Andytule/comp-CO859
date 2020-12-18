/*******************************************************
Script: lab5.sql
Author: Andy Le
Date: Oct 25, 2020
Statement of Authorship: I, Andy Le, student number 
000805099, certify that this material is my original 
work. No other person's work has been used without due
ackknowledgement and I have not made my work available
to anyone else.
********************************************************/

USE CHDB;

PRINT 'GROUP 1 SELECT A';

SELECT COUNT(*)
FROM patients
WHERE FLOOR(DATEDIFF(DAY, birth_date, GETDATE()) / 365.25) > 19;

PRINT 'GROUP 1 SELECT C';

SELECT first_name, last_name, patient_height
FROM patients
WHERE patient_height = (SELECT MAX(patient_height) FROM patients)

PRINT 'GROUP 2 SELECT B';

SELECT COUNT(*) AS NumberOfCurrentAdmissions, attending_physician_id
FROM admissions
WHERE discharge_date IS NULL
GROUP BY attending_physician_id;

PRINT 'GROUP 2 SELECT C';

SELECT COUNT(*) AS NumberOfPatients, province_id
FROM patients
WHERE NOT province_id = 'ON'
GROUP BY province_id;

PRINT 'GROUP 3 SELECT A';

SELECT p.patient_id, first_name, last_name, room, bed
FROM patients p
JOIN admissions a
ON p.patient_id = a.patient_id
WHERE discharge_date IS NULL AND nursing_unit_id = '2SOUTH'
ORDER BY last_name;

PRINT 'GROUP 3 SELECT B';

SELECT pharmacist_initials, entered_date, dosage
FROM unit_dose_orders u
JOIN medications m
ON u.medication_id = m.medication_id
WHERE m.medication_description = 'Morphine'
ORDER BY pharmacist_initials;

PRINT 'GROUP 4 SELECT A';

SELECT a.physician_id, a.first_name, a.last_name, a.specialty
FROM physicians a
JOIN encounters b
ON a.physician_id = b.physician_id
JOIN patients c
ON b.patient_id = c.patient_id
WHERE c.first_name = 'Harry' AND c.last_name = 'Sullivan';

PRINT 'GROUP 4 SELECT B';

SELECT p.patient_id, p.first_name, p.last_name, a.nursing_unit_id, primary_diagnosis
FROM patients p
JOIN admissions a
ON p.patient_id = a.patient_id
JOIN physicians h
ON a.attending_physician_id = h.physician_id
WHERE discharge_date IS NULL AND h.specialty = 'Internist';

PRINT 'GROUP 5 SELECT A';

SELECT CONCAT(h.first_name, ' ', h.last_name) as physcian, n.specialty, CONCAT(p.first_name, ' ', p.last_name) as patient, a.primary_diagnosis
FROM physicians h
JOIN admissions a
ON h.physician_id = a.attending_physician_id
JOIN patients p
ON a.attending_physician_id = p.patient_id
JOIN nursing_units n
ON a.nursing_unit_id = n.nursing_unit_id
WHERE a.discharge_date IS NULL AND a.secondary_diagnoses IS NULL;

PRINT 'GROUP 6 SELECT A';

SELECT patient_id, primary_diagnosis, attending_physician_id
FROM admissions
WHERE admissions.discharge_date IS NULL AND
NOT EXISTS (SELECT * FROM encounters WHERE admissions.patient_id = encounters.patient_id)
