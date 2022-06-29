#
# Lesson 1: SQL Simple Clauses

## Syntax Order:
SELECT  
FROM  
JOIN  
ON  
WHERE  
GROUP BY  
HAVING  
ORDER BY  
LIMIT  

## SELECT
- always first
- create derived column by putting AS at the end of manipulation of other columns

## WHERE
- WHERE allows you to filter a set of results based on specific criteria
- WHERE comes after SELECT and FROM but before ORDER BY
non-numeric data needs single quotes

### Logical Operators
- LIKE allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for 
- % is wild card 
- IN allows you to perform operations similar to using WHERE and =, but for more than one condition.  
- NOT is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.  
- AND allows you to combine operations where all combined conditions must be true. Has to contain independant logical statements.
- BETWEEN is a cleaner version to avoid two AND statements when it's a range on the same column.
- OR allows you to combine operations where at least one of the combined conditions must be true.  

## ORDER BY
- ORDER BY has to come after SELECT and FROM but before LIMIT  
- ORDER BY defaults to ASC (smallest to greatest, earliest to latest, lowest to greatest)  
- add DESC to the end of clause to get (greatest to smallest, latest to earliest, greatest to lowest)
- you can refer to columns in SELECT statement using numbers that refer to the order in SELECT statement

## LIMIT
- LIMIT always comes at the end

## SYNTAX
- string: ('word', 'word')
- date: '2022-01-01'

#
# LESSON 2: SQL Joins

## Normalization
- thinking about data will be stored when creating a database
- ERD - entity relationship diagram

## JOIN
- PK - Primary Key - unique column
- FK - Foreign Key - links to a primary key of another table
- when joining, to select certain columns from certain tables use table.column format
- ON statement is PK = FK or FK = PK (but not always)
- alias columns in SELECT, and tables in FROM or JOIN clauses. Can be w/ or w/o the AS statement
- generally use LEFT joins
- filter in the ON clause by adding an AND statement to filter before joining

#
# LESSON 3: Aggregations

## COUNT
- COUNT(*) to count all non null rows

## SUM
- can't use SUM(*)

## MIN MAX
- can also be used on non-numerical columns

## AVG
- AVG ignores NULL in numerator and denominator 

## GROUP BY
- create segments that will aggregate independant from one another
- always goes between WHERE and ORDER BY
- any variable that's in the SELECT statement that is not aggregated needs to be in the GROUP BY
- can group by multiple columns consequitely
- you can refer to columns in SELECT statement using numbers that refer to the order in SELECT statement

## DISTINCT
- written in SELECT statement only once
- returns the unique variables across all selected columns
- DISTINCT slows down queries

## HAVING
- filter on a query that has been aggregated

## SUBQUERY
- add FROM(some other SELECT and query) AS Table1;

## DATE_TRUNC and DATE_PART
- 'dow' stands for day of week. Sunday is 0, 6 is Saturday

## CASE
- for if-then logic using WHEN THEN ELSE END
- always goes in SELECT statment


#
# LESSON 4: Subqueries & Temporary Tables
- indent to help reader know which part of quiries are happening together
- if subquery has one cell result, can you with logical statement like WHERE, HAVING, SELECT. this can be done with no alias.
- IN can be used with subquery that has multiple celled column of results. this can be done with no alias.
- alias is only needed if returning a table

## WITH or Common Table Expression (CTE)
- CTE's get alias just like subquiries 
- WITH alias AS (subquery) is syntax
- you can create multiple tables in WITH separated by comma

#
# LESSON 5: Data Cleaning
- SELECT LEFT(_column_, _number_) AS _alias_ will return a string with specific length from the left of another string column
- SELECT RIGHT() does same
- LENGTH() can be used as a function to return length of a string for each row of a specified column as a number
- POSITION('_character_', _column_) gives the position of the character in the string as a number. Indexing in SQL starts with 1 as opposed to 0 like in python
- STRPOS(_column_,'_character_') does same thing as POSITION() but different syntax. Both of these options are case sensative.
- SUBSTR(_column_, _position_, _numberofcharacters_) i sused to extract a specific number of characters from a particular position of a string
- UPPER() and LOWER() change the chase of the characters in string
- CONCAT() and || can both combine strings. Use ' ' to include a space
- DATE_PART('month', TO_DATE(month, 'month')) here changed a month name into the number associated with that particular month.
- CAST(date_column AS DATE), you can use date_column::DATE both change the string or into into date
- COALESCE() is used to deal with nulls. In general it returns the first non_NULL value passed for each row. You can also pass a second argument explicitly states what to pu instead of NULL.