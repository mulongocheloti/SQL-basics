/*	Question:
Consider the database consisting of the following relations:

Hotel(Hotel-No, Name, City, state, Address, Zip-code, Star)
Room(Room-No, Hotel-No, Type, Price)
Booking(Hotel-No, Guest-No, Date-From, Date-To, Room-No)
Guest(Guest-No, Name, City, Address, zip-code,)

The keys for the tables are underlined and the attributes are easy to understand. 
The table Hotel lists the hotels in the system. The attribute star of the table Hotel gives the star level of the hotel (a value between 1 and 5).
Each hotel has a certain number of rooms, and each room has a type (Room with 2 Queen Beds, Room with 1 King Bed, 
Suite with 2 Queen Beds, Suite with1 King Bed, Deluxe Suite, Villa 1 Bedroom, Villa 2 Bedrooms etc.). Each time a guest books a room, 
a tuple is inserted in the table Booking to record the reservation.
Create a database and populate it so that you get at least 1 answer for every query.
Show that you run every query against a database system for example by copying and pasting both the query and the answer returned by the database system.

Express the following in SQL

	List all the hotels in Newark
	List all the guests currently in the hotels in Newark (use today's date as reference).
	List the guests that are currently in the Robert Treat Hotel in Newark (use today's date as reference)
	List the guests that have all their bookings (past and present) in the same
	List all the rooms where to Parker stayed at the Robert Treat Hotel in Newark.
	List the guests who had an overlapping stay (in the same hotels with at least 1 overlapping day) with Parker in the year 2021.
	List the guest who never stayed in a hotel in New Jersey
	List the guests who stayed in all the hotels
    
*/

CREATE DATABASE HotelReservationDB;
USE HotelReservationDB;

CREATE TABLE Hotel( `Hotel-No` INT NOT NULL PRIMARY KEY, 
					 Name VARCHAR(20), 
                     City VARCHAR(20), 
                     State VARCHAR(20), 
                     Address VARCHAR(20), 
					`Zip-code` VARCHAR(20), 
                     Star INT CHECK (Star BETWEEN 1 AND 5)
				   );

CREATE TABLE Room(`Room-No` INT NOT NULL, 
				  `Hotel-No` INT NOT NULL, 
                   Type VARCHAR(50), 
                   Price FLOAT,
                   PRIMARY KEY(`Room-No`, `Hotel-No`),
                   CONSTRAINT fk_RoomHotelno FOREIGN KEY (`Hotel-No`) REFERENCES Hotel(`Hotel-No`)
				  );

CREATE TABLE Booking ( `Hotel-No` INT NOT NULL, 
					   `Guest-No` INT NOT NULL, 
                       `Date-From` DATE NOT NULL, 
                       `Date-To` DATE, 
                       `Room-No` INT,
                        PRIMARY KEY(`Hotel-No`, `Guest-No`, `Date-From`),
                        CONSTRAINT fk_BookingHotelno FOREIGN KEY (`Hotel-No`) REFERENCES Hotel(`Hotel-No`),
                        CONSTRAINT fk_BookingRoomno FOREIGN KEY (`Room-No`) REFERENCES Room(`Room-No`)
					  );
                      
CREATE TABLE Guest ( `Guest-No` INT NOT NULL PRIMARY KEY, 
					  Name VARCHAR(20), 
                      City VARCHAR(20), 
                      Address VARCHAR(50), 
					 `Zip-code` VARCHAR(20)
				    );
                    
INSERT INTO Hotel VALUES (567823, 'Robert Treat Hotel', 'Newark', 'New Jersey', 'Avenue B 711', '88274', 4),
						 (263748, 'Hill Crescent Hotel', 'Ridgeland', 'Mississippi', 'Badger Avenue 715', '39157', 4),
                         (478291, 'Kent Russ Hotel', 'Cleveland Heights', 'Ohio', 'Bedford Street 2653', '44112', 5),
                         (271634, 'Sabina Joy Hotel', 'Old Bridge', 'New Jersey', 'Camella court 3562','08831', 3);
                         
INSERT INTO Room VALUES (101, 567823, 'Room with 2 Queen Beds', 600.20),
						(102, 263748, 'Villa 1 Bedroom', 1050.42),
						(104, 271634, 'Room with 1 King Bed', 500.53),
						(201, 567823, 'Deluxe Suite', 960.00),
						(202, 263748, 'Suite with 2 Queen Beds', 845.28),
						(204, 271634, 'Villa 2 Bedrooms', 1200.65),
						(301, 567823, 'Suite with 2 Queen Beds', 820.56),
						(302, 263748, 'Deluxe Suite', 980.48),
						(304, 478291, 'Suite with 1 King Bed', 650.45);
                        
INSERT INTO Booking VALUES  (567823, 285940, '2021-01-30', '2021-03-16', 101),
							(567823, 285940, '2021-07-01', '2021-11-28', 201),
                            (567823, 728398, '2021-07-26', '2021-12-03', 301),
                            (567823, 285940, '2022-02-26', '2022-04-26', 201),
                            (271634, 667489, '2021-08-24', '2022-02-01', 204),
                            (567823, 367895, '2022-02-20', '2022-08-20', 301),
                            (478291, 167548, '2021-12-25', '2022-05-23', 304),
                            (263748, 102483, '2021-04-18', '2021-08-26', 202);
                            
INSERT INTO Guest VALUES (285940, 'Parker', 'Montgomery', '23 West Street', '36114'),
						 (728398, 'John Mills', 'Bettles', '467 Linstock Dr.', '99726'),
                         (667489, 'Ruth Williams', 'Springfield', '38 Horsedon Rd.', '61982'),
                         (367895, 'Sarah Decker', 'Hartford', '76 Little Grenn Estate', '06432'),
                         (167548, 'Paul Wesley', 'Denver', '28 Hense Dr.', '81263'),
                         (102483, 'Mary Trensch', 'Phoenix', 'Ranch Rd. 283', '85002');
                         

-- List all the hotels in Newark
SELECT * FROM Hotel  WHERE City = 'Newark';
    
-- List all the guests currently in the hotels in Newark (use today's date as reference).
SELECT Guest.* FROM Guest
	LEFT JOIN Booking ON Guest.`Guest-No` = Booking.`Guest-No`
    LEFT JOIN Hotel ON Booking.`Hotel-No` = Hotel.`Hotel-No`
    WHERE Hotel.City = 'Newark' AND (`Date-To` BETWEEN CURRENT_DATE AND CAST('2222-12-31' AS DATE));
    
-- List the guests that are currently in the Robert Treat Hotel in Newark (use today's date as reference)
SELECT Guest.* FROM Guest
	LEFT JOIN Booking ON Guest.`Guest-No` = Booking.`Guest-No`
    LEFT JOIN Hotel ON Booking.`Hotel-No` = Hotel.`Hotel-No`
    WHERE Hotel.Name = 'Robert Treat Hotel' AND (`Date-To` BETWEEN CURRENT_DATE AND CAST('2222-12-31' AS DATE));
    
-- List the guests that have all their bookings (past and present) in the same ..
	

-- List all the rooms where to Parker stayed at the Robert Treat Hotel in Newark.
SELECT DISTINCT `Room-No` FROM Booking
	INNER JOIN Guest ON Booking.`Guest-No` = Guest.`Guest-No`
    LEFT JOIN Hotel ON Booking.`Hotel-No` = Hotel.`Hotel-No`
    WHERE Guest.Name = 'Parker' AND Hotel.Name = 'Robert Treat Hotel';
    
-- List the guests who had an overlapping stay (in the same hotels with at least 1 overlapping day) with Parker in the year 2021.
	
    
-- List the guest who never stayed in a hotel in New Jersey
	
    
-- List the guests who stayed in all the hotels
                         
                         
                         