/* 1.	Using the Sales Orders database: How much Retail value do we have currently on hand for 
	each of our products? Show a list of products including the product name, current retail price,
	quantity on hand and a new column showing the total retail value on hand for that product 
	rounded off to the nearest whole dollar (i.e. a data type with 15 total places but 0 decimal places). 
	Name the new column "TotalRetail." (40 rows)
*/

USE SalesOrdersDatabase;
SELECT ProductName, RetailPrice, QuantityOnHand, CAST(QuantityOrdered*RetailPrice AS decimal(15,0)) AS TotalRetail FROM Products
    INNER JOIN Order_Details ON Products.ProductNumber = Order_Details.ProductNumber
    LIMIT 40;
    

/* 2.	Using the Bowling League database: We're updating our bowler membership records and noticed that
	some bowling centers did not collect bowlers' middle initials on the registration form. Provide a 
	list of the cities that have bowlers without middle initials in our database. We do not need the 
	bowlers' information; just the city names. Each city should be listed only once. Sort the list of cities in alphabetical order. (8 rows)
*/

USE BowlingLeagueDatabase;
SELECT DISTINCT BowlerCity FROM Bowlers
	WHERE BowlerMiddleInit IS NULL
	ORDER BY BowlerCity ASC
	LIMIT 8;


/* 3.	Using the School Scheduling database: Provide a list of the classroom ID numbers (as "Room"), 
	capacities and building names (NOT codes) that are either in the Instructional Building and hold 
	at least 50 students or that are in the College Center and hold at least 70 students. 
	Show the results in order by building name and then room capacity with the largest rooms first. (15 rows)
*/

USE SchoolSchedulingDatabase;
SELECT ClassRoomID AS Room, Capacity, BuldingName FROM Class_Rooms
	INNER JOIN Buildings ON Class_Rooms.BuildingCode = Buildings.BuildingCode
    	WHERE (BuidingName="Instructional Building" AND Capacity >= 50) OR (BuidingName="College Center" AND Capacity >= 70)
    	ORDER BY BuildingName, Capacity DESC
    	LIMIT 15;


/* 4.	From the Entertainment Agency database: Provide a list of all agent full names (as "AgentName") and 
	the engagement dates they booked (start and end) for any engagements that took place at least partially 
	during the month of January 2018, sorted by the booking start dates. Remember to include the engagements 
	that may have started before January or ended after it as long as at least part of the engagement was in January 2018. (34 rows)
*/

USE EntertainmentAgencyDatabase;
SELECT CONCAT(AgtFirstName," ",AgtLastName) AS AgentName, StartDate, EndDate FROM Engagements
	INNER JOIN Agents
    	ON Engagements.AgentID = Agents.AgentID
    	WHERE (YEAR(StartDate)=2018 AND YEAR(EndDate)=2018) AND (MONTH(StartDate)=1 OR MONTH(EndDate)=1)
    	ORDER BY StartDate
    	LIMIT 34;
