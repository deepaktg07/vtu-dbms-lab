-- Count the customers with grades above Bangalore’s average

SELECT GRADE,COUNT(DISTINCT CUSTOMER_ID)
FROM CUSTOMER
GROUP BY GRADE
HAVING GRADE>(SELECT AVG(GRADE)
FROM CUSTOMER
WHERE CITY='BANGALORE');

----------------------------------

--Find the name and numbers of all salesman who had more than one customer

SELECT SALESMAN_ID, NAME
FROM SALESMAN
WHERE SALESMAN_ID IN (
    SELECT SALESMAN_ID
    FROM CUSTOMER
    GROUP BY SALESMAN_ID
    HAVING COUNT(*) > 1
);

----------------------------------

--List all the salesman and indicate those who have and don’t have customers in their cities (Use UNION operation.)

-- Salesmen with customers in their cities
SELECT S.SALESMAN_ID, S.NAME, 'Has Customers' AS Status
FROM SALESMAN S
WHERE EXISTS (
    SELECT 1
    FROM CUSTOMER C
    WHERE C.CITY = S.CITY
);

-- Salesmen without customers in their cities
UNION

SELECT S.SALESMAN_ID, S.NAME, 'No Customers' AS Status
FROM SALESMAN S
WHERE NOT EXISTS (
    SELECT 1
    FROM CUSTOMER C
    WHERE C.CITY = S.CITY
);

-----------------------------------

--Create a view that finds the salesman who has the customer with the highest order of a day.

CREATE VIEW V_SALESMAN AS
SELECT O.ORDER_DATE, S.SALESMAN_ID, S.NAME
FROM SALESMAN S,ORDERS O
WHERE S.SALESMAN_ID = O.SALESMAN_ID
AND O.PURCHASE_AMOUNT= (SELECT MAX(PURCHASE_AMOUNT)
FROM ORDERS C
WHERE C.ORDER_DATE=O.ORDER_DATE);

SELECT * FROM V_SALESMAN;

-----------------------------------

--Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted.

DELETE FROM SALESMAN
WHERE SALESMAN_ID=1000;

SELECT * FROM SALESMAN;

SELECT * FROM ORDERS;
