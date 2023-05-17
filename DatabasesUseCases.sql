-- 1. Check how many students partook in a course instance
select amount
from CourseRegistrationCount
where CourseCode = "MS-201" and CourseStartDate = '2022-09-01';

-- 2. Student 10002 checks their completed courses
SELECT courseCode, courseName, grade
FROM (GradeOf JOIN Exam on Exam.EventID = GradeOf.eventID and GradeOf.grade <> 0 AND GradeOf.StudentID = '10002') 
        JOIN Course ON Course.code = Exam.courseCode;


-- 3. Check if student is enrolled in a course instance
select Count(StudentID) 
from EnrolledIn
where courseCode = 'MS-201' and courseStartDate = '2022-09-01' and StudentID = '10003';


-- 4. Check courses that are arranged in future
select *
from Course, CourseInstance
where Course.code = CourseInstance.courseCode and courseStartDate > date();

-- 5. Get an exerciseGroup Register into it
select groupName
from ExerciseGroup
where courseCode = 'MS-201' and courseStartDate = '2023-09-01';
        
-- 5 continues... Now register for the group
Insert Into EnrolledIn Values
('10001', 'Group G', 'MS-201', '2023-09-01');

--- 6. Get all courses of a program
SELECT *
FROM Course
Where code like 'PHYS%';

-- 7. Average ECTS per year by student
Select Student.StudentID, SC.CreditSum/(((JulianDay('now')) - JulianDay(Student.enrollDate))/365.25)
from Student left outer join StudentCredits as SC on Student.StudentID = SC.StudentID;

-- 8. Find the halls with 20 computers or over
Select *
from Hall, BelongsToHall
where BelongsToHall.hallName = Hall.hallName and BelongsToHall.equipmentName = 'Computer' 
    and BelongsToHall.amount >= 20  ;

-- 9. In a given hall, all reservations in the coming month:
Select *
From Reservation
where date(Reservation.startDate) <= date(date(), '+1 month') 
    and BuildingName = 'Chemical laboratory' and hallName = 'Lecture Hall';
    
-- 10. All coming events for a student
-- Lectures
Select Event.*
from Event, (Select *
From EnrolledIn, Lecture
    Where studentID = '10002' and EnrolledIn.courseCode = Lecture.courseCode 
        and EnrolledIn.courseStartDate = Lecture.courseStartDate) as VE        
Where VE.eventID = Event.eventID and Event.eventStart >= date()       
Union
-- Exercise sessions
Select Event.*
from Event,(
    Select *
    From EnrolledIn, ExerciseSession
    Where studentID = '10002' and EnrolledIn.courseCode = ExerciseSession.courseCode 
        and EnrolledIn.courseStartDate = ExerciseSession.courseStartDate) as VE 
Where VE.eventID = Event.eventID and Event.eventStart >= date()
Union
--Exams
Select Event.*
From ExamRegistration, Event
Where ExamRegistration.studentID = '10002' And ExamRegistration.eventID = Event.eventID 
    And Event.eventStart >= date();
    
    
--    
-- 11. Canceling a course:
BEGIN TRANSACTION;

CREATE TEMPORARY TABLE eventIDs AS
    Select Event.EventID
    from Event, Lecture
    where Event.eventID = Lecture.eventID and Lecture.courseCode = 'LC-1101' 
        AND Lecture.courseStartDate = '2023-09-01'
    Union
    Select Event.EventID
    from Event, ExerciseSession
    where Event.eventID = ExerciseSession.eventID and ExerciseSession.courseCode = 'LC-1101' 
        AND ExerciseSession.courseStartDate = '2023-09-01';

Delete from Reservation
where EventID in EventIDs;

Delete from Lecture
where EventID in EventIDs;

Delete from ExerciseSession
where EventID in EventIDs;

Delete from Event
where EventID in EventIDs;

Delete From EnrolledIn
where CourseCode = 'LC-1101' and CourseStartDate = '2023-09-01';

Delete from ExerciseGroup
where CourseCode = 'LC-1101' and CourseStartDate = '2023-09-01';

Delete from CourseInstance
where CourseCode = 'LC-1101' and CourseStartDate = '2023-09-01';

DROP TABLE IF EXISTS eventIDs;
COMMIT;
--  
  
  
  
-- 12. Calculates the ratio of swedish-to-finnish exam registrations
Select Count(*)*1.0/  
(Select Count(*) --FIN  
FROM ExamRegistration  
WHERE LanguageOfChoice = 'FIN') as ratio 
from ExamRegistration  
WHERE LanguageOfChoice = 'SWE'; 

--- 13. Best students in degree programs
SELECT Student.degreeProgram, AVG(GradeOf.grade) AS Average
FROM Student LEFT OUTER JOIN GradeOf ON Student.studentID = GradeOf.studentID
WHERE Student.enrollDate > '01-01-2019' AND Student.enrollDate < '31-12-2019'
GROUP BY Student.degreeProgram
ORDER BY AVG(GradeOf.grade) DESC;

-- 14. Where and when all lectures of a course will be organized (CS-101)
SELECT Building.street,
       Building.buildingName,
       Hall.hallName,
       Reservation.startDate,
       Reservation.endDate
  FROM CourseInstance
       LEFT OUTER JOIN
       Lecture ON CourseInstance.courseStartDate = Lecture.courseStartDate AND 
                  CourseInstance.courseCode = Lecture.courseCode
       LEFT OUTER JOIN
       Reservation ON Lecture.eventID = Reservation.eventID
       LEFT OUTER JOIN
       Hall ON Hall.hallName = Reservation.hallName AND 
               Hall.buildingName = Reservation.buildingName
       LEFT OUTER JOIN
       Building ON Hall.buildingName = Building.buildingName
 WHERE Lecture.courseCode IS NOT NULL AND 
       CourseInstance.courseCode = 'CS-101' AND 
       CourseInstance.courseStartDate = '2023-09-01';

-- 15. Find buildings with more than 1000 seats
SELECT SUM(Hall.seats), Hall.buildingName
FROM Building LEFT OUTER JOIN Hall ON Building.buildingName = Hall.buildingName
GROUP BY Building.buildingName
HAVING Sum(Hall.seats) >= 1000;

-- 16. Find all exams that are scheduled to take place in a specific hall
SELECT courseCode, hallName, startDate
FROM (SELECT * FROM (Exam LEFT OUTER JOIN Reservation ON Exam.eventID = Reservation.eventID)) AS ExamsReservations 
    LEFT OUTER JOIN Hall ON ExamsReservations.hallName = Hall.hallName
WHERE startDate > '2023-06-05' AND Hall.hallName = 'Auditorium'K;

-- 17. Find the first reservation that an employee has made
SELECT employeeName, MIN(Reservation.reservationMadeDate)
FROM Employee, Reservation
WHERE Employee.employeeID = Reservation.madeBy AND Employee.employeeID = 1;
