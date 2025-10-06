SET DEFINE OFF;

CREATE TABLE Student (
  SID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL
);

INSERT INTO Student VALUES (1, 'Danny Lee');
INSERT INTO Student VALUES (2, 'Richard Wu');
INSERT INTO Student VALUES (3, 'Josh Kim');
INSERT INTO Student VALUES (4, 'Ken Warta');
INSERT INTO Student VALUES (5, 'Eddie Han');

CREATE TABLE Review (
  ReviewID INT,
  Rating INT NOT NULL,
  PageID INT NOT NULL,
  SID INT NOT NULL,
  PRIMARY KEY (ReviewID, PageID),
  FOREIGN KEY (PageID) REFERENCES RatingPageHasStudent(PageID),
  FOREIGN KEY (SID) REFERENCES RatingPageHasStudent(SID)
);

INSERT INTO Review VALUES (1, 5, 201, 1);
INSERT INTO Review VALUES (2, 4, 202, 2);
INSERT INTO Review VALUES (3, 5, 203, 3);
INSERT INTO Review VALUES (4, 3, 204, 4);
INSERT INTO Review VALUES (5, 4, 205, 5);


CREATE TABLE RatingPageHasStudent (
  PageID INT PRIMARY KEY,
  AvgRating DECIMAL(4,2) NOT NULL,
  SID INT UNIQUE NOT NULL,
  FOREIGN KEY (SID) REFERENCES Student(SID)
);

INSERT INTO RatingPageHasStudent VALUES (201, 4.35, 1);
INSERT INTO RatingPageHasStudent VALUES (202, 3.90, 2);
INSERT INTO RatingPageHasStudent VALUES (203, 4.75, 3);
INSERT INTO RatingPageHasStudent VALUES (204, 3.20, 4);
INSERT INTO RatingPageHasStudent VALUES (205, 4.00, 5);

CREATE TABLE ResourceType(
  ResourceURL TEXT PRIMARY KEY,
  FileType VARCHAR(20)
);

INSERT INTO ResourceType VALUES ('https://studyapp.com/resources/midterm_guide.pdf', 'pdf');
INSERT INTO ResourceType VALUES ('https://studyapp.com/resources/bio_ch5_notes.docx', 'docx');
INSERT INTO ResourceType VALUES ('https://studyapp.com/resources/calculus_formulas.png', 'png');
INSERT INTO ResourceType VALUES ('https://studyapp.com/resources/hamlet_summary.pdf', 'pdf');
INSERT INTO ResourceType VALUES ('https://studyapp.com/resources/physics_lab_template.docx', 'docx');

CREATE TABLE Group(
  GroupID INT PRIMARY KEY,
  GroupName VARCHAR(50)  
);

INSERT INTO Group VALUES (101, 'CPSC 304 S2025');
INSERT INTO Group VALUES (102, 'UBC BS-CS Class of 2024');
INSERT INTO Group VALUES (103, 'UBC BCS 2024 Entry Cohort');
INSERT INTO Group VALUES (104, ' CPSC 110/121/210 Study Group');
INSERT INTO Group VALUES (105, 'First Year General Sciences Group');

CREATE TABLE Resource(
  ResourceID INT PRIMARY KEY,
  ResourceName VARCHAR(50),
  GroupID INT,
  UploaderID INT,
  ResourceURL TEXT NOT NULL,
  FOREIGN KEY (UploaderID) References Student(SID),
  FOREIGN KEY (GroupID) References Group,
  FOREIGN KEY (ResourceURL) References ResourceType
); 

INSERT INTO Resource VALUES (1, 'Midterm Study Guide', 101, 1001, 'https://studyapp.com/resources/midterm_guide.pdf');
INSERT INTO Resource VALUES (2, 'Biology Notes - Chapter 5', 102, 1002, 'https://studyapp.com/resources/bio_ch5_notes.docx');
INSERT INTO Resource VALUES (3, 'Calculus Formula Sheet', 101, 1003, 'https://studyapp.com/resources/calculus_formulas.png');
INSERT INTO Resource VALUES (4, 'Literature Summary - Hamlet', NULL, 1004, 'https://studyapp.com/resources/hamlet_summary.pdf');
INSERT INTO Resource VALUES (5, 'Physics Lab Report Template', 103, 1002, 'https://studyapp.com/resources/physics_lab_template.docx');

CREATE TABLE BelongsTo(
  GroupID INT,
  SID INT,
  PRIMARY KEY (GroupID, SID),
  FOREIGN KEY (GroupID) References Group,
  FOREIGN KEY (SID) References Student
);

INSERT INTO BelongsTo VALUES (101, 1);
INSERT INTO BelongsTo VALUES (101, 2);
INSERT INTO BelongsTo VALUES (103, 2);
INSERT INTO BelongsTo VALUES (104, 3);
INSERT INTO BelongsTo VALUES (105, 5);

CREATE TABLE Session (
  SessionID INT PRIMARY KEY,
  SessionName VARCHAR(50),
  ContentID INT,
  CreatorID INT,
  StartTime TIMESTAMP,
  EndTime TIMESTAMP,
  Location VARCHAR(50) NOT NULL,
  ZoomLink TEXT,
  GroupID INT,
  FOREIGN KEY (ContentID) References Content,
  FOREIGN KEY (CreatorID) References Student(SID),
  FOREIGN KEY (GroupID) References Group
);

INSERT INTO Session VALUES (201, 'Midterm Review', 10001, 1, '2025-07-25 18:00:00', '2025-07-25 20:00:00', 'DMP 310', NULL, 101);
INSERT INTO Session VALUES (202, 'Final Exam Q&A', 10002, 1, '2025-07-26 14:00:00', '2025-07-26 15:30:00', 'Zoom', 'https://zoom.us/j/1234567890', 101);
INSERT INTO Session VALUES (203, 'Project Study', 10003, 2, '2025-07-27 17:00:00', '2025-07-27 18:30:00', 'BIOL 1000', NULL, 101);
INSERT INTO Session VALUES (204, 'Webwork 07', 10004, 4, '2025-07-28 16:00:00', '2025-07-28 17:30:00', 'Zoom', 'https://zoom.us/j/9876543210', 104);
INSERT INTO Session VALUES (205, 'Chemistry Practice', 10005, 5, '2025-07-29 10:00:00', '2025-07-29 11:30:00', 'Chem Lab A', NULL, 105);

CREATE TABLE Attends (
  SessionID INT,
  ParticipantID INT,
  FOREIGN KEY (SessionID) References Session,
  FOREIGN KEY (ParticipantID) References Student(SID)
);

INSERT INTO Attends VALUES(201, 1);
INSERT INTO Attends VALUES(201, 1);
INSERT INTO Attends VALUES(201, 2);
INSERT INTO Attends VALUES(204, 3);
INSERT INTO Attends VALUES(205, 1);

CREATE TABLE Content(
	ContentID int PRIMARY KEY,
	Name varchar(20)
);

INSERT INTO Content(ContentID, Name) VALUES (90001, 'First Year Exam Prep');
INSERT INTO Content(ContentID, Name) VALUES (90002, 'SQL Workshop');
INSERT INTO Content(ContentID, Name) VALUES (90003, 'Calculus Review');
INSERT INTO Content(ContentID, Name) VALUES (90004, 'Seminar Discussion');
INSERT INTO Content(ContentID, Name) VALUES (90005, 'Interview Prep');

CREATE TABLE UniCourse_At(
	ContentID int PRIMARY KEY,
	Department varchar(10),
	Course varchar(10),
	InstitutionName varchar(30) Not Null,
	InstitutionPC varchar(10) Not Null,
	FOREIGN KEY (ContentID) REFERENCES Content,
	FOREIGN KEY (InstitutionName, InstitutionPC) REFERENCES Institution(Name, PostalCode)
);

INSERT INTO UniCourse_At(ContentID, Department, Course, InstitutionName, InstitutionPC)
    VALUES (10001, 'CPSC', '304', 'UBC', 'V6T1Z4');
INSERT INTO UniCourse_At(ContentID, Department, Course, InstitutionName, InstitutionPC)
    VALUES (10002, 'CPSC', '210', 'UBC', 'V6T1Z4');
INSERT INTO UniCourse_At(ContentID, Department, Course, InstitutionName, InstitutionPC)
    VALUES (10003, 'MATH', '200', 'UBC', 'V6T1Z4');
INSERT INTO UniCourse_At(ContentID, Department, Course, InstitutionName, InstitutionPC)
    VALUES (10004, 'WRDS', '150B', 'UBC', 'V6T1Z4');
INSERT INTO UniCourse_At(ContentID, Department, Course, InstitutionName, InstitutionPC)
    VALUES (10005, 'PHYS', '119', 'UBC', 'V6T1Z4');

CREATE TABLE Contest(
	ContentID int PRIMARY KEY,
	Level varchar(10),
	FOREIGN KEY (ContentID) REFERENCES Content
);

INSERT INTO Contest(ContentID, Level) VALUES (20001, 'CCC');
INSERT INTO Contest(ContentID, Level) VALUES (20002, 'Euclid');
INSERT INTO Contest(ContentID, Level) VALUES (20003, 'SAT');
INSERT INTO Contest(ContentID, Level) VALUES (20004, 'CSMC');
INSERT INTO Contest(ContentID, Level) VALUES (20005, 'CIMC');

CREATE TABLE HSCourse(
	ContentID int PRIMARY KEY,
	Subject varchar(20),
	Grade int,
	FOREIGN KEY (ContentID) REFERENCES Content
);

INSERT INTO HSCourse(ContentID, Subject, Grade) VALUES (30001, 'English 12', 12);
INSERT INTO HSCourse(ContentID, Subject, Grade) VALUES (30002, 'Math 12', 12);
INSERT INTO HSCourse(ContentID, Subject, Grade) VALUES (30003, 'IB HL Math', 11);
INSERT INTO HSCourse(ContentID, Subject, Grade) VALUES (30004, 'Chemistry 10', 10);
INSERT INTO HSCourse(ContentID, Subject, Grade) VALUES (30005, 'AP Physics 1', 12);

CREATE TABLE Institution(
	Name varchar(30),
	PostalCode varchar(10),
	PRIMARY KEY (Name, PostalCode),
	FOREIGN KEY (PostalCode) REFERENCES Location
);

INSERT INTO Institution(Name, PostalCode) VALUES ('UBC', 'V6T1Z4');
INSERT INTO Institution(Name, PostalCode) VALUES ('UofT', 'M5S1A1');
INSERT INTO Institution(Name, PostalCode) VALUES ('UWaterloo', 'N2L3G1');
INSERT INTO Institution(Name, PostalCode) VALUES ('SFU', 'V5A1S6');
INSERT INTO Institution(Name, PostalCode) VALUES ('McMaster', 'L8S4L8');

CREATE TABLE Location(
	PostalCode varchar(10) PRIMARY KEY,
	City varchar(20),
	Province varchar(20)
);

INSERT INTO Location(PostalCode, City, Province) VALUES ('V6T1Z4', 'Vancouver', 'BC');
INSERT INTO Location(PostalCode, City, Province) VALUES ('M5S1A1', 'Mississauga', 'ON');
INSERT INTO Location(PostalCode, City, Province) VALUES ('N2L3G1', 'Waterloo', 'ON');
INSERT INTO Location(PostalCode, City, Province) VALUES ('V5A1S6', 'Vancouver', 'BC');
INSERT INTO Location(PostalCode, City, Province) VALUES ('L8S4L8', 'Hamilton', 'ON');


