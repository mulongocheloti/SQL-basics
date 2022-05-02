USE classicmodels;

SELECT * FROM products;
SELECT * FROM orderdetails;

-- SUBQUERIES
SELECT productCode, productname, msrp FROM products
	WHERE productCode IN ( SELECT DISTINCT productCode FROM orderdetails
								WHERE priceEach < 100
						 );

SELECT * FROM CUSTOMERS;

-- STORED PROCEDURES
DROP PROCEDURE IF EXISTS Customers_From_USA;
DELIMITER &&
CREATE PROCEDURE Customers_From_USA()
	BEGIN
	SELECT customerNumber, customerName, addressLine1, city, state, creditLimit FROM customers
		WHERE country = 'USA';
	END &&
DELIMITER ;

CALL Customers_From_USA();

SELECT DISTINCT country FROM customers;

# SP using IN
DROP PROCEDURE IF EXISTS CustomersFrom;
DELIMITER //
CREATE PROCEDURE CustomersFrom (IN countryName VARCHAR(15))
	BEGIN
	SELECT customerNumber, customerName, phone, addressLine1, city, postalCode, creditLimit FROM customers
		WHERE country = countryName;
	END //
DELIMITER ;

CALL CustomersFrom('FRANCE');

DROP PROCEDURE IF EXISTS ProductRatingByMSRP_top;
DELIMITER //
CREATE PROCEDURE ProductRatingByMSRP_top(IN var INT)
	BEGIN
	SELECT productCode, productName, productVendor, buyPrice, MSRP FROM products
		ORDER BY MSRP DESC
		LIMIT var;
	END //
DELIMITER ;

CALL ProductRatingByMSRP_top(5);

SELECT * FROM products;

DROP PROCEDURE IF EXISTS update_stock;
DELIMITER //
CREATE PROCEDURE update_stock(IN product_identifier VARCHAR(50), IN present_stock INT)
	BEGIN
	UPDATE products
		SET quantityInStock = present_stock
		WHERE productName = product_identifier;
	END //
DELIMITER ;

CALL update_stock('1972 Alfa Romeo GTA', 3052);

/*  The first and last DELIMITER commands are not a part of the stored procedure. The first DELIMITER command changes the default delimiter to //
	and the last DELIMITER command changes the delimiter back to the default one which is semicolon (;).
    This enables the ; delimiter used in the procedure body to be passed through to the server rather than being interpreted by mysql itself.
*/

-- Stored procedure Security
-- If the DEFINER clause is present, the user value should be a MySQL account specified as 'user_name'@'host_name', CURRENT_USER, or CURRENT_USER().
-- The permitted user values depend on the privileges you hold.

-- If the DEFINER clause is omitted, the default definer is the user who executes the CREATE PROCEDURE or CREATE FUNCTION statement.
-- This is the same as specifying DEFINER = CURRENT_USER explicitly.
DROP PROCEDURE IF EXISTS product_count;
DELIMITER //
CREATE DEFINER = 'paul'@'localhost' PROCEDURE product_count()
	BEGIN
		SELECT 'Number of products:', COUNT(*) AS ` ` FROM classicmodels.products ;
	END //
DELIMITER ;

CALL product_count();

DROP PROCEDURE IF EXISTS specific_product_count;
DELIMITER //
CREATE PROCEDURE specific_product_count (IN productCategory CHAR(20), OUT no_of_products INT)
	BEGIN
		SELECT COUNT(*) INTO no_of_products FROM products
			WHERE productLine = productCategory;
	END //
DELIMITER ;

CALL specific_product_count('Motorcycles', @no_of_products);
SELECT @no_of_products;

-- USING VARIABLES (hard coding)
SET @var_1 = 500; 
SELECT * FROM orders
	WHERE customerNumber > @var_1-200;

-- In T-SQL
-- DECLARE @variable_name {datatype} SET @variable_name = value;

-- In PL/SQL we don't use the @ sign

-- Creating variables and selecting their data values from a row in an existing table using SELECT INTO
SELECT orderNumber, customerNumber INTO @X, @Y FROM orders
	LIMIT 1;
SELECT @X, @y;

-- Using variables (user defined)- implemented by Functions
SELECT * FROM customers;

DROP FUNCTION IF EXISTS get_phone_number;
DELIMITER //
CREATE FUNCTION `get_phone_number`(customerid INT) RETURNS VARCHAR(20) DETERMINISTIC
	BEGIN
		DECLARE phone_no VARCHAR(20) ;
    
		SELECT phone INTO phone_no FROM customers
			WHERE customerNumber = customerid;
    
		RETURN phone_no;
	END //
DELIMITER ;

SELECT get_phone_number(128);

DROP FUNCTION IF EXISTS isEligible;
DELIMITER //
CREATE FUNCTION isEligible(age INTEGER) RETURNS VARCHAR(20) DETERMINISTIC
	BEGIN
	IF age > 18 THEN
		RETURN ("yes");
	ELSE
		RETURN ("No");
	END IF;
	END //
DELIMITER ;

SELECT isEligible(20);

DROP FUNCTION IF EXISTS CustomerLevel;
DELIMITER $$
CREATE FUNCTION CustomerLevel(credit DECIMAL(10,2)) RETURNS VARCHAR(20) DETERMINISTIC
	BEGIN
    DECLARE customerLevel VARCHAR(20);
	IF credit > 60000 THEN
		SET customerLevel = 'PLATINUM';
    ELSEIF (credit >= 30000 AND credit <= 60000) THEN
        SET customerLevel = 'GOLD';
    ELSEIF (credit >= 10000 AND credit < 30000) THEN
        SET customerLevel = 'SILVER';
	ELSE
		SET customerLevel = 'NOVICE';
    END IF;
	
    -- return the customer level
	RETURN (customerLevel);
	END $$
DELIMITER ;

SHOW FUNCTION STATUS WHERE db = 'classicmodels';

SELECT * FROM customers;
SELECT customerName, creditLimit, CustomerLevel(creditLimit) AS Rating FROM customers
	ORDER BY creditLimit DESC;
    
    

-- We can call a function from within a stored procedure but not vice versa
DROP PROCEDURE IF EXISTS GetCustomerLevel;
DELIMITER $$
CREATE PROCEDURE GetCustomerLevel(IN  customerNo INT, OUT customerLevel VARCHAR(20))
	BEGIN
		DECLARE credit DEC(10,2) DEFAULT 0;
    
		-- get credit limit of a customer
		SELECT creditLimit INTO credit FROM customers
			WHERE customerNumber = customerNo;
    
		-- call the function 
		SET customerLevel = CustomerLevel(credit);
	END $$
DELIMITER ;

CALL GetCustomerLevel(102, @customerLevel);
SELECT @customerLevel;

/* It’s important to notice that if a stored function contains SQL statements that query data from tables,
then you should not use it in other SQL statements; otherwise, the stored function will slow down the speed of the query.
*/

