-- 1. Add a new student
Insert Into Student 
Values ('30000001', "Saul Student", '2002-02-02', 'Computer science', '2022-06-01','2027-06-01')

-- 2. Check if student in course
select Count(StudentID) 
from ExerciseGroup, EnrolledIn
where ExerciseGroup.courseCode = 'MS-201' and StudentID = '10003' and groupName = exerciseGroupName;

-- 3. Check courses that are arranged in future
select *
from Course, CourseInstance
where Course.c ode = CourseInstance.courseCode and courseStartDate > date();

-- 4. Get an exerciseGroup Register into it
select groupName
from ExerciseGroup, CourseInstance
where ExerciseGroup.courseCode = CourseInstance.courseCode and 
    ExerciseGroup.courseStartDate = CourseInstance.courseStartDate and 
        CourseInstance.courseCode = 'MS-201' and CourseInstance.courseStartDate = '2023-09-01'
        
-- ... Now register for the group
Insert Into EnrolledIn Values
('10001', 'Group G', 'MS-201', '2023-09-01')

-- Updating exercise points, TODO: Think this through anew
Update ExercisePoints
Set points = points = points + 3
where studentID = '10002' and CourseCode = 'LC-1101' and courseStartDate = '2023-01-09';

-- WARNING: Just a bit of a thought experiment, add 3pts to all
Update ExercisePoints
Set points = points + 3
where studentID in (
    select StudentID
    from ExercisePoints
);


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
