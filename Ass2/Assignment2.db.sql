BEGIN TRANSACTION;

/* Luee Akasha 207951773 Mohammed Oraby 208035824 */

CREATE TABLE IF NOT EXISTS "Neighborhood" (
	"NID"	INTEGER,
	"Name"	TEXT,
	PRIMARY KEY("NID")
);
CREATE TABLE IF NOT EXISTS "GarbageCollectionCompany" (
	"GCID"	INTEGER,
	"Name"	TEXT,
	PRIMARY KEY("GCID")
);
CREATE TABLE IF NOT EXISTS "Department" (
	"DID"	INTEGER,
	"Name"	TEXT,
	"Description"	TEXT,
	"ManagerID"	INTEGER,
	FOREIGN KEY("ManagerID") REFERENCES "OfficialEmployee"("EID") ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY("DID")
);
CREATE TABLE IF NOT EXISTS "Apartment" (
	"StreetName"	TEXT,
	"Door"	INTEGER,
	"Number"	INTEGER,
	"Type"	TEXT,
	"SizeSquareMeter"	FLOAT,
	"NID"	INTEGER,
	FOREIGN KEY("NID") REFERENCES "Neighborhood"("NID") ON UPDATE RESTRICT ON DELETE RESTRICT,
	PRIMARY KEY("StreetName","Number","Door"),
	CHECK("SizeSquareMeter" > 0)
);
CREATE TABLE IF NOT EXISTS "Resident" (
	"RID"	INTEGER,
	"FirstName"	TEXT,
	"LastName"	TEXT,
	"BirthDate"	TEXT,
	"StreetName"	TEXT,
	"Number"	INTEGER,
	"Door"	INTEGER,
	FOREIGN KEY("Number") REFERENCES "Apartment"("Number") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("Door") REFERENCES "Apartment"("Door") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("StreetName") REFERENCES "Apartment"("StreetName") ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY("RID")
);
CREATE TABLE IF NOT EXISTS "TrashCan" (
	"TCID"	INTEGER,
	"NID"	INTEGER,
	FOREIGN KEY("NID") REFERENCES "Neighborhood"("NID") ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY("TCID")
);
CREATE TABLE IF NOT EXISTS "ParkingArea" (
	"AID"	INTEGER,
	"Name"	TEXT,
	"MaxPricePerDay"	FLOAT,
	"PricePerHour"	FLOAT,
	"NID"	INTEGER,
	FOREIGN KEY("NID") REFERENCES "Neighborhood"("NID") ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY("AID"),
	CHECK("MaxPricePerDay" > "PricePerHour")
);
CREATE TABLE IF NOT EXISTS "Cars" (
	"CID"	INTEGER,
	"ID"	TEXT,
	"ThreeDigits"	TEXT,
	"CreditCard"	TEXT,
	"ExpirationDate"	TEXT,
	"CellPhoneNumber"	BLOB,
	FOREIGN KEY("ID") REFERENCES "Resident"("RID") ON DELETE CASCADE ON UPDATE RESTRICT,
	PRIMARY KEY("CID")
);
CREATE TABLE IF NOT EXISTS "CarParking" (
	"AID"	INTEGER,
	"CID"	INTEGER,
	"StartTime"	DATETIME,
	"EndTime"	DATETIME,
	"Cost"	FLOAT,
	FOREIGN KEY("CID") REFERENCES "Cars"("CID") ON DELETE CASCADE ON UPDATE RESTRICT,
	FOREIGN KEY("AID") REFERENCES "ParkingArea"("AID") ON DELETE SET NULL ON UPDATE CASCADE,
	PRIMARY KEY("AID","CID"),
	CHECK("EndTime" >= "StartTime")
);
CREATE TABLE IF NOT EXISTS "OfficialEmployee" (
	"Degree"	TEXT,
	"StartWorkingDate"	DATE,
	"EID"	INTEGER,
	"Department"	INTEGER,
	FOREIGN KEY("Department") REFERENCES "Department"("DID") ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY("EID") REFERENCES "Employee"("EID") ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY("EID")
);
CREATE TABLE IF NOT EXISTS "Employee" (
	"EID"	INTEGER,
	"FirstName"	TEXT,
	"LastName"	TEXT,
	"BirthDate"	TEXT,
	"City"	TEXT,
	"StreetName"	TEXT,
	"Number"	INTEGER,
	"Door"	INTEGER,
	"Department"	INTEGER,
	FOREIGN KEY("Department") REFERENCES "Department"("DID") ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY("EID")
);
CREATE TABLE IF NOT EXISTS "Project" (
	"PID"	INTEGER,
	"Name"	TEXT,
	"Description"	TEXT,
	"Budget"	FLOAT,
	"NID"	INTEGER,
	FOREIGN KEY("NID") REFERENCES "Neighborhood"("NID") ON DELETE RESTRICT ON UPDATE RESTRICT,
	PRIMARY KEY("PID")
);
CREATE TABLE IF NOT EXISTS "GarbageCollection" (
	"TCID"	INTEGER,
	"StartTime"	DATETIME,
	"EndTime"	DATETIME,
	"GCID"	INTEGER,
	FOREIGN KEY("TCID") REFERENCES "TrashCan"("TCID") ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY("GCID") REFERENCES "GarbageCollectionCompany"("GCID") ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY("TCID","StartTime","GCID"),
	CHECK("EndTime" >= "StartTime")
);
CREATE TABLE IF NOT EXISTS "CellPhone" (
	"EID"	INTEGER,
	"Number"	BLOB,
	FOREIGN KEY("EID") REFERENCES "Employee"("EID") ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY("EID","Number")
);
CREATE TABLE IF NOT EXISTS "ConstructorEmployee" (
	"EID"	INTEGER,
	"CompanyName"	TEXT,
	"SalaryPerDay"	FLOAT,
	FOREIGN KEY("EID") REFERENCES "Employee"("EID") ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY("EID")
);
CREATE TABLE IF NOT EXISTS "ProjectConstructorEmployee" (
	"StartWorkingDate"	DATE,
	"JobDescription"	INTEGER,
	"EndWorkingDate"	DATE,
	"PID"	INTEGER,
	"EID"	INTEGER,
	FOREIGN KEY("EID") REFERENCES "ConstructorEmployee"("EID") ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY("PID") REFERENCES "Project"("PID") ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY("EID","PID"),
	CHECK("EndWorkingDate" > "StartWorkingDate")
);