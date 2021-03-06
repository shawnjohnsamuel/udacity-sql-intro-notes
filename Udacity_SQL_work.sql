createdb parch
psql parch < parch_and_posey.sql

/* 

4 SQL Subquireies & Temporary Table

4.10 Subquery Mania - Questions

4.10.1 Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales. */

SELECT t3.rep_name, t2.region_name, t2.total_sales

FROM(SELECT region_name, MAX(total_sales) total_sales
    FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_sales
        FROM region r
        JOIN sales_reps s
        ON r.id = s.region_id
        JOIN accounts a
        ON s.id = a.sales_rep_id
        JOIN orders o
        ON a.id = o.account_id
        GROUP BY 1,2
        ORDER BY 3 DESC) t1
    GROUP BY 1) t2
JOIN(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_sales
    FROM region r
    JOIN sales_reps s
    ON r.id = s.region_id
    JOIN accounts a
    ON s.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1,2
    ORDER BY 3 DESC) t3
ON t2.region_name = t3.region_name AND t2.total_sales = t3.total_sales

/* 4.10.2 For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed? */


SELECT r.name region, SUM(o.total_amt_usd), COUNT(o.id)
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

/* 4.10.3 How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer? */

SELECT COUNT (*)
FROM(SELECT a.name, SUM(o.total)
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1
    HAVING SUM(o.total) >

    (SELECT t1.total_purchases
    FROM(SELECT a.name account, SUM(standard_qty) total_std, SUM(total) total_purchases
        FROM accounts a
        JOIN orders o
        ON a.id = o.account_id
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 1) t1)) t2


/* 4.10.4 For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel? */

SELECT a.id, channel, COUNT(channel)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1, 2
HAVING a.id =

(SELECT t1.id
FROM(SELECT a.id, a.name, SUM(total_amt_usd)
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1, 2
    ORDER BY 3 DESC
    LIMIT 1) t1)

/* 4.10.5 What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts? */

SELECT AVG(t1.total)
FROM(SELECT a.name, SUM(o.total_amt_usd) total
    FROM accounts a 
    JOIN orders o 
    ON a.id = o.account_id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10) t1

/* 4.10.6 What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders. */

SELECT AVG(avg)
FROM(SELECT account_id, AVG(total_amt_usd)
    FROM orders
    GROUP BY account_id
    HAVING AVG(total_amt_usd) > (SELECT AVG(total_amt_usd)
                                FROM orders)) t1


/* 

4 SQL Subquireies & Temporary Table

4.13 Quiz: WITH

4.13.1 Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales */

WITH t1 AS (SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total_amt
            FROM orders o 
            JOIN accounts a 
            ON o.account_id = a.id
            JOIN sales_reps s
            ON a.sales_rep_id = s.id
            JOIN region r
            ON s.region_id = r.id
            GROUP BY 1, 2
            ORDER BY 3 DESC), 

    t2 AS (SELECT region, MAX(total_amt) total_amt
            FROM t1
            GROUP BY 1)


SELECT t1.rep, t1.region, t1.total_amt
FROM t1
JOIN t2
ON t1.region = t2.region AND t1.total_amt = t2.total_amt
ORDER BY 3 DESC

/* 4.13.2 For the region with the largest sales total_amt_usd, how many total orders were placed */

WITH t1 AS (
    SELECT r.name region, SUM(total_amt_usd) total_sales
    FROM orders o 
    JOIN accounts a 
    ON o.account_id = a.id
    JOIN sales_reps s
    ON a.sales_rep_id = s.id
    JOIN region r
    ON s.region_id = r.id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1),

    t2 AS (
    SELECT region
    FROM t1
    )

SELECT COUNT(o.total)
FROM orders o 
JOIN accounts a 
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name= (SELECT * FROM t2)

/* 4.13.3 For the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases? */

WITH t1 AS (
    SELECT account_id, SUM(standard_qty), SUM(total) total
    FROM orders
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1), 

    t2 AS (
    SELECT a.name
    FROM orders o 
    JOIN accounts a 
    ON o.account_id = a.id
    GROUP BY 1
    HAVING SUM(o.total) > (SELECT total from t1))

SELECT COUNT(*) FROM t2

/* 4.13.4 For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel? */

WITH t1 AS (
    SELECT account_id, SUM(total_amt_usd)
    FROM orders o 
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1)

SELECT channel, COUNT(channel)
FROM web_events
WHERE account_id = (SELECT account_id FROM t1)
GROUP BY 1

/* 4.13.5 What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts? */

WITH t1 AS (
    SELECT account_id, SUM(total_amt_usd)
    FROM orders
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10)

SELECT AVG(sum) FROM t1

/* 4.13.6 What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders. */

WITH t1 AS (
    SELECT AVG(total_amt_usd)
    FROM orders),

    t2 AS (
    SELECT account_id, AVG(total_amt_usd)
    FROM orders
    GROUP BY 1
    HAVING AVG(total_amt_usd) > (SELECT * FROM t1))
    
SELECT AVG(avg) FROM t2


/* 

5 Introduction to SQL Data Cleaning

5.3 Quiz: LEFT & RIGHT

5.3.1 */

SELECT RIGHT(website, 3) as webend, COUNT(*)
FROM accounts
GROUP BY webend

/* 5.3.2 */

SELECT LEFT(name, 1) as start_letter, COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC

/* 5.3.3 */

SELECT SUM(num) as num, SUM(letter) as letter
FROM
    (SELECT name,
        CASE
            WHEN LEFT(name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
            THEN 1 
            ELSE 0 
            END AS num,
        CASE
            WHEN LEFT(name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
            THEN 0 
            ELSE 1 
            END AS letter
    FROM accounts) as t1

/* 5.3.4 */



SELECT SUM(vowel) as vowel, SUM(not_vowel) as not_vowel
FROM
    (SELECT name,
        CASE
            WHEN LEFT(LOWER(name), 1) IN ('a', 'e', 'i', 'o', 'u')
            THEN 1 
            ELSE 0 
            END AS vowel,
        CASE
            WHEN LEFT(LOWER(name), 1) IN ('a', 'e', 'i', 'o', 'u')
            THEN 0 
            ELSE 1 
            END AS not_vowel
    FROM accounts) as t1

/* 5.6 Quiz: POSITION, STRPOS & SUBSTR

5.6.1 */

SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) AS first_name,
       RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS last_name
FROM accounts


/* 5.6.2 */

SELECT LEFT(name, STRPOS(name, ' ')-1) AS first_name,
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) AS last_name
FROM sales_reps

/* 5.9 Quiz: CONCAT

5.9.2 Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com */

SELECT LEFT(LOWER(primary_poc), STRPOS(primary_poc, ' ')-1) || '.' ||
       RIGHT(LOWER(primary_poc), LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) || '@' ||
       LOWER(REPLACE(name,' ','')) || '.com' AS email
FROM accounts

/* 5.9.3 We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces. */


SELECT LEFT(LOWER(primary_poc),1)
       RIGHT(LEFT(LOWER(primary_poc), STRPOS(primary_poc, ' ')-1),1)
FROM accounts


/* 5.15 */


1. SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

2. SELECT COALESCE(o.id, a.id), a.*, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;