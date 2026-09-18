	USE AcademicSystem;
GO

-- Create roles
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'EducationAdmin')
    CREATE ROLE EducationAdmin;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Librarian')
    CREATE ROLE Librarian;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Student')
    CREATE ROLE Student;
GO

-- Grant permissions to EducationAdmin
IF OBJECT_ID('Education.AddStudent') IS NOT NULL
    GRANT EXECUTE ON Education.AddStudent TO EducationAdmin;
IF OBJECT_ID('Education.ExportCoursesToCSV') IS NOT NULL
    GRANT EXECUTE ON Education.ExportCoursesToCSV TO EducationAdmin;
IF OBJECT_ID('Education.ImportCoursesFromCSV') IS NOT NULL
    GRANT EXECUTE ON Education.ImportCoursesFromCSV TO EducationAdmin;
GRANT INSERT ON Shared.Person TO EducationAdmin;
GRANT INSERT ON Education.Students TO EducationAdmin;
GRANT INSERT ON Education.EducationLog TO EducationAdmin;
GRANT INSERT ON Education.Courses TO EducationAdmin;
GO

-- Grant permissions to Librarian
IF OBJECT_ID('Library.BorrowBook') IS NOT NULL
    GRANT EXECUTE ON Library.BorrowBook TO Librarian;
GRANT INSERT, UPDATE ON Library.Loans TO Librarian;
GRANT INSERT ON Library.LoanHistory TO Librarian;
GRANT INSERT ON Library.LibraryLog TO Librarian;
GRANT SELECT ON Library.Books TO Librarian;
GRANT UPDATE ON Library.Books (AvailableCopies) TO Librarian;
GO

-- Grant permissions to Student
IF OBJECT_ID('Education.GetStudentPassedCredits') IS NOT NULL
    GRANT EXECUTE ON Education.GetStudentPassedCredits TO Student;
IF OBJECT_ID('Education.GetSemesterCourses') IS NOT NULL
    GRANT EXECUTE ON Education.GetSemesterCourses TO Student;
IF OBJECT_ID('Education.SuggestCourses') IS NOT NULL
	GRANT EXECUTE ON Education.SuggestCourses TO Student;
GRANT SELECT ON Education.StudentCourses TO Student;
GRANT SELECT ON Education.Courses TO Student;
GRANT SELECT ON Education.Semesters TO Student;
DENY INSERT, UPDATE, DELETE ON Education.StudentCourses TO Student;
DENY INSERT, UPDATE, DELETE ON Education.Courses TO Student;
GO

-- Create test users and assign roles
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AdminUser')
BEGIN
    CREATE USER AdminUser WITHOUT LOGIN;
    ALTER ROLE EducationAdmin ADD MEMBER AdminUser;
END
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'LibrarianUser')
BEGIN
    CREATE USER LibrarianUser WITHOUT LOGIN;
    ALTER ROLE Librarian ADD MEMBER LibrarianUser;
END
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'StudentUser')
BEGIN
    CREATE USER StudentUser WITHOUT LOGIN;
    ALTER ROLE Student ADD MEMBER StudentUser;
END
GO