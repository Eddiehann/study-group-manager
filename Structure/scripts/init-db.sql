-- DROP TABLE Attends CASCADE CONSTRAINTS;
-- DROP TABLE BelongsTo CASCADE CONSTRAINTS;
-- DROP TABLE Content CASCADE CONSTRAINTS;
-- DROP TABLE Contest CASCADE CONSTRAINTS;
-- DROP TABLE Institution CASCADE CONSTRAINTS;
-- DROP TABLE Location CASCADE CONSTRAINTS;
-- DROP TABLE RatingPageHasStudent CASCADE CONSTRAINTS;
-- DROP TABLE ResourceType CASCADE CONSTRAINTS;
-- DROP TABLE Review CASCADE CONSTRAINTS;
-- DROP TABLE Student CASCADE CONSTRAINTS;
-- DROP TABLE StudentGroup CASCADE CONSTRAINTS;
-- DROP TABLE StudyResource CASCADE CONSTRAINTS;
-- DROP TABLE StudySession CASCADE CONSTRAINTS;
-- DROP TABLE UniCourse_At CASCADE CONSTRAINTS;

CREATE TABLE Student (
  SID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL
);

INSERT INTO Student VALUES (1, 'Danny Lee');
INSERT INTO Student VALUES (2, 'Richard Wu');
INSERT INTO Student VALUES (3, 'Josh Kim');
INSERT INTO Student VALUES (4, 'Ken Warta');
INSERT INTO Student VALUES (5, 'Eddie Han');

CREATE TABLE RatingPageHasStudent (
  PageID INT PRIMARY KEY,
  AvgRating DECIMAL(3,2) NOT NULL,
  SID INT UNIQUE NOT NULL,
  FOREIGN KEY (SID) REFERENCES Student(SID)
);

INSERT INTO RatingPageHasStudent VALUES (201, 4.35, 1);
INSERT INTO RatingPageHasStudent VALUES (202, 3.90, 2);
INSERT INTO RatingPageHasStudent VALUES (203, 4.75, 3);
INSERT INTO RatingPageHasStudent VALUES (204, 3.20, 4);
INSERT INTO RatingPageHasStudent VALUES (205, 4.00, 5);

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

CREATE TABLE ResourceType(
  ResourceURL VARCHAR(500) PRIMARY KEY,
  FileType VARCHAR(20)
);

INSERT INTO ResourceType VALUES ('https://studyapp.com/resources/midterm_guide.pdf', 'pdf');
INSERT INTO ResourceType VALUES ('https://studyapp.com/resources/bio_ch5_notes.docx', 'docx');
INSERT INTO ResourceType VALUES ('https://studyapp.com/resources/calculus_formulas.png', 'png');
INSERT INTO ResourceType VALUES ('https://studyapp.com/resources/hamlet_summary.pdf', 'pdf');
INSERT INTO ResourceType VALUES ('https://studyapp.com/resources/physics_lab_template.docx', 'docx');

CREATE TABLE StudentGroup(
  GroupID INT PRIMARY KEY,
  GroupName VARCHAR(50)  
);

INSERT INTO StudentGroup VALUES (101, 'CPSC 304 S2025');
INSERT INTO StudentGroup VALUES (102, 'UBC BS-CS Class of 2024');
INSERT INTO StudentGroup VALUES (103, 'UBC BCS 2024 Entry Cohort');
INSERT INTO StudentGroup VALUES (104, ' CPSC 110/121/210 Study Group');
INSERT INTO StudentGroup VALUES (105, 'First Year General Sciences Group');

CREATE TABLE StudyResource(
  ResourceID INT PRIMARY KEY,
  ResourceName VARCHAR(50),
  GroupID INT,
  UploaderID INT,
  ResourceURL VARCHAR(500) NOT NULL,
  FOREIGN KEY (UploaderID) References Student(SID),
  FOREIGN KEY (GroupID) References StudentGroup(GroupID),
  FOREIGN KEY (ResourceURL) References ResourceType(ResourceURL)
); 

INSERT INTO StudyResource VALUES (100001, 'Midterm Study Guide', 101, 1, 'https://studyapp.com/resources/midterm_guide.pdf');
INSERT INTO StudyResource VALUES (100002, 'Biology Notes - Chapter 5', 102, 2, 'https://studyapp.com/resources/bio_ch5_notes.docx');
INSERT INTO StudyResource VALUES (100003, 'Calculus Formula Sheet', 101, 3, 'https://studyapp.com/resources/calculus_formulas.png');
INSERT INTO StudyResource VALUES (100004, 'Literature Summary - Hamlet', 103, 4, 'https://studyapp.com/resources/hamlet_summary.pdf');
INSERT INTO StudyResource VALUES (100005, 'Physics Lab Report Template', 103, 2, 'https://studyapp.com/resources/physics_lab_template.docx');

CREATE TABLE BelongsTo(
  GroupID INT,
  SID INT,
  PRIMARY KEY (GroupID, SID),
  FOREIGN KEY (GroupID) References StudentGroup,
  FOREIGN KEY (SID) References Student
);

INSERT INTO BelongsTo VALUES (101, 1);
INSERT INTO BelongsTo VALUES (101, 2);
INSERT INTO BelongsTo VALUES (103, 2);
INSERT INTO BelongsTo VALUES (104, 3);
INSERT INTO BelongsTo VALUES (105, 5);

-- CREATE TABLE Content(
-- 	ContentID int PRIMARY KEY,
-- 	Name varchar(20)
-- );

-- ALTER TABLE Content
-- DROP COLUMN Name;

CREATE TABLE Content(
	ContentID int PRIMARY KEY
);

-- INSERT INTO Content(ContentID, Name) VALUES (90001, 'First Year Exam Prep');
-- INSERT INTO Content(ContentID, Name) VALUES (90002, 'SQL Workshop');
-- INSERT INTO Content(ContentID, Name) VALUES (90003, 'Calculus Review');
-- INSERT INTO Content(ContentID, Name) VALUES (90004, 'Seminar Discussion');
-- INSERT INTO Content(ContentID, Name) VALUES (90005, 'Interview Prep');

INSERT INTO Content VALUES (90001);
INSERT INTO Content VALUES (90002);
INSERT INTO Content VALUES (90003);
INSERT INTO Content VALUES (90004);
INSERT INTO Content VALUES (90005);
INSERT INTO Content VALUES (90006);
INSERT INTO Content VALUES (90007);
INSERT INTO Content VALUES (90008);
INSERT INTO Content VALUES (90009);
INSERT INTO Content VALUES (90010);
INSERT INTO Content VALUES (90011);
INSERT INTO Content VALUES (90012);
INSERT INTO Content VALUES (90013);
INSERT INTO Content VALUES (90014);
INSERT INTO Content VALUES (90015);

CREATE TABLE StudySession(
  SessionID INT PRIMARY KEY,
  SessionName VARCHAR(50),
  ContentID INT,
  CreatorID INT,
  StartTime TIMESTAMP,
  EndTime TIMESTAMP,
  Location VARCHAR(50) NOT NULL,
  ZoomLink VARCHAR(100),
  GroupID INT,
  FOREIGN KEY (ContentID) References Content,
  FOREIGN KEY (CreatorID) References Student(SID),
  FOREIGN KEY (GroupID) References StudentGroup
);

INSERT INTO StudySession VALUES (201, 'Midterm Review', 90001, 1, TO_TIMESTAMP('2025-07-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-07-25 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'DMP 310', NULL, 101);
INSERT INTO StudySession VALUES (202, 'Final Exam Q/A', 90002, 1, TO_TIMESTAMP('2025-07-26 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-07-26 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Zoom', 'https://zoom.us/j/1234567890', 101);
INSERT INTO StudySession VALUES (203, 'Project Study', 90003, 2, TO_TIMESTAMP('2025-07-27 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-07-27 18:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'BIOL 1000', NULL, 101);
INSERT INTO StudySession VALUES (204, 'Webwork 07', 90004, 4, TO_TIMESTAMP('2025-07-28 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-07-28 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Zoom', 'https://zoom.us/j/9876543210', 104);
INSERT INTO StudySession VALUES (205, 'Chemistry Practice', 90005, 5, TO_TIMESTAMP('2025-07-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-07-29 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Chem Lab A', NULL, 105);


CREATE TABLE Attends (
  SessionID INT,
  ParticipantID INT,
  FOREIGN KEY (SessionID) References StudySession,
  FOREIGN KEY (ParticipantID) References Student(SID)
);

INSERT INTO Attends VALUES(201, 1);
INSERT INTO Attends VALUES(201, 1);
INSERT INTO Attends VALUES(201, 2);
INSERT INTO Attends VALUES(204, 3);
INSERT INTO Attends VALUES(205, 1);


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
    VALUES (90001, 'CPSC', '304', 'UBC', 'V6T1Z4');
INSERT INTO UniCourse_At(ContentID, Department, Course, InstitutionName, InstitutionPC)
    VALUES (90002, 'CPSC', '210', 'UBC', 'V6T1Z4');
INSERT INTO UniCourse_At(ContentID, Department, Course, InstitutionName, InstitutionPC)
    VALUES (90003, 'MATH', '200', 'UBC', 'V6T1Z4');
INSERT INTO UniCourse_At(ContentID, Department, Course, InstitutionName, InstitutionPC)
    VALUES (90004, 'WRDS', '150B', 'UBC', 'V6T1Z4');
INSERT INTO UniCourse_At(ContentID, Department, Course, InstitutionName, InstitutionPC)
    VALUES (90005, 'PHYS', '119', 'UBC', 'V6T1Z4');

CREATE TABLE Contest(
	ContentID int PRIMARY KEY,
	ContestName varchar(10),
	FOREIGN KEY (ContentID) REFERENCES Content
);

INSERT INTO Contest VALUES (90006, 'CCC');
INSERT INTO Contest VALUES (90007, 'Euclid');
INSERT INTO Contest VALUES (90008, 'SAT');
INSERT INTO Contest VALUES (90009, 'CSMC');
INSERT INTO Contest VALUES (90010, 'CIMC');

CREATE TABLE HSCourse(
	ContentID int PRIMARY KEY,
	Subject varchar(20),
	Grade int,
	FOREIGN KEY (ContentID) REFERENCES Content
);

INSERT INTO HSCourse(ContentID, Subject, Grade) VALUES (90011, 'English 12', 12);
INSERT INTO HSCourse(ContentID, Subject, Grade) VALUES (90012, 'Math 12', 12);
INSERT INTO HSCourse(ContentID, Subject, Grade) VALUES (90013, 'IB HL Math', 11);
INSERT INTO HSCourse(ContentID, Subject, Grade) VALUES (90014, 'Chemistry 10', 10);
INSERT INTO HSCourse(ContentID, Subject, Grade) VALUES (90015, 'AP Physics 1', 12);
