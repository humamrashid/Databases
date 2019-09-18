/* Question 1. */
SELECT description FROM product
WHERE productid=42;

/* Question 2. */
SELECT lname, fname, street1, street2, city, state, zip FROM customer
WHERE customerid=42;

/* Question 3. */
SELECT productid FROM purchase WHERE customerid=42;

/* Question 4. */
SELECT customerid FROM purchase WHERE productid=24;

/* Question 5. */
SELECT customer.lname, customer.fname FROM customer INNER JOIN purchase
ON customer.customerid = purchase.customerid
GROUP BY purchase.quantity
HAVING SUM(purchase.quantity) = 0;

/* Question 6. */
SELECT product.description from product INNER JOIN purchase
ON product.productid = purchase.productid
GROUP BY purchase.quantity
HAVING SUM(purchase.quantity) = 0;

/* Question 7. */
SELECT purchase.productid from purchase INNER JOIN customer
ON purchase.customerid = customer.customerid
WHERE customer.zip = 10001;
