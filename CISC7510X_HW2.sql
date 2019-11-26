-- Humam Rashid
-- CISC 7510X, Fall 2019

-- Schema:

-- product(productid,description)
-- customer(customerid,username,fname,lname,street1,street2,city,state,zip)
-- purchase(purchaseid,purchasetimestamp,customerid,productid,quantity,price)

/* Question 1. */
SELECT description
FROM product
WHERE productid=42;

/* Question 2. */
SELECT lname, fname, street1, street2, city, state, zip
FROM customer
WHERE customerid=42;

/* Question 3. "Corrected" from H.W. #1 */
SELECT a.* 
FROM product a
    INNER JOIN purchase b
    ON a.productid=b.productid
WHERE b.customerid=42;

/* Question 4. "Corrected" from H.W. #1 */
SELECT a.*
FROM customer
    INNER JOIN purchase b
    ON a.customerid=b.customerid
WHERE b.productid=24;

/* Question 5. "Corrected" from H.W. #1 */
SELECT a.lname, a.fname
FROM customer a
    LEFT OUTER JOIN purchase b
    ON a.customerid=b.customerid
WHERE b.purchaseid IS NULL;

/* Question 6. "Corrected" from H.W. #1 */
SELECT a.description
FROM product a
    LEFT OUTER JOIN purchase b
    ON a.productid=b.productid
WHERE b.purchaseid IS NULL;

/* Question 7. "Corrected" from H.W. #1 */
SELECT c.*
FROM customer a
    INNER JOIN purchase b
    ON a.customerid=b.customerid
    INNER JOIN product c
    ON b.productid=c.productid
WHERE a.zip='10001';

/* Question 8. */
WITH customers_distinct AS (
    SELECT DISTINCT a.customerid
    FROM customer a
        INNER JOIN purchase b
        ON a.customerid=b.customerid;
)
SELECT 100.0 * SUM(CASE WHEN d.productid=42 THEN 1.0 ELSE 0.0 END) / SUM(1.0)
FROM customers_distinct c
    INNER JOIN purchase d
    ON c.customerid=d.customerid;

/* Question 9. */
WITH buyers42 AS (
    SELECT a.*
    FROM customer a
        INNER JOIN purchase b
        ON a.customerid=b.customerid
    WHERE b.productid=42;
)
SELECT 100.0 * SUM(CASE WHEN d.productid=24 THEN 1.0 ELSE 0.0 END) / SUM(1.0)
FROM buyers_42 c
    INNER JOIN purchase d
    ON c.customerid=d.customerid;

/* Question 10. */
SELECT a.productid, SUM(a.quantity)
FROM purchase a
    INNER JOIN customer b
    ON a.customerid=b.customerid
WHERE b.state='NY'
GROUP BY a.productid
ORDER BY DESC
LIMIT 1;

/* Question 11. */
SELECT a.productid, SUM(a.quantity)
FROM purchase a
    INNER JOIN customer b
    ON a.customerid=b.customerid
WHERE b.state='NY' OR b.state='NJ' OR ...
GROUP BY a.productid
ORDER BY DESC
LIMIT 1;

/* Question 12. */
SELECT a.*
FROM customers a
    INNER JOIN purchase b
    ON a.customerid=b.customerid
WHERE productid=24 AND purhcasetimestamp <'2019-07-04';

-- EOF.
