USE AcademicSystem;
GO
--EXECUTE AS USER = 'AdminUser';

-- Create a temporary table to store test results
IF OBJECT_ID('tempdb..#TestResults') IS NOT NULL DROP TABLE #TestResults;
CREATE TABLE #TestResults (
    TestName VARCHAR(100),
    Result VARCHAR(10),
    Message VARCHAR(500)
);
GO

-- Test Shared.GenerateNationalCode
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'GenerateNationalCode_Valid',
    CASE 
        WHEN Education.IsNationalCodeValid(Shared.GenerateNationalCode(100)) = 1 THEN 'PASS'
        ELSE 'FAIL'
    END,
    'Generated code: ' + Shared.GenerateNationalCode(100) + ', Validation result: ' + CASE 
    WHEN Education.IsNationalCodeValid(Shared.GenerateNationalCode(100)) = 1 THEN '1'
    ELSE '0'
    END;
GO

INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'GenerateNationalCode_DifferentInputs',
    CASE 
        WHEN Shared.GenerateNationalCode(100) != Shared.GenerateNationalCode(101) THEN 'PASS'
        ELSE 'FAIL'
    END,
    'Code 100: ' + Shared.GenerateNationalCode(100) + ', Code 101: ' + Shared.GenerateNationalCode(101);
GO

-- Test Education.IsNationalCodeValid
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'IsNationalCodeValid_ValidCode',
    CASE 
        WHEN Education.IsNationalCodeValid(Shared.GenerateNationalCode(1)) = 1 THEN 'PASS'
        ELSE 'FAIL'
    END,
    'Generated code: ' + Shared.GenerateNationalCode(1) + ', Validation result: ' + CASE 
    WHEN Education.IsNationalCodeValid(Shared.GenerateNationalCode(1)) = 1 THEN '1'
    ELSE '0'
    END;
GO

INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'IsNationalCodeValid_InvalidLength',
    CASE 
        WHEN Education.IsNationalCodeValid('12345') = 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    'Input: 12345, Validation result: ' + CASE 
    WHEN Education.IsNationalCodeValid('12345') = 1 THEN '1'
    ELSE '0'
    END;
GO

INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'IsNationalCodeValid_RepeatedDigits',
    CASE 
        WHEN Education.IsNationalCodeValid('1111111111') = 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    'Input: 1111111111, Validation result: '  + CASE 
    WHEN Education.IsNationalCodeValid('1111111111') = 1 THEN '1'
    ELSE '0'
    END;
GO

-- Test Education.GetStudentPassedCredits
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'GetStudentPassedCredits_Student1',
    CASE 
        WHEN Education.GetStudentPassedCredits(1) = 7 THEN 'PASS' -- CS101 (3 credits) + CS201 (4 credits)
        ELSE 'FAIL'
    END,
    'StudentID 1, Expected: 7, Got: ' + CAST(Education.GetStudentPassedCredits(1) AS VARCHAR(10));
GO

INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'GetStudentPassedCredits_Student6',
    CASE 
        WHEN Education.GetStudentPassedCredits(6) = 11 THEN 'PASS' -- CS101 (3) + CS201 (4) + CS301 (4)
        ELSE 'FAIL'
    END,
    'StudentID 6, Expected: 11, Got: ' + CAST(Education.GetStudentPassedCredits(6) AS VARCHAR(10));
GO

INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'GetStudentPassedCredits_NonEnrolled',
    CASE 
        WHEN Education.GetStudentPassedCredits(999) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    'StudentID 999, Expected: 0, Got: ' + CAST(Education.GetStudentPassedCredits(999) AS VARCHAR(10));
GO

-- Test Education.GetSemesterCourses
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'GetSemesterCourses_Fall2023',
    CASE 
        WHEN (SELECT COUNT(*) FROM Education.GetSemesterCourses(1)) = 1 THEN 'PASS' -- Only CS101 offered
        ELSE 'FAIL'
    END,
    'SemesterID 1, Expected count: 1, Got: ' + CAST((SELECT COUNT(*) FROM Education.GetSemesterCourses(1)) AS VARCHAR(10));
GO

INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'GetSemesterCourses_Spring2024',
    CASE 
        WHEN (SELECT COUNT(*) FROM Education.GetSemesterCourses(2)) = 2 THEN 'PASS' -- CS201, CS301
        ELSE 'FAIL'
    END,
    'SemesterID 2, Expected count: 2, Got: ' + CAST((SELECT COUNT(*) FROM Education.GetSemesterCourses(2)) AS VARCHAR(10));
GO

-- Test Library.GetAvailableBookCount
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'GetAvailableBookCount_Book1',
    CASE 
        WHEN Library.GetAvailableBookCount(1) = 7 THEN 'PASS' -- 10 total, 2 loaned
        ELSE 'FAIL'
    END,
    'BookID 1, Expected: 7, Got: ' + CAST(Library.GetAvailableBookCount(1) AS VARCHAR(10));
GO

INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'GetAvailableBookCount_NonExistent',
    CASE 
        WHEN Library.GetAvailableBookCount(999) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    'BookID 999, Expected: 0, Got: ' + CAST(Library.GetAvailableBookCount(999) AS VARCHAR(10));
GO

-- Test Education.AddStudent (Valid Case)
DECLARE @NewPersonID INT, @ErrorMessage VARCHAR(100) , @TEST_NATINALCODE NVARCHAR(10);
SET @TEST_NATINALCODE = Shared.GenerateNationalCode(51);
EXEC @ErrorMessage = Education.AddStudent
    @NationalCode = @TEST_NATINALCODE, 
    @FirstName = 'Test', 
    @LastName = 'Student',
    @DateOfBirth = '2015-09-01',
    @DepartmentID = 1,  
    @EnrollmentDate = '2024-09-01',
    @Email = 'mahdihandsad@gmail.com',  
    @PhoneNumber = NULL,
    @Address = NULL;
SET @NewPersonID = (SELECT PersonID FROM Shared.Person WHERE NationalCode = Shared.GenerateNationalCode(51));
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'AddStudent_Valid',
    CASE 
        WHEN EXISTS (SELECT 1 FROM Education.Students WHERE StudentID = @NewPersonID) 
             AND EXISTS (SELECT 1 FROM Library.LibraryUsers WHERE LibraryUserID = @NewPersonID AND IsActive = 1) THEN 'PASS'
        ELSE 'FAIL'
    END,
    'New Student, Error: ' + ISNULL(@ErrorMessage, 'None') + ', StudentID exists: ' + CASE WHEN EXISTS (SELECT 1 FROM Education.Students WHERE StudentID = @NewPersonID) THEN 'Yes' ELSE 'No' END 
    + ', LibraryUser exists: ' + CASE WHEN EXISTS (SELECT 1 FROM Library.LibraryUsers WHERE LibraryUserID = @NewPersonID) THEN 'Yes' ELSE 'No' END;
GO

-- Test Education.AddStudent (Invalid National Code)
DECLARE @ErrorMessage VARCHAR(4000)
BEGIN TRY
	EXEC Education.AddStudent
    @NationalCode = '111111111', 
    @FirstName = 'Invalid', 
    @LastName = 'Student',
    @DateOfBirth = '2015-09-01',
    @DepartmentID = 1,  
    @EnrollmentDate = '2024-09-01',
    @Email = 'mahdihandsad@gmail.com',  
    @PhoneNumber = NULL,
    @Address = NULL;
END TRY
BEGIN CATCH
	SET @ErrorMessage = ERROR_MESSAGE();
END CATCH;
INSERT INTO #TestResults (TestName, Result, Message)
	SELECT 
		'AddStudent_InvalidCode',
		CASE 
			WHEN @ErrorMessage = CAST('Invalid National Code' AS NVARCHAR(4000)) THEN 'PASS'
			ELSE 'FAIL'
		END,
		'Invalid Code, Error: ' + ISNULL(@ErrorMessage, 'None');
GO

-- Test Shared.TriggerValidateNationalCode (Invalid Code)
DECLARE @TriggerError VARCHAR(4000);
BEGIN TRY
    INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
    VALUES ('1111111111', 'Trigger', 'Test', '2000-01-01', 'trigger.test@email.com', '1234567890', 'Test Address');
    SET @TriggerError = 'No error raised';
END TRY
BEGIN CATCH
    SET @TriggerError = ERROR_MESSAGE();
END CATCH;
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'TriggerValidateNationalCode_Invalid',
    CASE 
        WHEN @TriggerError = CAST('Invalid National Code' AS NVARCHAR(4000)) THEN 'PASS'
        ELSE 'FAIL'
    END,
    'Invalid Code, Error: ' + @TriggerError;
GO

-- Test Education.SuggestCourses
DECLARE @SuggestedCourses TABLE (CourseID INT, CourseCode VARCHAR(10), CourseName VARCHAR(100), Credits INT);
EXEC Education.SuggestCourses @StudentID = 1, @SemesterID = 2;

INSERT INTO @SuggestedCourses(CourseID , CourseCode , CourseName , Credits)
SELECT  c.CourseID , c.CourseCode , c.CourseName , c.Credits
FROM Education.CourseSuggestions cs JOIN Education.Courses c ON cs.CourseID = c.CourseID
WHERE cs.StudentID = 1 AND cs.SemesterID = 2;


INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'SuggestCourses_Student1_Semester2',
    CASE 
        WHEN (SELECT COUNT(*) FROM @SuggestedCourses) = 1 THEN 'PASS' -- CS301, CS401 from CourseSuggestions
        ELSE 'FAIL'
    END,
    'StudentID 1, SemesterID 2, Expected count: 1, Got: ' + CAST((SELECT COUNT(*) FROM @SuggestedCourses) AS VARCHAR(10));
GO

-- Test Library.AddBook
DECLARE @NewBookID INT;
EXEC Library.AddBook 
    @CategoryID = 1, 
    @PublisherID = 1, 
    @ISBN = '9999999999999', 
    @Title = 'Test Book', 
    @PublicationYear = 2023, 
    @TotalCopies = 5, 
    @AvailableCopies = 5;
SET @NewBookID = (SELECT MAX(BookID) FROM Library.Books);
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'AddBook_Valid',
    CASE 
        WHEN EXISTS (SELECT 1 FROM Library.Books WHERE BookID = @NewBookID AND Title = 'Test Book') THEN 'PASS'
        ELSE 'FAIL'
    END,
    'New BookID: ' + CAST(@NewBookID AS VARCHAR(10)) + ', Title exists: ' + CASE WHEN EXISTS (SELECT 1 FROM Library.Books WHERE BookID = @NewBookID AND Title = 'Test Book') THEN 'Yes' ELSE 'No' END;
GO

-- Test Library.AddBook (Invalid ISBN)
DECLARE @AddBookError VARCHAR(100);
BEGIN TRY
    EXEC Library.AddBook 
        @CategoryID = 1, 
        @PublisherID = 1, 
        @ISBN = '12345', -- Invalid ISBN length
        @Title = 'Invalid Book', 
        @PublicationYear = 2023, 
        @TotalCopies = 5, 
        @AvailableCopies = 5;
    SET @AddBookError = 'No error raised';
END TRY
BEGIN CATCH
    SET @AddBookError = ERROR_MESSAGE();
END CATCH;
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'AddBook_InvalidISBN',
    CASE 
        WHEN @AddBookError LIKE 'Invalid ISBN' THEN 'PASS'
        ELSE 'FAIL'
    END,
    'Invalid ISBN, Error: ' + @AddBookError;
GO

-- Test Library.BorrowBook
DECLARE @NewLoanID INT;
EXEC Library.BorrowBook @LibraryUserID = 1, @BookID = 1, @DueDate = '2026-09-30';
SELECT @NewLoanID = MAX(LoanID) FROM Library.Loans WHERE LibraryUserID = 1 AND BookID = 1 AND DueDate = '2026-09-30';
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'BorrowBook_Valid',
    CASE 
        WHEN EXISTS (SELECT 1 FROM Library.Loans WHERE LoanID = @NewLoanID) 
             AND (SELECT AvailableCopies FROM Library.Books WHERE BookID = 1) = 6 THEN 'PASS' -- Trigger updates AvailableCopies
        ELSE 'FAIL'
    END,
    'LoanID: ' + CASE WHEN @NewLoanID IS NULL THEN 'null' ELSE CAST(@NewLoanID AS VARCHAR(10)) END + ', Loan exists: ' + CASE WHEN EXISTS (SELECT 1 FROM Library.Loans WHERE LoanID = @NewLoanID) THEN 'Yes' ELSE 'No' END 
    + ', AvailableCopies: ' + CAST((SELECT AvailableCopies FROM Library.Books WHERE BookID = 1) AS VARCHAR(10));
GO

-- Test Library.BorrowBook (Book Unavailable)
DECLARE @BorrowError VARCHAR(100);
BEGIN TRY
    UPDATE Library.Books SET AvailableCopies = 0 WHERE BookID = 4;
    EXEC Library.BorrowBook @LibraryUserID = 1, @BookID = 4, @DueDate = '2024-09-30';
    SET @BorrowError = 'No error raised';
END TRY
BEGIN CATCH
    SET @BorrowError = ERROR_MESSAGE();
END CATCH;
INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'BorrowBook_Unavailable',
    CASE 
        WHEN @BorrowError LIKE 'No available copies%' THEN 'PASS'
        ELSE 'FAIL'
    END,
    'BookID 4, Error: ' + @BorrowError;
GO


-- Test Student Role Functions
--EXECUTE AS USER = 'StudentUser';
--INSERT INTO #TestResults (TestName, Result, Message)
--SELECT 
--    'Student_GetStudentPassedCredits',
--    CASE 
--        WHEN Education.GetStudentPassedCredits(1) = 7 THEN 'PASS'
--        ELSE 'FAIL'
--    END,
--    'StudentUser, StudentID 1, Expected: 7, Got: ' + CAST(Education.GetStudentPassedCredits(1) AS VARCHAR(10));
--GO

--INSERT INTO #TestResults (TestName, Result, Message)
--SELECT 
--    'Student_GetSemesterCourses',
--    CASE 
--        WHEN (SELECT COUNT(*) FROM Education.GetSemesterCourses(1)) = 1 THEN 'PASS'
--        ELSE 'FAIL'
--    END,
--    'StudentUser, SemesterID 1, Expected count: 1, Got: ' + CAST((SELECT COUNT(*) FROM Education.GetSemesterCourses(1)) AS VARCHAR(10));
--GO

---- Test Student Direct Write to StudentCourses (Should Fail)
--EXECUTE AS USER = 'StudentUser';
--DECLARE @StudentWriteError VARCHAR(100);
--BEGIN TRY
--    INSERT INTO Education.StudentCourses (StudentID, OfferingID, Grade, EnrollmentDate)
--    VALUES (1, 1, 15.0, '2024-09-01');
--    SET @StudentWriteError = 'No error raised';
--END TRY
--BEGIN CATCH
--    SET @StudentWriteError = ERROR_MESSAGE();
--END CATCH;
--INSERT INTO #TestResults (TestName, Result, Message)
--SELECT 
--    'Student_DirectWrite_StudentCourses',
--    CASE 
--        WHEN @StudentWriteError LIKE 'The INSERT permission was denied%' THEN 'PASS'
--        ELSE 'FAIL'
--    END,
--    'StudentUser, Error: ' + ISNULL(@StudentWriteError, 'None');
--REVERT;
--GO

--EXECUTE AS USER = 'AdminUser';

-- Test Library.RecommendBooks
EXEC Library.RecommendBooks @LibraryUserID = 2;
DECLARE @RecommendedBooks TABLE (BookID INT, Title VARCHAR(100), RecommendationScore INT);
INSERT INTO @RecommendedBooks
SELECT b.BookID , b.Title , br.RecommendationScore
FROM Library.BookRecommendations br JOIN Library.Books b ON br.BookID = b.BookID
WHERE br.LibraryUserID = 2;

INSERT INTO #TestResults (TestName, Result, Message)
SELECT 
    'RecommendBooks_User2',
    CASE 
        WHEN (SELECT COUNT(*) FROM @RecommendedBooks) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    'LibraryUserID 2, Expected count: = 1, Got: ' + CAST((SELECT COUNT(*) FROM @RecommendedBooks) AS VARCHAR(10));
GO

-- Test Excel Export/Import (Students)
sp_configure
DECLARE @FilePathStudents VARCHAR(255) = 'C:\Temp\Students.csv';
BEGIN TRY
    EXEC Education.ExportStudentsToCSV @FilePathStudents;
    INSERT INTO #TestResults (TestName, Result, Message)
    SELECT 
        'ExportStudentsToCSV',
        'PASS',
        'File: ' + @FilePathStudents + ', Export successful';
END TRY
BEGIN CATCH
    INSERT INTO #TestResults (TestName, Result, Message)
    SELECT 
        'ExportStudentsToCSV',
        'FAIL',
        'File: ' + @FilePathStudents + ', Error: ' + ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')';
END CATCH;
GO

BEGIN TRY
    EXEC Education.ImportStudentsFromCSV @FilePathStudents;
    INSERT INTO #TestResults (TestName, Result, Message)
    SELECT 
        'ImportStudentsFromCSV',
        CASE 
            WHEN EXISTS (SELECT 1 FROM Education.Students WHERE StudentID > 50) THEN 'PASS'
            ELSE 'FAIL'
        END,
        'Imported students exist: ' + CASE WHEN EXISTS (SELECT 1 FROM Education.Students WHERE StudentID > 50) THEN 'Yes' ELSE 'No' END;
END TRY
BEGIN CATCH
    INSERT INTO #TestResults (TestName, Result, Message)
    SELECT 
        'ImportStudentsFromCSV',
        'FAIL',
        'Error: ' + ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')';
END CATCH;
GO

-- Test Excel Export/Import (Courses)
DECLARE @FilePathCourses VARCHAR(255) = 'C:\Temp\Courses.csv';
BEGIN TRY
    EXEC Education.ExportCoursesToCSV @FilePathCourses;
    INSERT INTO #TestResults (TestName, Result, Message)
    SELECT 
        'ExportCoursesToCSV',
        'PASS',
        'File: ' + @FilePathCourses + ', Export successful';
END TRY
BEGIN CATCH
    INSERT INTO #TestResults (TestName, Result, Message)
    SELECT 
        'ExportCoursesToCSV',
        'FAIL',
        'File: ' + @FilePathCourses + ', Error: ' + ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')';
END CATCH;
GO

BEGIN TRY
    EXEC Education.ImportCoursesFromCSV @FilePathCourses;
    INSERT INTO #TestResults (TestName, Result, Message)
    SELECT 
        'ImportCoursesFromCSV',
        CASE 
            WHEN EXISTS (SELECT 1 FROM Education.Courses WHERE CourseCode = 'CS101' AND DepartmentID = (SELECT DepartmentID FROM Education.Departments WHERE DepartmentName = 'Computer Engineering')) THEN 'PASS'
            ELSE 'FAIL'
        END,
        'Imported course CS101 exists: ' + CASE WHEN EXISTS (SELECT 1 FROM Education.Courses WHERE CourseCode = 'CS101' AND DepartmentID = (SELECT DepartmentID FROM Education.Departments WHERE DepartmentName = 'Computer Engineering')) THEN 'Yes' ELSE 'No' END;
END TRY
BEGIN CATCH
    INSERT INTO #TestResults (TestName, Result, Message)
    SELECT 
        'ImportCoursesFromCSV',
        'FAIL',
        'Error: ' + ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')';
END CATCH;
GO

-- Display test results
SELECT TestName, Result, Message FROM #TestResults;
GO

-- Display error log for diagnostics
SELECT ErrorLogID, ProcedureName, ErrorMessage, ErrorDate FROM Education.ErrorLog;
GO

-- Cleanup
DROP TABLE #TestResults;
GO