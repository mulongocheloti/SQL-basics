USE classicmodels;

SELECT * FROM employees
	ORDER BY lastName, firstName DESC, employeeNumber ASC;

SELECT jobTitle, COUNT(jobTitle),reportsTo FROM employees
	GROUP BY jobTitle, reportsTo;

SELECT * FROM customers;

SELECT country, COUNT(*) AS no_of_customers, SUM(creditLimit), AVG(creditLimit) FROM customers
	GROUP BY country
	ORDER BY no_of_customers DESC;

-- Transforming data
SELECT SUM(creditLimit) INTO @TotalCreditLimit FROM customers
	WHERE country = 'France';    
SELECT LOWER(customerName)AS Name, UPPER(SUBSTR(country,1,3))AS country_code, creditLimit, (creditLimit/@TotalCreditLimit) * 100 AS `credit_%Contribution` FROM customers
	WHERE country = 'France'
	ORDER BY `credit_%Contribution`;

SELECT REPLACE (customerName, "Co.", "iNC.") FROM customers;
-- under REPLACE, strings are case sensitive

SELECT DISTINCT creditLimit FROM customers
	ORDER BY creditLimit;

SELECT DISTINCT creditLimit FROM customers 
	ORDER BY CAST(creditLimit AS CHAR);

SELECT MAX(creditLimit) FROM customers;

SELECT MAX(CAST(creditLimit AS CHAR)) FROM customers;

SELECT * FROM orderdetails;

SELECT * FROM orderdetails 
	WHERE orderLineNumber = 4 AND (productCode LIKE 'S18%' OR productCode LIKE 'S24%'); 

-- We can use string functions on our data
	/* LEFT, RIGHT, LOWER, UPPER, CONCAT, +, SUBSTR, TRIM, LOCATE
    */
    
-- Incase the contactLastName has strings with whitespaces the TRIM() removes them.
SELECT * FROM customers
WHERE TRIM(contactLastName) = 'King';


SELECT extension as original, TRIM(BOTH 'x' FROM extension) AS modified FROM employees;

SELECT customerName, LOCATE('ift',customerName) FROM customers;
-- Equivalent of LOCATE in T-SQL is CHARINDEX
-- Equivalent of LOCATE in PL/SQL is INSTR

SELECT * FROM customers;

SELECT country, GROUP_CONCAT(phone ORDER BY phone ASC SEPARATOR '; ') AS Contacts FROM customers
	GROUP BY country;
    
USE my_guitar_shop;
SELECT category_name AS `Product Category`, SUM(quantity) AS `Number Purchased`, CONCAT('$',FORMAT(MAX(list_price),2)) AS `Max List Price`,
	CONCAT('$',FORMAT(MIN(list_price),2)) AS `Min List Price`,  CONCAT('$',FORMAT((SUM(list_price)/COUNT(list_price)),2)) AS `Average List Price` FROM categories
	LEFT JOIN products ON categories.category_id = products.category_id
	LEFT JOIN order_items ON products.product_id = order_items.product_id
    GROUP BY category_name WITH ROLLUP;








		
