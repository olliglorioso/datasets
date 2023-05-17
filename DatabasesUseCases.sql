-- Student 10002 checks their completed courses
SELECT courseCode, courseName, grade
FROM ((GradeOf LEFT OUTER JOIN Student ON Student.studentID = GradeOf.studentID) 
    JOIN Exam on Exam.EventID = GradeOf.eventID and GradeOf.grade <> 0 AND GradeOf.StudentID = '10002') 
        LEFT OUTER JOIN Course ON Course.code = Exam.courseCode;

-- Check how many students partook in a course instance
select amount
from CourseRegistrationCount
where CourseCode = "MS-201" and CourseStartDate = '2022-09-01'

-- 2. Check if student is enrolled in a course instance
select Count(StudentID) 
from ExerciseGroup, EnrolledIn
where ExerciseGroup.courseCode = 'MS-201' and 
    ExerciseGroup.courseStartDate = '2022-09-01' and StudentID = '10003' and groupName = exerciseGroupName;

-- 3. Check courses that are arranged in future
select *
from Course, CourseInstance
where Course.code = CourseInstance.courseCode and courseStartDate > date();

-- 4. Get an exerciseGroup Register into it
select groupName
from ExerciseGroup, CourseInstance
where ExerciseGroup.courseCode = CourseInstance.courseCode and 
    ExerciseGroup.courseStartDate = CourseInstance.courseStartDate and 
        CourseInstance.courseCode = 'MS-201' and CourseInstance.courseStartDate = '2023-09-01';
        
-- ... Now register for the group
Insert Into EnrolledIn Values
('10001', 'Group G', 'MS-201', '2023-09-01');

-- Average ECTS per year by student
Select Student.StudentID, SC.CreditSum/(((JulianDay('now')) - JulianDay(Student.enrollDate))/365.25)
from Student left outer join StudentCredits as SC on Student.StudentID = SC.StudentID

-- Find the halls with 20 computers or over
Select *
from Hall, BelongsToHall
where BelongsToHall.hallName = Hall.hallName and BelongsToHall.equipmentName = 'Computer' 
    and BelongsToHall.amount >= 20  

-- In a given hall, all reservations in the coming month:
Select *
From Reservation
where date(Reservation.startDate) <= date(date(), '+1 month') 
    and BuildingName = 'Chemical laboratory' and hallName = 'Lecture Hall';
    
-- All coming events for a student
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
    
    
-- Calculates the ratio of swedish-to-finnish exam registrations
Select Count(*)*1.0/
    (Select Count(*)    --FIN
        from ExamRegistration
        Group by LanguageOfChoice 
        Having LanguageOfChoice = 'FIN') as ratio
from ExamRegistration
Group by LanguageOfChoice 
Having LanguageOfChoice = 'SWE';    --SWE

--- Best students in degree programs
SELECT Student.degreeProgram, AVG(GradeOf.grade) AS Average
FROM Student LEFT OUTER JOIN GradeOf ON Student.studentID = GradeOf.studentID
WHERE Student.enrollDate > '01-01-2019' AND Student.enrollDate < '31-12-2019'
GROUP BY Student.degreeProgram
ORDER BY AVG(GradeOf.grade) DESC;

-- Where and when all lectures of a course will be organized (CS-101)
SELECT Building.street,
       Building.buildingName,
       Hall.hallName,
       Reservation.startDate,
       Reservation.endDate
  FROM (
           (
               (
                   
                       CourseInstance
                       LEFT OUTER JOIN
                       Lecture ON CourseInstance.courseStartDate = Lecture.courseStartDate AND 
                                  CourseInstance.courseCode = Lecture.courseCode
               )AS CourseLectures
               LEFT OUTER JOIN
               Reservation ON Reservation.eventID = CourseLectures.eventID
           ) as CourseReservations
           LEFT OUTER JOIN
           Hall ON Hall.hallName = CourseReservations.hallName AND 
                   Hall.buildingName = CourseReservations.buildingName
       ) as CourseHalls
       LEFT OUTER JOIN
       Building ON CourseHalls.buildingName = Building.buildingName
   WHERE Lecture.courseCode IS NOT NULL AND CourseInstance.courseCode = 'CS-101' AND CourseInstance.courseStartDate = '2023-09-01';
