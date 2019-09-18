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
SELECT 100.0 * SUM(CASE WHEN b.productid=42 THEN 1.0 ELSE 0.0 END) / SUM(1.0)
FROM customer a
    INNER JOIN product b
    ON a.customerid=b.customerid;

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
WHERE purhcasetimestamp >='2019-07-04';
