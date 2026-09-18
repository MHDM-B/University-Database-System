USE AcademicSystem;
GO

-- Drop tables if they exist (in reverse order to handle foreign key dependencies)
IF OBJECT_ID('Education.ErrorLog') IS NOT NULL DROP TABLE Education.ErrorLog;
IF OBJECT_ID('Library.BookRecommendations') IS NOT NULL DROP TABLE Library.BookRecommendations;
IF OBJECT_ID('Library.LoanHistory') IS NOT NULL DROP TABLE Library.LoanHistory;
IF OBJECT_ID('Library.Loans') IS NOT NULL DROP TABLE Library.Loans;
IF OBJECT_ID('Library.BookAuthors') IS NOT NULL DROP TABLE Library.BookAuthors;
IF OBJECT_ID('Library.Books') IS NOT NULL DROP TABLE Library.Books;
IF OBJECT_ID('Library.Authors') IS NOT NULL DROP TABLE Library.Authors;
IF OBJECT_ID('Library.Publishers') IS NOT NULL DROP TABLE Library.Publishers;
IF OBJECT_ID('Library.Categories') IS NOT NULL DROP TABLE Library.Categories;
IF OBJECT_ID('Library.LibraryUsers') IS NOT NULL DROP TABLE Library.LibraryUsers;
IF OBJECT_ID('Library.LibraryLog') IS NOT NULL DROP TABLE Library.LibraryLog;
IF OBJECT_ID('Education.CourseSuggestions') IS NOT NULL DROP TABLE Education.CourseSuggestions;
IF OBJECT_ID('Education.StudentCourses') IS NOT NULL DROP TABLE Education.StudentCourses;
IF OBJECT_ID('Education.CourseOfferings') IS NOT NULL DROP TABLE Education.CourseOfferings;
IF OBJECT_ID('Education.CurriculumCourses') IS NOT NULL DROP TABLE Education.CurriculumCourses;
IF OBJECT_ID('Education.Curriculums') IS NOT NULL DROP TABLE Education.Curriculums;
IF OBJECT_ID('Education.Semesters') IS NOT NULL DROP TABLE Education.Semesters;
IF OBJECT_ID('Education.StudentStatusHistory') IS NOT NULL DROP TABLE Education.StudentStatusHistory;
IF OBJECT_ID('Education.Students') IS NOT NULL DROP TABLE Education.Students;
IF OBJECT_ID('Education.FacultyAssignments') IS NOT NULL DROP TABLE Education.FacultyAssignments;
IF OBJECT_ID('Education.Faculty') IS NOT NULL DROP TABLE Education.Faculty;
IF OBJECT_ID('Education.Courses') IS NOT NULL DROP TABLE Education.Courses;
IF OBJECT_ID('Education.Departments') IS NOT NULL DROP TABLE Education.Departments;
IF OBJECT_ID('Education.Faculties') IS NOT NULL DROP TABLE Education.Faculties;
IF OBJECT_ID('Education.EducationLog') IS NOT NULL DROP TABLE Education.EducationLog;
IF OBJECT_ID('Education.AcademicYears') IS NOT NULL DROP TABLE Education.AcademicYears;
IF OBJECT_ID('Shared.Person') IS NOT NULL DROP TABLE Shared.Person;
GO

-- Create Shared Schema Tables
CREATE TABLE Shared.Person (
    PersonID INT IDENTITY(1,1) PRIMARY KEY,
    NationalCode VARCHAR(10) NOT NULL UNIQUE CHECK (NationalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15),
    Address NVARCHAR(200),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Create Education Schema Tables
CREATE TABLE Education.AcademicYears (
    AcademicYearID INT IDENTITY(1,1) PRIMARY KEY,
    YearName NVARCHAR(20) NOT NULL UNIQUE,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    CHECK (EndDate > StartDate)
);
GO

CREATE TABLE Education.Faculties (
    FacultyID INT IDENTITY(1,1) PRIMARY KEY,
    FacultyName NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Education.Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    FacultyID INT NOT NULL FOREIGN KEY REFERENCES Education.Faculties(FacultyID),
    DepartmentName NVARCHAR(100) NOT NULL,
    UNIQUE (FacultyID, DepartmentName)
);
GO

CREATE TABLE Education.Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT NOT NULL FOREIGN KEY REFERENCES Education.Departments(DepartmentID),
    CourseCode VARCHAR(10) NOT NULL,
    CourseName NVARCHAR(100) NOT NULL,
    Credits INT NOT NULL CHECK (Credits > 0),
    UNIQUE (DepartmentID, CourseCode)
);
GO

CREATE TABLE Education.Faculty (
    FacultyPersonID INT PRIMARY KEY FOREIGN KEY REFERENCES Shared.Person(PersonID),
    DepartmentID INT NOT NULL FOREIGN KEY REFERENCES Education.Departments(DepartmentID),
    HireDate DATE NOT NULL,
    Position NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Education.FacultyAssignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    FacultyPersonID INT NOT NULL FOREIGN KEY REFERENCES Education.Faculty(FacultyPersonID),
    CourseID INT NOT NULL FOREIGN KEY REFERENCES Education.Courses(CourseID),
    AcademicYearID INT NOT NULL FOREIGN KEY REFERENCES Education.AcademicYears(AcademicYearID),
    UNIQUE (FacultyPersonID, CourseID, AcademicYearID)
);
GO

CREATE TABLE Education.Students (
    StudentID INT PRIMARY KEY FOREIGN KEY REFERENCES Shared.Person(PersonID),
    DepartmentID INT NOT NULL FOREIGN KEY REFERENCES Education.Departments(DepartmentID),
    EnrollmentDate DATE NOT NULL,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Active', 'Graduated', 'Expelled', 'Withdrawn'))
);
GO

CREATE TABLE Education.StudentStatusHistory (
    StatusHistoryID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Education.Students(StudentID),
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Active', 'Graduated', 'Expelled', 'Withdrawn')),
    ChangeDate DATETIME NOT NULL DEFAULT GETDATE(),
    Reason NVARCHAR(200)
);
GO

CREATE TABLE Education.Semesters (
    SemesterID INT IDENTITY(1,1) PRIMARY KEY,
    AcademicYearID INT NOT NULL FOREIGN KEY REFERENCES Education.AcademicYears(AcademicYearID),
    SemesterName NVARCHAR(20) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    CHECK (EndDate > StartDate),
    UNIQUE (AcademicYearID, SemesterName)
);
GO

CREATE TABLE Education.Curriculums (
    CurriculumID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT NOT NULL FOREIGN KEY REFERENCES Education.Departments(DepartmentID),
    CurriculumName NVARCHAR(100) NOT NULL,
    StartYear INT NOT NULL CHECK (StartYear >= 2000),
    UNIQUE (DepartmentID, CurriculumName, StartYear)
);
GO

CREATE TABLE Education.CurriculumCourses (
    CurriculumCourseID INT IDENTITY(1,1) PRIMARY KEY,
    CurriculumID INT NOT NULL FOREIGN KEY REFERENCES Education.Curriculums(CurriculumID),
    CourseID INT NOT NULL FOREIGN KEY REFERENCES Education.Courses(CourseID),
    SemesterPriority INT NOT NULL CHECK (SemesterPriority > 0),
    UNIQUE (CurriculumID, CourseID)
);
GO

CREATE TABLE Education.CourseOfferings (
    OfferingID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL FOREIGN KEY REFERENCES Education.Courses(CourseID),
    SemesterID INT NOT NULL FOREIGN KEY REFERENCES Education.Semesters(SemesterID),
    FacultyPersonID INT NOT NULL FOREIGN KEY REFERENCES Education.Faculty(FacultyPersonID),
    Capacity INT NOT NULL CHECK (Capacity > 0),
    UNIQUE (CourseID, SemesterID)
);
GO

CREATE TABLE Education.StudentCourses (
    StudentCourseID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Education.Students(StudentID),
    OfferingID INT NOT NULL FOREIGN KEY REFERENCES Education.CourseOfferings(OfferingID),
    Grade DECIMAL(4,2) CHECK (Grade >= 0 AND Grade <= 20),
    EnrollmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    UNIQUE (StudentID, OfferingID)
);
GO

CREATE TABLE Education.CourseSuggestions (
    SuggestionID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL FOREIGN KEY REFERENCES Education.Students(StudentID),
    CourseID INT NOT NULL FOREIGN KEY REFERENCES Education.Courses(CourseID),
    SemesterID INT NOT NULL FOREIGN KEY REFERENCES Education.Semesters(SemesterID),
    Priority INT NOT NULL CHECK (Priority > 0),
    UNIQUE (StudentID, CourseID, SemesterID)
);
GO

CREATE TABLE Education.EducationLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EventType NVARCHAR(50) NOT NULL,
    EventDescription NVARCHAR(500),
    EventDate DATETIME NOT NULL DEFAULT GETDATE(),
    PersonID INT FOREIGN KEY REFERENCES Shared.Person(PersonID)
);
GO

-- Create Library Schema Tables
CREATE TABLE Library.LibraryUsers (
    LibraryUserID INT PRIMARY KEY FOREIGN KEY REFERENCES Shared.Person(PersonID),
    RegistrationDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Library.Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE Library.Publishers (
    PublisherID INT IDENTITY(1,1) PRIMARY KEY,
    PublisherName NVARCHAR(100) NOT NULL UNIQUE,
    Address NVARCHAR(200)
);
GO

CREATE TABLE Library.Authors (
    AuthorID INT IDENTITY(1,1) PRIMARY KEY,
    AuthorName NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Library.Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT NOT NULL FOREIGN KEY REFERENCES Library.Categories(CategoryID),
    PublisherID INT NOT NULL FOREIGN KEY REFERENCES Library.Publishers(PublisherID),
    ISBN VARCHAR(13) NOT NULL UNIQUE CHECK (ISBN LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    Title NVARCHAR(200) NOT NULL,
    PublicationYear INT CHECK (PublicationYear >= 1800),
    TotalCopies INT NOT NULL CHECK (TotalCopies >= 0),
    AvailableCopies INT NOT NULL CHECK (AvailableCopies >= 0)
);
GO

CREATE TABLE Library.BookAuthors (
    BookAuthorID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT NOT NULL FOREIGN KEY REFERENCES Library.Books(BookID),
    AuthorID INT NOT NULL FOREIGN KEY REFERENCES Library.Authors(AuthorID),
    UNIQUE (BookID, AuthorID)
);
GO

CREATE TABLE Library.Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    LibraryUserID INT NOT NULL FOREIGN KEY REFERENCES Library.LibraryUsers(LibraryUserID),
    BookID INT NOT NULL FOREIGN KEY REFERENCES Library.Books(BookID),
    LoanDate DATETIME NOT NULL DEFAULT GETDATE(),
    DueDate DATETIME NOT NULL,
    ReturnDate DATETIME,
    CHECK (DueDate > LoanDate),
    CHECK (ReturnDate IS NULL OR ReturnDate >= LoanDate)
);
GO

CREATE TABLE Library.LoanHistory (
    LoanHistoryID INT IDENTITY(1,1) PRIMARY KEY,
    LoanID INT NOT NULL FOREIGN KEY REFERENCES Library.Loans(LoanID),
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Borrowed', 'Returned', 'Overdue')),
    StatusDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Library.BookRecommendations (
    RecommendationID INT IDENTITY(1,1) PRIMARY KEY,
    LibraryUserID INT NOT NULL FOREIGN KEY REFERENCES Library.LibraryUsers(LibraryUserID),
    BookID INT NOT NULL FOREIGN KEY REFERENCES Library.Books(BookID),
    RecommendationScore INT NOT NULL CHECK (RecommendationScore > 0),
    UNIQUE (LibraryUserID, BookID)
);
GO

CREATE TABLE Library.LibraryLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EventType NVARCHAR(50) NOT NULL,
    EventDescription NVARCHAR(500),
    EventDate DATETIME NOT NULL DEFAULT GETDATE(),
    PersonID INT FOREIGN KEY REFERENCES Shared.Person(PersonID)
);

CREATE TABLE Education.ErrorLog (
    ErrorLogID INT IDENTITY(1,1) PRIMARY KEY,
    ProcedureName VARCHAR(100),
    ErrorMessage VARCHAR(500),
    ErrorDate DATETIME DEFAULT GETDATE()
);
GO