CREATE TABLE Employee (
    employeeID        INTEGER,
    jobTitle          TEXT,
    employeeName      TEXT,
    address           TEXT,
    phone             VARCHAR (15),
    startOfEmployment DATE,
    endOfEmployment   DATE,
    PRIMARY KEY (
        employeeID
    )
);

CREATE TABLE Building (
    buildingName TEXT PRIMARY KEY,
    street       TEXT
);


CREATE TABLE Hall (
    hallName     TEXT,
    buildingName TEXT,
    seats        INTEGER,
    maxExaminees INTEGER,
    PRIMARY KEY (
        hallName,
        buildingName
    ),
    FOREIGN KEY (
        buildingName
    )
    REFERENCES Building (buildingName) 
);



CREATE TABLE Equipment (
    equipmentName TEXT,
    PRIMARY KEY (
        equipmentName
    )
);

CREATE TABLE BelongsToHall (
    equipmentName TEXT,
    hallName      TEXT,
    buildingName  TEXT,
    amount        INTEGER,
    PRIMARY KEY (
        equipmentName,
        hallName,
        buildingName
    ),
    FOREIGN KEY (
        equipmentName
    )
    REFERENCES Equipment (equipmentName),
    FOREIGN KEY (
        hallName,
        buildingName
    )
    REFERENCES Hall (hallName,
    buildingName) 
);

CREATE TABLE Reservation (
    reservationID       INTEGER,
    eventID             INTEGER,
    startDate           TEXT,
    endDate             TEXT,
    reservationMadeDate TEXT,
    buildingName        TEXT,
    hallName            TEXT,
    madeBy              INTEGER,
    PRIMARY KEY (
        reservationID,
        eventID
    ),
    FOREIGN KEY (
        hallName,
        buildingName
    )
    REFERENCES Hall (hallName,
    buildingName),
    FOREIGN KEY (
        madeBy
    )
    REFERENCES Employee (employeeID),
    FOREIGN KEY (
        eventID
    )
    REFERENCES Event (eventID) 
);

CREATE TABLE Event (
    eventID    INTEGER,
    eventStart TEXT CHECK (eventStart < eventEnd),
    eventEnd   TEXT,
    PRIMARY KEY (
        eventID
    )
);

CREATE TABLE Course (
    code       VARCHAR (10),
    courseName TEXT,
    credits    INTEGER,
    PRIMARY KEY (
        code
    )
);

CREATE TABLE CourseInstance (
    courseStartDate DATE,
    courseCode      VARCHAR (10),
    PRIMARY KEY (
        courseStartDate,
        courseCode
    ),
    FOREIGN KEY (
        courseCode
    )
    REFERENCES Course (code) 
);



CREATE TABLE ExerciseGroup (
    courseCode      VARCHAR (10),
    courseStartDate DATE,
    groupName       TEXT,
    maxAttendees    INTEGER,
    PRIMARY KEY (
        courseCode,
        courseStartDate,
        groupName
    ),
    FOREIGN KEY (
        courseCode,
        courseStartDate
    )
    REFERENCES CourseInstance (courseCode,
    courseStartDate) 
);

CREATE TABLE Lecture (
    eventID         INTEGER,
    courseCode      VARCHAR (10),
    courseStartDate DATE,
    PRIMARY KEY (
        eventID
    ),
    FOREIGN KEY (
        courseCode,
        courseStartDate
    )
    REFERENCES CourseInstance (courseCode,
    courseStartDate),
    FOREIGN KEY (
        eventID
    )
    REFERENCES Event (eventID) 
);



CREATE TABLE ExerciseSession (
    eventID         INTEGER,
    groupName       TEXT,
    courseCode      VARCHAR (10),
    courseStartDate DATE,
    PRIMARY KEY (
        eventID
    ),
    FOREIGN KEY (
        eventID
    )
    REFERENCES Event (eventID),
    FOREIGN KEY (
        groupName,
        courseCode,
        courseStartDate
    )
    REFERENCES ExerciseGroup (groupName,
    courseCode,
    courseStartDate) 
);


CREATE TABLE Exam (
    eventID    INTEGER,
    courseCode VARCHAR (10),
    PRIMARY KEY (
        eventID
    ),
    FOREIGN KEY (
        eventID
    )
    REFERENCES Event (eventID),
    FOREIGN KEY (
        courseCode
    )
    REFERENCES Course (code) 
);

CREATE TABLE Student (
    studentID     VARCHAR (10),
    studentName   TEXT,
    birthDate     DATE,
    degreeProgram TEXT,
    enrollDate    DATE,
    studyEndDate  DATE,
    PRIMARY KEY (
        studentID
    )
);

CREATE TABLE GradeOf (
    studentID VARCHAR (10),
    eventID   INTEGER,
    grade     INTEGER CHECK (grade >=0 AND grade <= 5),
    PRIMARY KEY (
        studentID,
        eventID
    ),
    FOREIGN KEY (
        studentID
    )
    REFERENCES Student (studentID),
    FOREIGN KEY (
        eventID
    )
    REFERENCES Exam (eventID) 
);

CREATE TABLE ExamRegistration (
    studentID        VARCHAR (10),
    eventID          INTEGER,
    registrationDate DATE,
    languageOfChoice CHAR (3),
    PRIMARY KEY (
        studentID,
        eventID
    ),
    FOREIGN KEY (
        studentID
    )
    REFERENCES Student (studentID),
    FOREIGN KEY (
        eventID
    )
    REFERENCES Exam (eventID) 
);

CREATE TABLE ExercisePoints (
    studentID       VARCHAR (10),
    courseCode      VARCHAR (20),
    courseStartDate DATE,
    points          INTEGER,
    PRIMARY KEY (
        studentID,
        courseCode,
        courseStartDate
    ),
    FOREIGN KEY (
        studentID
    )
    REFERENCES Student (studentID),
    FOREIGN KEY (
        courseCode,
        courseStartDate
    )
    REFERENCES CourseInstance (courseCode,
    courseStartDate) 
);

CREATE TABLE EnrolledIn (
    studentID         VARCHAR (10),
    exerciseGroupName TEXT,
    courseCode        VARCHAR (20),
    courseStartDate   DATE,
    PRIMARY KEY (
        studentID,
        exerciseGroupName,
        courseCode,
        courseStartDate
    ),
    FOREIGN KEY (
        studentID
    )
    REFERENCES Student (studentID),
    FOREIGN KEY (
        exerciseGroupName,
        courseCode,
        courseStartDate
    )
    REFERENCES ExerciseGroup (groupName,
    courseCode,
    courseStartDate) 
);

-- Indexes 
CREATE INDEX SeatsIndex on Hall(seats);
CREATE INDEX HallBuildingNameIndex ON Reservation(hallName, buildingName);
CREATE INDEX CourseInfoIndex ON Lecture(courseCode, courseStartDate);

-- !!!!!!! TODO: This is here twice??
--CREATE INDEX CourseInfoIndex ON ExerciseSession(courseCode, courseStartDate);

--Insert example data
INSERT INTO Student (studentID, studentName, birthDate, degreeProgram, enrollDate, studyEndDate) VALUES
    ('10001', 'Alice Johnson', '2001-05-03', 'Computer Science', '2019-09-01', '2023-06-01'),
    ('10002', 'Bob Smith', '2000-12-15', 'Mathematics', '2018-09-01', '2022-06-01'),
    ('10003', 'Charlie Brown', '2002-02-21', 'Physics', '2020-09-01', '2024-06-01'),
    ('10004', 'Diana Rodriguez', '2001-09-10', 'Chemical Engineering', '2019-09-01', '2023-06-01'),
    ('10005', 'Emily Wilson', '2000-07-07', 'Computer Science', '2018-09-01', '2022-06-01');

INSERT INTO Employee VALUES 
    (1, 'Cleaner', 'Sirkka Siivooja', 'Esimerkkikatu 3, 02200 Espoo', '+358111111111', '2022-01-01', '2024-01-01'),
    (2, 'Professor', 'Petri Professori', 'Esimkuja 69, 05500 Helsinki', '+35822222222', '2021-01-01', '2025-01-01'),
    (3, 'Principal', 'Reijo Rehtori', 'Jokukatu 42, 04200 Kirkkonummi', '+358123456789', '2020-05-01', '2025-10-19');
    
INSERT INTO Course (code, courseName, credits) VALUES 
    ('CS-101', 'Introduction to Computer Science', 4),
    ('MS-201', 'Calculus II', 5),
    ('PHYS-101', 'Mechanics', 5),
    ('CHEM-201', 'Organic Chemistry', 3),
    ('LC-1101', 'English Composition', 3);
    
INSERT INTO Building (buildingName, street) VALUES
    ('Computer Science building', 'Tietotie 5'),
    ('IEM building', 'Tuotantotalouskuja 22'),
    ('Chemical laboratory', 'Labrakuja 69');

INSERT INTO Event (eventID, eventStart, eventEnd) VALUES
    (1, '2023-06-01 09:00:00', '2023-06-01 11:00:00'),
    (2, '2023-06-01 13:00:00', '2023-06-01 15:00:00'),
    (3, '2023-06-02 10:00:00', '2023-06-02 12:00:00'),
    (4, '2023-06-02 14:00:00', '2023-06-02 16:00:00'),
    (5, '2023-06-03 08:00:00', '2023-06-03 10:00:00'),
    (6, '2023-06-03 12:00:00', '2023-06-03 14:00:00'),
    (7, '2023-06-04 11:00:00', '2023-06-04 13:00:00'),
    (8, '2023-06-04 15:00:00', '2023-06-04 17:00:00'),
    (9, '2023-06-05 10:00:00', '2023-06-05 12:00:00'),
    (10, '2023-06-05 14:00:00', '2023-06-05 16:00:00');

INSERT INTO Equipment (equipmentName) VALUES
    ('Microscope'),
    ('Projector'),
    ('Computer');
    
INSERT INTO CourseInstance (courseStartDate, courseCode) VALUES 
    ('2022-09-01', 'CS-101'),
    ('2022-09-01', 'MS-201'),
    ('2022-09-01', 'PHYS-101'),
    ('2023-01-09', 'CHEM-201'),
    ('2023-01-09', 'LC-1101'),
    ('2023-09-01', 'CS-101'),
    ('2023-09-01', 'MS-201');
    
INSERT INTO ExerciseGroup (courseStartDate, courseCode, groupName, maxAttendees) VALUES 
    ('2022-09-01', 'CS-101', 'Group A', 50),
    ('2022-09-01', 'MS-201', 'Group B', 50),
    ('2022-09-01', 'PHYS-101', 'Group C', 50),
    ('2023-01-09', 'CHEM-201', 'Group D', 50),
    ('2023-01-09', 'LC-1101', 'Group E', 50),
    ('2023-09-01', 'CS-101', 'Group F', 50),
    ('2023-09-01', 'MS-201', 'Group G', 50);
    
INSERT INTO Hall (hallName, buildingName, seats, maxExaminees) VALUES
    ('Auditorium', 'Computer Science building', 500, 250),
    ('Grand Hall', 'Computer Science building', 1000, 500),
    ('Conference Room', 'Computer Science building', 50, 30),
    ('Lecture Hall', 'Chemical laboratory', 500, 250),
    ('Cafeteria', 'Chemical laboratory', 1000, 500),
    ('Laboratory 1', 'Chemical laboratory', 500, 250),
    ('Guild room', 'IEM building', 1000, 500);
    
INSERT INTO BelongsToHall (equipmentName, hallName, buildingName, amount) VALUES
    ('Microscope', 'Laboratory 1', 'Chemical laboratory', 20),
    ('Projector', 'Auditorium', 'Computer Science building', 2),
    ('Projector', 'Grand Hall', 'Computer Science building', 4),
    ('Projector', 'Conference Room', 'Computer Science building', 1),
    ('Computer', 'Lecture Hall', 'Chemical laboratory', 50),
    ('Computer', 'Guild room', 'IEM building', 30);


INSERT INTO Exam (eventID, courseCode) VALUES
    (8, 'CS-101'),
    (9, 'MS-201'),
    (10, 'PHYS-101');

INSERT INTO ExamRegistration (studentID, eventID, registrationDate, languageOfChoice)
VALUES
    ('10004', 8, '2023-05-01', 'ENG'),
    ('10004', 9, '2023-05-02', 'FRA'),
    ('10005', 10, '2023-05-03', 'FIN'),
    ('10002', 10, '2023-05-03', 'FIN'),
    ('10001', 10, '2023-05-03', 'SWE');

INSERT INTO ExercisePoints (studentID, courseCode, courseStartDate, points)
VALUES 
    ('10001', 'CS-101', '2022-09-01', 80),
    ('10001', 'MS-201', '2022-09-01', 75),
    ('10002', 'LC-1101', '2023-01-09', 90),
    ('10003', 'PHYS-101', '2022-09-01', 85),
    ('10003', 'CHEM-201', '2023-01-09', 70);

INSERT INTO GradeOf (studentID, eventID, grade) VALUES 
    ('10001', 8, 5),
    ('10002', 9, 4),
    ('10002', 8, 0),
    ('10003', 9, 5),
    ('10001', 10, 4);

INSERT INTO EnrolledIn (studentID, exerciseGroupName, courseCode, courseStartDate)
VALUES 
    ('10001', 'Group A', 'CS-101', '2022-09-01'),
    ('10001', 'Group B', 'MS-201', '2022-09-01'),
    ('10002', 'Group A', 'CS-101', '2022-09-01'),
    ('10002', 'Group C', 'PHYS-101', '2022-09-01'),
    ('10003', 'Group B', 'MS-201', '2022-09-01');
    

INSERT INTO ExerciseSession (eventID, courseStartDate, courseCode, groupName) VALUES
    (6, '2022-09-01', 'MS-201', 'Group B'),
    (7, '2023-01-09', 'CHEM-201', 'Group D'),
    (5, '2022-09-01', 'CS-101', 'Group A');
    
INSERT INTO Reservation (reservationID, eventID, startDate, endDate, reservationMadeDate, buildingName, hallName, madeBy) VALUES
    (1, 1, '2023-06-01 09:00:00', '2023-06-01 11:00:00', '2023-05-30 14:00:00', 'Computer Science building', 'Auditorium', 1),
    (2, 2, '2023-06-01 13:00:00', '2023-06-01 15:00:00', '2023-05-30 16:00:00', 'Computer Science building', 'Grand Hall', 1),
    (3, 3, '2023-06-02 10:00:00', '2023-06-02 12:00:00', '2023-05-31 10:00:00', 'Chemical laboratory', 'Lecture Hall', 1),
    (4, 4, '2023-06-02 14:00:00', '2023-06-02 16:00:00', '2023-05-31 14:00:00', 'Chemical laboratory', 'Cafeteria', 2),
    (5, 5, '2023-06-03 08:00:00', '2023-06-03 10:00:00', '2023-06-01 11:00:00', 'Computer Science building', 'Conference Room', 2),
    (6, 6, '2023-06-03 12:00:00', '2023-06-03 14:00:00', '2023-06-01 15:00:00', 'Chemical laboratory', 'Laboratory 1', 2),
    (7, 7, '2023-06-04 11:00:00', '2023-06-04 13:00:00', '2023-06-02 09:00:00', 'IEM building', 'Guild room', 2),
    (8, 8, '2023-06-04 15:00:00', '2023-06-04 17:00:00', '2023-06-02 14:00:00', 'Computer Science building', 'Grand Hall', 2),
    (9, 9, '2023-06-05 10:00:00', '2023-06-05 12:00:00', '2023-06-03 11:00:00', 'Chemical laboratory', 'Lecture Hall', 2),
    (10, 10, '2023-06-05 14:00:00', '2023-06-05 16:00:00', '2023-06-03 15:00:00', 'Computer Science building', 'Auditorium', 3);
    
INSERT INTO Lecture (eventID, courseCode, courseStartDate) VALUES
    (4, 'CHEM-201', '2023-01-09'),
    (1, 'CS-101', '2023-09-01'),
    (2, 'MS-201', '2023-09-01'),
    (3, 'PHYS-101', '2022-09-01');
    
-- Views
--DROP VIEW StudentCredits;
-- ECTs by student
CREATE VIEW StudentCredits AS
SELECT Student.studentID, SUM(credits)
      FROM ((GradeOf LEFT OUTER JOIN Student ON Student.studentID = GradeOf.studentID) 
          JOIN Exam on Exam.EventID = GradeOf.eventID and GradeOf.grade <> 0) LEFT OUTER JOIN Course ON Course.code = Exam.courseCode
      GROUP BY Student.studentID;

