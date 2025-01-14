
--List all the student details studying in fourth semester ‘C’ section.

SELECT S.USN, S.SName, S.Address, S.Phone, S.Gender
FROM STUDENT S
JOIN CLASS C ON S.USN = C.USN
JOIN SEMSEC SS ON C.SSID = SS.SSID
WHERE SS.Sem = 4 AND SS.Sec = 'C';

----------------------------------------

--Compute the total number of male and female students in each semester and in each section.
SELECT SS.Sem, SS.Sec, 
       SUM(S.Gender = 'Male') AS MaleCount,
       SUM(S.Gender = 'Female') AS FemaleCount
FROM STUDENT S
JOIN CLASS C ON S.USN = C.USN
JOIN SEMSEC SS ON C.SSID = SS.SSID
GROUP BY SS.Sem, SS.Sec;

----------------------------------------

--Create a view of Test1 marks of student USN ‘1BI15CS101’ in all Courses.

CREATE VIEW STUDENT_TEST1_MARKS_V
AS
SELECT TEST1, SUBCODE
FROM IAMARKS
WHERE USN = '1BI15CS101';

SELECT * FROM STUDENT_TEST1_MARKS_V;

----------------------------------------

--Calculate the FinalIA (average of best two test marks) and update the corresponding table for all students.

DELIMITER //
CREATE PROCEDURE AVG_MARKS()
BEGIN
DECLARE C_A INTEGER;
DECLARE C_B INTEGER;
DECLARE C_C INTEGER;
DECLARE C_SUM INTEGER;
DECLARE C_AVG INTEGER;
DECLARE C_USN VARCHAR(10);
DECLARE C_SUBCODE VARCHAR(8);
DECLARE C_SSID VARCHAR(5);

DECLARE C_IAMARKS CURSOR FOR
SELECT GREATEST(TEST1,TEST2) AS A, GREATEST(TEST1,TEST3) AS B, GREATEST(TEST3,TEST2) AS C, USN, SUBCODE, SSID
FROM IAMARKS
WHERE FINALIA IS NULL
FOR UPDATE;

OPEN C_IAMARKS;
LOOP

FETCH C_IAMARKS INTO C_A, C_B, C_C, C_USN, C_SUBCODE, C_SSID;

IF (C_A != C_B) THEN
	SET C_SUM=C_A+C_B;
ELSE
	SET C_SUM=C_A+C_C;
END IF;

SET C_AVG=C_SUM/2;

UPDATE IAMARKS SET FINALIA = C_AVG 
WHERE USN = C_USN AND SUBCODE = C_SUBCODE AND SSID = C_SSID;

END LOOP;
CLOSE C_IAMARKS;
END;
//


CALL AVG_MARKS();

SELECT * FROM IAMARKS;

--------------------------------------------

-- Categorize students based on the following criterion:
-- If FinalIA = 17 to 20 then CAT = ‘Outstanding’
-- If FinalIA = 12 to 16 then CAT = ‘Average’
-- If FinalIA< 12 then CAT = ‘Weak’
-- Give these details only for 8th semester A, B, and C section students.

SELECT S.USN,S.SNAME,S.ADDRESS,S.PHONE,S.GENDER, IA.SUBCODE,
(CASE
WHEN IA.FINALIA BETWEEN 17 AND 20 THEN 'OUTSTANDING'
WHEN IA.FINALIA BETWEEN 12 AND 16 THEN 'AVERAGE'
ELSE 'WEAK'
END) AS CAT
FROM STUDENT S, SEMSEC SS, IAMARKS IA, SUBJECT SUB
WHERE S.USN = IA.USN AND
SS.SSID = IA.SSID AND
SUB.SUBCODE = IA.SUBCODE AND
SUB.SEM = 8;

