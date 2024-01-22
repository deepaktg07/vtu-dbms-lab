--Make a list of all project numbers for projects that involve an employee whose last name is ‘Scott’, either as a worker or as a manager of the department that controls the project.

SELECT DISTINCT P.PNo, P.PName
FROM PROJECT P
JOIN WORKS_ON W ON P.PNo = W.PNo
JOIN EMPLOYEE E ON W.SSN = E.SSN OR E.SSN = P.MgrSSN
WHERE E.Name = 'Scott';

--Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise.

UPDATE EMPLOYEE
SET Salary = Salary * 1.10
WHERE SSN IN (
    SELECT W.SSN
    FROM WORKS_ON W
    JOIN PROJECT P ON W.PNo = P.PNo
    WHERE P.PName = 'IoT'
);

--Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the maximum salary, the minimum salary, and the average salary in this department

SELECT
    SUM(E.Salary) AS TotalSalary,
    MAX(E.Salary) AS MaxSalary,
    MIN(E.Salary) AS MinSalary,
    AVG(E.Salary) AS AvgSalary
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DNo = D.DNo
WHERE
    D.DName = 'Accounts';

--Retrieve the name of each employee who works on all the projects controlled by department number 5 (use NOT EXISTS operator).

SELECT E.NAME
FROM EMPLOYEE E
WHERE NOT EXISTS(SELECT PNO FROM PROJECT WHERE DNO='5' AND PNO NOT IN (SELECT
PNO FROM WORKS_ON
WHERE E.SSN=SSN));

--For each department that has more than five employees, retrieve the department number and the number of its employees who are making more than Rs. 6,00,000.

SELECT D.DNO, COUNT(*)
FROM DEPARTMENT D, EMPLOYEE E
WHERE D.DNO=E.DNO
AND E.SALARY > 600000
AND D.DNO IN (SELECT E1.DNO
FROM EMPLOYEE E1
GROUP BY E1.DNO
HAVING COUNT(*)>5)
GROUP BY D.DNO;
