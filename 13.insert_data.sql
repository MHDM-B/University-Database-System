USE AcademicSystem;
GO

-- Delete all rows from tables in reverse dependency order
DELETE FROM Library.BookRecommendations;
DBCC CHECKIDENT ('Library.BookRecommendations', RESEED, 0);

GO
DELETE FROM Library.LoanHistory;
DBCC CHECKIDENT ('Library.LoanHistory', RESEED, 0);

GO
DELETE FROM Library.Loans;
DBCC CHECKIDENT ('Library.Loans', RESEED, 0);

GO
DELETE FROM Library.BookAuthors;
DBCC CHECKIDENT ('Library.BookAuthors', RESEED, 0);

GO
DELETE FROM Library.Books;
DBCC CHECKIDENT ('Library.Books', RESEED, 0);

GO
DELETE FROM Library.Authors;
DBCC CHECKIDENT ('Library.Authors', RESEED, 0);

GO
DELETE FROM Library.Publishers;
DBCC CHECKIDENT ('Library.Publishers', RESEED, 0);

GO
DELETE FROM Library.Categories;
DBCC CHECKIDENT ('Library.Categories', RESEED, 0);

GO
DELETE FROM Library.LibraryUsers;
DBCC CHECKIDENT ('Library.LibraryUsers', RESEED, 0);

GO
DELETE FROM Library.LibraryLog;
DBCC CHECKIDENT ('Library.LibraryLog', RESEED, 0);

GO
DELETE FROM Education.CourseSuggestions;
DBCC CHECKIDENT ('Education.CourseSuggestions', RESEED, 0);

GO
DELETE FROM Education.StudentCourses;
DBCC CHECKIDENT ('Education.StudentCourses', RESEED, 0);

GO
DELETE FROM Education.CourseOfferings;
DBCC CHECKIDENT ('Education.CourseOfferings', RESEED, 0);

GO
DELETE FROM Education.CurriculumCourses;
DBCC CHECKIDENT ('Education.CurriculumCourses', RESEED, 0);

GO
DELETE FROM Education.Curriculums;
DBCC CHECKIDENT ('Education.Curriculums', RESEED, 0);

GO
DELETE FROM Education.Semesters;
DBCC CHECKIDENT ('Education.Semesters', RESEED, 0);

GO
DELETE FROM Education.StudentStatusHistory;
DBCC CHECKIDENT ('Education.StudentStatusHistory', RESEED, 0);

GO
DELETE FROM Education.Students;
DBCC CHECKIDENT ('Education.Students', RESEED, 0);

GO
DELETE FROM Education.FacultyAssignments;
DBCC CHECKIDENT ('Education.FacultyAssignments', RESEED, 0);

GO
DELETE FROM Education.Faculty;
DBCC CHECKIDENT ('Education.Faculty', RESEED, 0);

GO
DELETE FROM Education.Courses;
DBCC CHECKIDENT ('Education.Courses', RESEED, 0);

GO
DELETE FROM Education.Departments;
DBCC CHECKIDENT ('Education.Departments', RESEED, 0);

GO
DELETE FROM Education.Faculties;
DBCC CHECKIDENT ('Education.Faculties', RESEED, 0);

GO
DELETE FROM Education.EducationLog;
DBCC CHECKIDENT ('Education.EducationLog', RESEED, 0);

GO
DELETE FROM Education.AcademicYears;
DBCC CHECKIDENT ('Education.AcademicYears', RESEED, 0);
GO
DELETE FROM Shared.Person;
DBCC CHECKIDENT ('Shared.Person', RESEED, 0);
GO

-- Insert into Shared.Person (50 rows, using GenerateNationalCode)
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(1), 'John', 'Smith', '2000-05-15', 'john.smith@email.com', '1234567890', '123 Main St');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(2), 'Emma', 'Johnson', '1999-08-22', 'emma.johnson@email.com', '2345678901', '456 Oak Ave');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(3), 'Michael', 'Brown', '1998-03-10', 'michael.brown@email.com', '3456789012', '789 Pine Rd');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(4), 'Sarah', 'Davis', '2001-11-30', 'sarah.davis@email.com', '4567890123', '101 Elm St');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(5), 'David', 'Wilson', '1997-06-25', 'david.wilson@email.com', '5678901234', '202 Cedar Ln');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(6), 'Laura', 'Taylor', '2000-09-12', 'laura.taylor@email.com', '6789012345', '303 Birch Dr');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(7), 'James', 'Moore', '1999-02-18', 'james.moore@email.com', '7890123456', '404 Maple Ct');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(8), 'Emily', 'Anderson', '2002-07-07', 'emily.anderson@email.com', '8901234567', '505 Spruce Way');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(9), 'Robert', 'Thomas', '1996-12-01', 'robert.thomas@email.com', '9012345678', '606 Walnut Blvd');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(10), 'Sophia', 'Martinez', '2001-04-20', 'sophia.martinez@email.com', '0123456789', '707 Chestnut Pl');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(11), 'William', 'Garcia', '1998-10-15', 'william.garcia@email.com', '1112223334', '808 Magnolia St');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(12), 'Olivia', 'Rodriguez', '2000-01-25', 'olivia.rodriguez@email.com', '2223334445', '909 Sycamore Dr');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(13), 'Daniel', 'Lee', '1999-05-30', 'daniel.lee@email.com', '3334445556', '1010 Laurel Ave');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(14), 'Ava', 'Hernandez', '2002-08-10', 'ava.hernandez@email.com', '4445556667', '1111 Willow Rd');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(15), 'Matthew', 'Lopez', '1997-03-05', 'matthew.lopez@email.com', '5556667778', '1212 Poplar Ln');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(16), 'Isabella', 'Gonzalez', '2001-06-18', 'isabella.gonzalez@email.com', '6667778889', '1313 Cedar Ct');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(17), 'Ethan', 'Perez', '1998-11-22', 'ethan.perez@email.com', '7778889990', '1414 Pine Way');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(18), 'Mia', 'Sanchez', '2000-02-15', 'mia.sanchez@email.com', '8889990001', '1515 Oak Blvd');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(19), 'Alexander', 'Ramirez', '1999-07-09', 'alexander.ramirez@email.com', '9000111223', '1616 Elm Pl');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(20), 'Charlotte', 'Torres', '2002-12-01', 'charlotte.torres@email.com', '0001112223', '1717 Maple St');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(21), 'Liam', 'Flores', '1997-04-14', 'liam.flores@email.com', '1112223335', '1818 Birch Dr');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(22), 'Amelia', 'Rivera', '2000-09-27', 'amelia.rivera@email.com', '2223334446', '1919 Spruce Ct');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(23), 'Noah', 'Gomez', '1998-01-12', 'noah.gomez@email.com', '3334445557', '2020 Walnut Way');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(24), 'Harper', 'Diaz', '2001-05-19', 'harper.diaz@email.com', '4445556668', '2121 Chestnut Rd');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(25), 'Elijah', 'Reyes', '1999-10-03', 'elijah.reyes@email.com', '5556667779', '2222 Magnolia Ln');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(26), 'Evelyn', 'Cruz', '2002-03-28', 'evelyn.cruz@email.com', '6667778880', '2323 Sycamore Pl');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(27), 'Logan', 'Ortiz', '1997-08-16', 'logan.ortiz@email.com', '7778889991', '2424 Laurel St');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(28), 'Abigail', 'Morales', '2000-11-11', 'abigail.morales@email.com', '8889990002', '2525 Willow Dr');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(29), 'Mason', 'Nguyen', '1998-06-04', 'mason.nguyen@email.com', '9990001113', '2626 Poplar Ave');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(30), 'Sofia', 'Kim', '2001-02-17', 'sofia.kim@email.com', '0001112224', '2727 Cedar Rd');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(31), 'Lucas', 'Patel', '1999-09-09', 'lucas.patel@email.com', '1112223336', '2828 Pine Ct');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(32), 'Aria', 'Chen', '2002-04-22', 'aria.chen@email.com', '2223334447', '2929 Oak Way');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(33), 'Jackson', 'Wong', '1997-12-05', 'jackson.wong@email.com', '3334445558', '3030 Elm Blvd');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(34), 'Mila', 'Singh', '2000-07-30', 'mila.singh@email.com', '4445556669', '3131 Maple Pl');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(35), 'Aiden', 'Kumar', '1998-02-14', 'aiden.kumar@email.com', '5556667770', '3232 Spruce St');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(36), 'Luna', 'Gupta', '2001-10-27', 'luna.gupta@email.com', '6667778881', '3333 Walnut Dr');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(37), 'Grayson', 'Sharma', '1999-05-12', 'grayson.sharma@email.com', '7778889992', '3434 Chestnut Ct');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(38), 'Chloe', 'Verma', '2002-01-08', 'chloe.verma@email.com', '8889990003', '3535 Magnolia Ln');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(39), 'Carter', 'Li', '1997-06-23', 'carter.li@email.com', '9990001114', '3636 Sycamore Rd');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(40), 'Penelope', 'Zhang', '2000-03-16', 'penelope.zhang@email.com', '0001112225', '3737 Laurel Way');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(41), 'Owen', 'Wang', '1998-08-29', 'owen.wang@email.com', '1112223337', '3838 Willow Pl');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(42), 'Layla', 'Liu', '2001-11-04', 'layla.liu@email.com', '2223334448', '3939 Poplar St');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(43), 'Gabriel', 'Xu', '1999-04-18', 'gabriel.xu@email.com', '3334445559', '4040 Cedar Dr');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(44), 'Zoe', 'Zhao', '2002-09-01', 'zoe.zhao@email.com', '4445556670', '4141 Pine Ave');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(45), 'Julian', 'Wu', '1997-02-25', 'julian.wu@email.com', '5556667781', '4242 Oak Ct');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(46), 'Stella', 'Yang', '2000-12-10', 'stella.yang@email.com', '6667778892', '4343 Elm Rd');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(47), 'Eli', 'Zhou', '1998-07-15', 'eli.zhou@email.com', '7778889993', '4444 Maple Way');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(48), 'Nora', 'Huang', '2001-01-29', 'nora.huang@email.com', '8889990004', '4545 Spruce Pl');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(49), 'Levi', 'Lin', '1999-06-13', 'levi.lin@email.com', '9990001115', '4646 Walnut St');
GO
INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
VALUES (Shared.GenerateNationalCode(50), 'Hannah', 'Chang', '2002-02-26', 'hannah.chang@email.com', '0001112226', '4747 Chestnut Dr');
GO


-- Insert into Education.AcademicYears (2 rows)
INSERT INTO Education.AcademicYears (YearName, StartDate, EndDate)
VALUES ('2023-2024', '2023-09-01', '2024-06-30');
GO
INSERT INTO Education.AcademicYears (YearName, StartDate, EndDate)
VALUES ('2024-2025', '2024-09-01', '2025-06-30');
GO

-- Insert into Education.Faculties (2 rows)
INSERT INTO Education.Faculties (FacultyName)
VALUES ('Engineering');
GO
INSERT INTO Education.Faculties (FacultyName)
VALUES ('Science');
GO

-- Insert into Education.Departments (3 rows)
INSERT INTO Education.Departments (FacultyID, DepartmentName)
VALUES (1, 'Computer Science');
GO
INSERT INTO Education.Departments (FacultyID, DepartmentName)
VALUES (1, 'Electrical Engineering');
GO
INSERT INTO Education.Departments (FacultyID, DepartmentName)
VALUES (2, 'Mathematics');
GO

-- Insert into Education.Courses (7 rows)
INSERT INTO Education.Courses (DepartmentID, CourseCode, CourseName, Credits)
VALUES (1, 'CS101', 'Introduction to Programming', 3);
GO
INSERT INTO Education.Courses (DepartmentID, CourseCode, CourseName, Credits)
VALUES (1, 'CS201', 'Data Structures', 4);
GO
INSERT INTO Education.Courses (DepartmentID, CourseCode, CourseName, Credits)
VALUES (1, 'CS301', 'Algorithms', 4);
GO
INSERT INTO Education.Courses (DepartmentID, CourseCode, CourseName, Credits)
VALUES (1, 'CS401', 'Database Systems', 3);
GO
INSERT INTO Education.Courses (DepartmentID, CourseCode, CourseName, Credits)
VALUES (1, 'CS501', 'Operating Systems', 3);
GO
INSERT INTO Education.Courses (DepartmentID, CourseCode, CourseName, Credits)
VALUES (2, 'EE101', 'Circuit Analysis', 3);
GO
INSERT INTO Education.Courses (DepartmentID, CourseCode, CourseName, Credits)
VALUES (3, 'MATH101', 'Calculus I', 4);
GO

-- Insert into Education.Faculty (3 rows)
INSERT INTO Education.Faculty (FacultyPersonID, DepartmentID, HireDate, Position)
VALUES (41, 1, '2020-08-01', 'Professor');
GO
INSERT INTO Education.Faculty (FacultyPersonID, DepartmentID, HireDate, Position)
VALUES (42, 1, '2019-09-01', 'Associate Professor');
GO
INSERT INTO Education.Faculty (FacultyPersonID, DepartmentID, HireDate, Position)
VALUES (43, 2, '2021-01-15', 'Assistant Professor');
GO

-- Insert into Education.FacultyAssignments (5 rows)
INSERT INTO Education.FacultyAssignments (FacultyPersonID, CourseID, AcademicYearID)
VALUES (41, 1, 1);
GO
INSERT INTO Education.FacultyAssignments (FacultyPersonID, CourseID, AcademicYearID)
VALUES (41, 2, 1);
GO
INSERT INTO Education.FacultyAssignments (FacultyPersonID, CourseID, AcademicYearID)
VALUES (42, 3, 1);
GO
INSERT INTO Education.FacultyAssignments (FacultyPersonID, CourseID, AcademicYearID)
VALUES (42, 4, 2);
GO
INSERT INTO Education.FacultyAssignments (FacultyPersonID, CourseID, AcademicYearID)
VALUES (43, 6, 2);
GO

-- Insert into Education.Students (10 rows)
INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
VALUES (1, 1, '2023-09-01', 'Active');
GO
INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
VALUES (2, 1, '2023-09-01', 'Active');
GO
INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
VALUES (3, 1, '2024-09-01', 'Active');
GO
INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
VALUES (4, 2, '2023-09-01', 'Active');
GO
INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
VALUES (5, 3, '2024-09-01', 'Active');
GO
INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
VALUES (6, 1, '2023-09-01', 'Graduated');
GO
INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
VALUES (7, 1, '2024-09-01', 'Active');
GO
INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
VALUES (8, 1, '2023-09-01', 'Active');
GO
INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
VALUES (9, 2, '2024-09-01', 'Active');
GO
INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
VALUES (10, 3, '2023-09-01', 'Withdrawn');
GO

-- Insert into Education.StudentStatusHistory (3 rows)
INSERT INTO Education.StudentStatusHistory (StudentID, Status, ChangeDate, Reason)
VALUES (1, 'Active', '2023-09-01', 'Enrolled');
GO
INSERT INTO Education.StudentStatusHistory (StudentID, Status, ChangeDate, Reason)
VALUES (6, 'Graduated', '2024-06-30', 'Completed degree');
GO
INSERT INTO Education.StudentStatusHistory (StudentID, Status, ChangeDate, Reason)
VALUES (10, 'Withdrawn', '2024-01-15', 'Personal reasons');
GO

-- Insert into Education.Semesters (3 rows)
INSERT INTO Education.Semesters (AcademicYearID, SemesterName, StartDate, EndDate)
VALUES (1, 'Fall 2023', '2023-09-01', '2023-12-31');
GO
INSERT INTO Education.Semesters (AcademicYearID, SemesterName, StartDate, EndDate)
VALUES (1, 'Spring 2024', '2024-01-01', '2024-06-30');
GO
INSERT INTO Education.Semesters (AcademicYearID, SemesterName, StartDate, EndDate)
VALUES (2, 'Fall 2024', '2024-09-01', '2024-12-31');
GO

-- Insert into Education.Curriculums (2 rows)
INSERT INTO Education.Curriculums (DepartmentID, CurriculumName, StartYear)
VALUES (1, 'Computer Science BS', 2023);
GO
INSERT INTO Education.Curriculums (DepartmentID, CurriculumName, StartYear)
VALUES (2, 'Electrical Engineering BS', 2023);
GO

-- Insert into Education.CurriculumCourses (5 rows)
INSERT INTO Education.CurriculumCourses (CurriculumID, CourseID, SemesterPriority)
VALUES (1, 1, 1);
GO
INSERT INTO Education.CurriculumCourses (CurriculumID, CourseID, SemesterPriority)
VALUES (1, 2, 2);
GO
INSERT INTO Education.CurriculumCourses (CurriculumID, CourseID, SemesterPriority)
VALUES (1, 3, 3);
GO
INSERT INTO Education.CurriculumCourses (CurriculumID, CourseID, SemesterPriority)
VALUES (1, 4, 4);
GO
INSERT INTO Education.CurriculumCourses (CurriculumID, CourseID, SemesterPriority)
VALUES (1, 5, 5);
GO

-- Insert into Education.CourseOfferings (5 rows)
INSERT INTO Education.CourseOfferings (CourseID, SemesterID, FacultyPersonID, Capacity)
VALUES (1, 1, 41, 50);
GO
INSERT INTO Education.CourseOfferings (CourseID, SemesterID, FacultyPersonID, Capacity)
VALUES (2, 2, 41, 40);
GO
INSERT INTO Education.CourseOfferings (CourseID, SemesterID, FacultyPersonID, Capacity)
VALUES (3, 2, 42, 30);
GO
INSERT INTO Education.CourseOfferings (CourseID, SemesterID, FacultyPersonID, Capacity)
VALUES (4, 3, 42, 35);
GO
INSERT INTO Education.CourseOfferings (CourseID, SemesterID, FacultyPersonID, Capacity)
VALUES (6, 3, 43, 45);
GO

-- Insert into Education.StudentCourses (8 rows)
INSERT INTO Education.StudentCourses (StudentID, OfferingID, Grade, EnrollmentDate)
VALUES (1, 1, 15.5, '2023-09-02');
GO
INSERT INTO Education.StudentCourses (StudentID, OfferingID, Grade, EnrollmentDate)
VALUES (1, 2, 12.0, '2024-01-05');
GO
INSERT INTO Education.StudentCourses (StudentID, OfferingID, Grade, EnrollmentDate)
VALUES (2, 1, 17.0, '2023-09-02');
GO
INSERT INTO Education.StudentCourses (StudentID, OfferingID, Grade, EnrollmentDate)
VALUES (2, 2, 14.5, '2024-01-05');
GO
INSERT INTO Education.StudentCourses (StudentID, OfferingID, Grade, EnrollmentDate)
VALUES (3, 4, NULL, '2024-09-02');
GO
INSERT INTO Education.StudentCourses (StudentID, OfferingID, Grade, EnrollmentDate)
VALUES (6, 1, 18.0, '2023-09-02');
GO
INSERT INTO Education.StudentCourses (StudentID, OfferingID, Grade, EnrollmentDate)
VALUES (6, 2, 16.5, '2024-01-05');
GO
INSERT INTO Education.StudentCourses (StudentID, OfferingID, Grade, EnrollmentDate)
VALUES (6, 3, 15.0, '2024-01-05');
GO



-- Insert into Education.EducationLog (3 rows)
INSERT INTO Education.EducationLog (EventType, EventDescription, EventDate, PersonID)
VALUES ('StudentAdded', 'New student registered: John Smith', '2023-09-01', 1);
GO
INSERT INTO Education.EducationLog (EventType, EventDescription, EventDate, PersonID)
VALUES ('StudentAdded', 'New student registered: Emma Johnson', '2023-09-01', 2);
GO
INSERT INTO Education.EducationLog (EventType, EventDescription, EventDate, PersonID)
VALUES ('StatusUpdated', 'Student graduated: Sophia Martinez', '2024-06-30', 6);
GO

-- Insert into Library.LibraryUsers (8 rows)
INSERT INTO Library.LibraryUsers (LibraryUserID, RegistrationDate, IsActive)
VALUES (11, '2023-09-01', 1);
GO
INSERT INTO Library.LibraryUsers (LibraryUserID, RegistrationDate, IsActive)
VALUES (12, '2023-09-01', 1);
GO
INSERT INTO Library.LibraryUsers (LibraryUserID, RegistrationDate, IsActive)
VALUES (13, '2024-09-01', 1);
GO
INSERT INTO Library.LibraryUsers (LibraryUserID, RegistrationDate, IsActive)
VALUES (14, '2023-09-01', 1);
GO
INSERT INTO Library.LibraryUsers (LibraryUserID, RegistrationDate, IsActive)
VALUES (15, '2024-09-01', 1);
GO
INSERT INTO Library.LibraryUsers (LibraryUserID, RegistrationDate, IsActive)
VALUES (16, '2023-09-01', 0);
GO
INSERT INTO Library.LibraryUsers (LibraryUserID, RegistrationDate, IsActive)
VALUES (17, '2024-09-01', 1);
GO
INSERT INTO Library.LibraryUsers (LibraryUserID, RegistrationDate, IsActive)
VALUES (18, '2023-09-01', 1);
GO

-- Insert into Library.Categories (5 rows)
INSERT INTO Library.Categories (CategoryName)
VALUES ('Computer Science');
GO
INSERT INTO Library.Categories (CategoryName)
VALUES ('Mathematics');
GO
INSERT INTO Library.Categories (CategoryName)
VALUES ('Engineering');
GO
INSERT INTO Library.Categories (CategoryName)
VALUES ('Fiction');
GO
INSERT INTO Library.Categories (CategoryName)
VALUES ('History');
GO

-- Insert into Library.Publishers (3 rows)
INSERT INTO Library.Publishers (PublisherName, Address)
VALUES ('Tech Press', '123 Publisher St, Tech City');
GO
INSERT INTO Library.Publishers (PublisherName, Address)
VALUES ('Academic Books', '456 Book Ave, Academic Town');
GO
INSERT INTO Library.Publishers (PublisherName, Address)
VALUES ('Global Pub', '789 Print Rd, Global City');
GO

-- Insert into Library.Authors (4 rows)
INSERT INTO Library.Authors (AuthorName)
VALUES ('Alice Johnson');
GO
INSERT INTO Library.Authors (AuthorName)
VALUES ('Bob Smith');
GO
INSERT INTO Library.Authors (AuthorName)
VALUES ('Carol White');
GO
INSERT INTO Library.Authors (AuthorName)
VALUES ('David Brown');
GO

-- Insert into Library.Books (7 rows)
INSERT INTO Library.Books (CategoryID, PublisherID, ISBN, Title, PublicationYear, TotalCopies, AvailableCopies)
VALUES (1, 1, '1234567890123', 'Introduction to Algorithms', 2020, 10, 8);
GO
INSERT INTO Library.Books (CategoryID, PublisherID, ISBN, Title, PublicationYear, TotalCopies, AvailableCopies)
VALUES (1, 1, '2345678901234', 'Database Fundamentals', 2019, 15, 14);
GO
INSERT INTO Library.Books (CategoryID, PublisherID, ISBN, Title, PublicationYear, TotalCopies, AvailableCopies)
VALUES (1, 2, '3456789012345', 'Operating Systems Concepts', 2021, 12, 11);
GO
INSERT INTO Library.Books (CategoryID, PublisherID, ISBN, Title, PublicationYear, TotalCopies, AvailableCopies)
VALUES (2, 2, '4567890123456', 'Calculus Made Easy', 2018, 8, 7);
GO
INSERT INTO Library.Books (CategoryID, PublisherID, ISBN, Title, PublicationYear, TotalCopies, AvailableCopies)
VALUES (3, 3, '5678901234567', 'Circuit Design Basics', 2022, 10, 10);
GO
INSERT INTO Library.Books (CategoryID, PublisherID, ISBN, Title, PublicationYear, TotalCopies, AvailableCopies)
VALUES (4, 1, '6789012345678', 'The Great Novel', 2020, 20, 19);
GO
INSERT INTO Library.Books (CategoryID, PublisherID, ISBN, Title, PublicationYear, TotalCopies, AvailableCopies)
VALUES (5, 3, '7890123456789', 'History of Technology', 2017, 5, 5);
GO

-- Insert into Library.BookAuthors (8 rows)
INSERT INTO Library.BookAuthors (BookID, AuthorID)
VALUES (1, 1);
GO
INSERT INTO Library.BookAuthors (BookID, AuthorID)
VALUES (1, 2);
GO
INSERT INTO Library.BookAuthors (BookID, AuthorID)
VALUES (2, 3);
GO
INSERT INTO Library.BookAuthors (BookID, AuthorID)
VALUES (3, 4);
GO
INSERT INTO Library.BookAuthors (BookID, AuthorID)
VALUES (4, 2);
GO
INSERT INTO Library.BookAuthors (BookID, AuthorID)
VALUES (5, 3);
GO
INSERT INTO Library.BookAuthors (BookID, AuthorID)
VALUES (6, 1);
GO
INSERT INTO Library.BookAuthors (BookID, AuthorID)
VALUES (7, 4);
GO

-- Insert into Library.Loans (7 rows)
INSERT INTO Library.Loans (LibraryUserID, BookID, LoanDate, DueDate, ReturnDate)
VALUES (1, 1, '2024-09-01', '2024-09-15', NULL);
GO
INSERT INTO Library.Loans (LibraryUserID, BookID, LoanDate, DueDate, ReturnDate)
VALUES (1, 2, '2024-09-02', '2024-09-16', '2024-09-10');
GO
INSERT INTO Library.Loans (LibraryUserID, BookID, LoanDate, DueDate, ReturnDate)
VALUES (2, 1, '2024-09-03', '2024-09-17', NULL);
GO
INSERT INTO Library.Loans (LibraryUserID, BookID, LoanDate, DueDate, ReturnDate)
VALUES (2, 3, '2024-09-04', '2024-09-18', NULL);
GO
INSERT INTO Library.Loans (LibraryUserID, BookID, LoanDate, DueDate, ReturnDate)
VALUES (3, 4, '2024-09-05', '2024-09-19', NULL);
GO
INSERT INTO Library.Loans (LibraryUserID, BookID, LoanDate, DueDate, ReturnDate)
VALUES (6, 1, '2024-01-01', '2024-01-15', '2024-01-10');
GO
INSERT INTO Library.Loans (LibraryUserID, BookID, LoanDate, DueDate, ReturnDate)
VALUES (8, 6, '2024-09-06', '2024-09-20', NULL);
GO

-- Insert into Library.LoanHistory (9 rows)
INSERT INTO Library.LoanHistory (LoanID, Status, StatusDate)
VALUES (2, 'Borrowed', '2024-09-02');
GO
INSERT INTO Library.LoanHistory (LoanID, Status, StatusDate)
VALUES (6, 'Borrowed', '2024-01-01');
GO

-- Insert into Library.BookRecommendations (4 rows)
INSERT INTO Library.BookRecommendations (LibraryUserID, BookID, RecommendationScore)
VALUES (1, 3, 2);
GO
INSERT INTO Library.BookRecommendations (LibraryUserID, BookID, RecommendationScore)
VALUES (1, 4, 1);
GO
INSERT INTO Library.BookRecommendations (LibraryUserID, BookID, RecommendationScore)
VALUES (2, 4, 2);
GO
INSERT INTO Library.BookRecommendations (LibraryUserID, BookID, RecommendationScore)
VALUES (3, 1, 1);
GO

-- Insert into Library.LibraryLog (4 rows)
INSERT INTO Library.LibraryLog (EventType, EventDescription, EventDate, PersonID)
VALUES ('BookBorrowed', 'Book ID 1 borrowed', '2024-09-01', 1);
GO
INSERT INTO Library.LibraryLog (EventType, EventDescription, EventDate, PersonID)
VALUES ('BookReturned', 'Book ID 2 returned', '2024-09-10', 1);
GO
INSERT INTO Library.LibraryLog (EventType, EventDescription, EventDate, PersonID)
VALUES ('BookBorrowed', 'Book ID 1 borrowed', '2024-09-03', 2);
GO
INSERT INTO Library.LibraryLog (EventType, EventDescription, EventDate, PersonID)
VALUES ('LibraryAccountCreated', 'Library account created for student ID 1', '2023-09-01', 1);
GO