USE AcademicSystem;
GO

-- Export Students to CSV
IF OBJECT_ID('Education.ExportStudentsToCSV') IS NOT NULL DROP PROCEDURE Education.ExportStudentsToCSV;
GO
CREATE PROCEDURE Education.ExportStudentsToCSV
    @FilePath VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validate file path
        IF @FilePath IS NULL OR @FilePath = ''
            THROW 50001, 'File path cannot be empty.', 1;

        -- Check if xp_cmdshell is enabled
        IF NOT EXISTS (SELECT 1 FROM sys.configurations WHERE name = 'xp_cmdshell' AND value_in_use = 1)
            THROW 50002, 'xp_cmdshell is disabled. Enable it using sp_configure.', 1;

        DECLARE @Command NVARCHAR(4000) = 'bcp "SELECT p.NationalCode, p.FirstName, p.LastName, s.EnrollmentDate, s.Status, d.DepartmentName FROM AcademicSystem.Education.Students s INNER JOIN Shared.Person p ON s.StudentID = p.PersonID INNER JOIN Education.Departments d ON s.DepartmentID = d.DepartmentID" queryout ' + QUOTENAME(@FilePath, '"') + ' -c -T -S ' + QUOTENAME(@@SERVERNAME, '"');
        EXEC xp_cmdshell @Command;

        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ExportStudentsToCSV', 'Successfully exported students to ' + @FilePath, GETDATE());
    END TRY
    BEGIN CATCH
        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ExportStudentsToCSV', ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')', GETDATE());
        THROW;
    END CATCH;
END;
GO

-- Import Students from CSV
IF OBJECT_ID('Education.ImportStudentsFromCSV') IS NOT NULL DROP PROCEDURE Education.ImportStudentsFromCSV;
GO
CREATE PROCEDURE Education.ImportStudentsFromCSV
    @FilePath VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validate file path
        IF @FilePath IS NULL OR @FilePath = ''
            THROW 50001, 'File path cannot be empty.', 1;

        -- Check if file exists
        DECLARE @FileExists INT;
        DECLARE @FileCheck TABLE (FileExists INT, DirectoryExists INT, ParentDirectoryExists INT);
        INSERT INTO @FileCheck
        EXEC xp_fileexist @FilePath;
        SELECT @FileExists = FileExists FROM @FileCheck;
        IF @FileExists = 0
            THROW 50003, 'File does not exist error ', 1;

        -- Create temporary table
        IF OBJECT_ID('tempdb..#TempStudents') IS NOT NULL DROP TABLE #TempStudents;
        CREATE TABLE #TempStudents (
            NationalCode VARCHAR(10),
            FirstName VARCHAR(50),
            LastName VARCHAR(50),
            EnrollmentDate DATE,
            Status VARCHAR(20),
            DepartmentName VARCHAR(100)
        );

        -- BULK INSERT with QUOTENAME for safe file path
        DECLARE @Sql NVARCHAR(4000) = 'BULK INSERT #TempStudents FROM ' + QUOTENAME(@FilePath, '''') + ' WITH (FIELDTERMINATOR = ''\t'', ROWTERMINATOR = ''\n'', FIRSTROW = 2)';
        EXEC sp_executesql @Sql;

        -- Process imported data
        DECLARE @NationalCode VARCHAR(10), @FirstName VARCHAR(50), @LastName VARCHAR(50), @EnrollmentDate DATE, @Status VARCHAR(20), @DepartmentName VARCHAR(100), @DepartmentID INT;
        DECLARE student_cursor CURSOR FOR
        SELECT NationalCode, FirstName, LastName, EnrollmentDate, Status, DepartmentName FROM #TempStudents;
        OPEN student_cursor;
        FETCH NEXT FROM student_cursor INTO @NationalCode, @FirstName, @LastName, @EnrollmentDate, @Status, @DepartmentName;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @DepartmentID = (SELECT DepartmentID FROM Education.Departments WHERE DepartmentName = @DepartmentName);
            IF @DepartmentID IS NULL
                THROW 50004, 'Department does not exist.', 1;
            IF Education.IsNationalCodeValid(@NationalCode) != ''
                THROW 50005, 'Invalid national code ', 1;

            EXEC Education.AddStudent @NationalCode, @FirstName, @LastName, @DepartmentID, @EnrollmentDate;
            FETCH NEXT FROM student_cursor INTO @NationalCode, @FirstName, @LastName, @EnrollmentDate, @Status, @DepartmentName;
        END;
        CLOSE student_cursor;
        DEALLOCATE student_cursor;

        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ImportStudentsFromCSV', 'Successfully imported students from ' + @FilePath, GETDATE());
    END TRY
    BEGIN CATCH
        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ImportStudentsFromCSV', ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')', GETDATE());
        IF CURSOR_STATUS('global', 'student_cursor') >= 0
        BEGIN
            CLOSE student_cursor;
            DEALLOCATE student_cursor;
        END;
        THROW;
    END CATCH;
END;
GO

-- Export Curriculums to CSV
IF OBJECT_ID('Education.ExportCurriculumsToCSV') IS NOT NULL DROP PROCEDURE Education.ExportCurriculumsToCSV;
GO
CREATE PROCEDURE Education.ExportCurriculumsToCSV
    @FilePath VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @FilePath IS NULL OR @FilePath = ''
            THROW 50001, 'File path cannot be empty.', 1;

        IF NOT EXISTS (SELECT 1 FROM sys.configurations WHERE name = 'xp_cmdshell' AND value_in_use = 1)
            THROW 50002, 'xp_cmdshell is disabled. Enable it using sp_configure.', 1;

        DECLARE @Command NVARCHAR(4000) = 'bcp "SELECT c.CurriculumName, d.DepartmentName, c.StartYear FROM AcademicSystem.Education.Curriculums c INNER JOIN Education.Departments d ON c.DepartmentID = d.DepartmentID" queryout ' + QUOTENAME(@FilePath, '"') + ' -c -T -S ' + QUOTENAME(@@SERVERNAME, '"');
        EXEC xp_cmdshell @Command;

        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ExportCurriculumsToCSV', 'Successfully exported curriculums to ' + @FilePath, GETDATE());
    END TRY
    BEGIN CATCH
        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ExportCurriculumsToCSV', ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')', GETDATE());
        THROW;
    END CATCH;
END;
GO

-- Import Curriculums from CSV
IF OBJECT_ID('Education.ImportCurriculumsFromCSV') IS NOT NULL DROP PROCEDURE Education.ImportCurriculumsFromCSV;
GO
CREATE PROCEDURE Education.ImportCurriculumsFromCSV
    @FilePath VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @FilePath IS NULL OR @FilePath = ''
            THROW 50001, 'File path cannot be empty.', 1;

        DECLARE @FileExists INT;
        DECLARE @FileCheck TABLE (FileExists INT, DirectoryExists INT, ParentDirectoryExists INT);
        INSERT INTO @FileCheck
        EXEC xp_fileexist @FilePath;
        SELECT @FileExists = FileExists FROM @FileCheck;
        IF @FileExists = 0
            THROW 50003, 'File does not exist ', 1;

        IF OBJECT_ID('tempdb..#TempCurriculums') IS NOT NULL DROP TABLE #TempCurriculums;
        CREATE TABLE #TempCurriculums (
            CurriculumName VARCHAR(100),
            DepartmentName VARCHAR(100),
            StartYear INT
        );

        DECLARE @Sql NVARCHAR(4000) = 'BULK INSERT #TempCurriculums FROM ' + QUOTENAME(@FilePath, '''') + ' WITH (FIELDTERMINATOR = ''\t'', ROWTERMINATOR = ''\n'', FIRSTROW = 2)';
        EXEC sp_executesql @Sql;

        INSERT INTO Education.Curriculums (DepartmentID, CurriculumName, StartYear)
        SELECT d.DepartmentID, t.CurriculumName, t.StartYear
        FROM #TempCurriculums t
        INNER JOIN Education.Departments d ON t.DepartmentName = d.DepartmentName
        WHERE NOT EXISTS (
            SELECT 1 FROM Education.Curriculums c 
            WHERE c.CurriculumName = t.CurriculumName AND c.DepartmentID = d.DepartmentID
        );

        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ImportCurriculumsFromCSV', 'Successfully imported curriculums from ' + @FilePath, GETDATE());
    END TRY
    BEGIN CATCH
        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ImportCurriculumsFromCSV', ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')', GETDATE());
        THROW;
    END CATCH;
END;
GO

-- Export Books to CSV
IF OBJECT_ID('Library.ExportBooksToCSV') IS NOT NULL DROP PROCEDURE Library.ExportBooksToCSV;
GO
CREATE PROCEDURE Library.ExportBooksToCSV
    @FilePath VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @FilePath IS NULL OR @FilePath = ''
            THROW 50001, 'File path cannot be empty.', 1;

        IF NOT EXISTS (SELECT 1 FROM sys.configurations WHERE name = 'xp_cmdshell' AND value_in_use = 1)
            THROW 50002, 'xp_cmdshell is disabled. Enable it using sp_configure.', 1;

        DECLARE @Command NVARCHAR(4000) = 'bcp "SELECT b.ISBN, b.Title, c.CategoryName, p.PublisherName, b.PublicationYear, b.TotalCopies, b.AvailableCopies FROM AcademicSystem.Library.Books b INNER JOIN Library.Categories c ON b.CategoryID = c.CategoryID INNER JOIN Library.Publishers p ON b.PublisherID = p.PublisherID" queryout ' + QUOTENAME(@FilePath, '"') + ' -c -T -S ' + QUOTENAME(@@SERVERNAME, '"');
        EXEC xp_cmdshell @Command;

        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ExportBooksToCSV', 'Successfully exported books to ' + @FilePath, GETDATE());
    END TRY
    BEGIN CATCH
        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ExportBooksToCSV', ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')', GETDATE());
        THROW;
    END CATCH;
END;
GO

-- Import Books from CSV
IF OBJECT_ID('Library.ImportBooksFromCSV') IS NOT NULL DROP PROCEDURE Library.ImportBooksFromCSV;
GO
CREATE PROCEDURE Library.ImportBooksFromCSV
    @FilePath VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @FilePath IS NULL OR @FilePath = ''
            THROW 50001, 'File path cannot be empty.', 1;

        DECLARE @FileExists INT;
        DECLARE @FileCheck TABLE (FileExists INT, DirectoryExists INT, ParentDirectoryExists INT);
        INSERT INTO @FileCheck
        EXEC xp_fileexist @FilePath;
        SELECT @FileExists = FileExists FROM @FileCheck;
        IF @FileExists = 0
            THROW 50003, 'File does not exist ', 1;

        IF OBJECT_ID('tempdb..#TempBooks') IS NOT NULL DROP TABLE #TempBooks;
        CREATE TABLE #TempBooks (
            ISBN VARCHAR(13),
            Title VARCHAR(100),
            CategoryName VARCHAR(50),
            PublisherName VARCHAR(100),
            PublicationYear INT,
            TotalCopies INT,
            AvailableCopies INT
        );

        DECLARE @Sql NVARCHAR(4000) = 'BULK INSERT #TempBooks FROM ' + QUOTENAME(@FilePath, '''') + ' WITH (FIELDTERMINATOR = ''\t'', ROWTERMINATOR = ''\n'', FIRSTROW = 2)';
        EXEC sp_executesql @Sql;

        DECLARE @ISBN VARCHAR(13), @Title VARCHAR(100), @CategoryName VARCHAR(50), @PublisherName VARCHAR(100), 
                @PublicationYear INT, @TotalCopies INT, @AvailableCopies INT;
        DECLARE book_cursor CURSOR FOR
        SELECT ISBN, Title, CategoryName, PublisherName, PublicationYear, TotalCopies, AvailableCopies FROM #TempBooks;
        OPEN book_cursor;
        FETCH NEXT FROM book_cursor INTO @ISBN, @Title, @CategoryName, @PublisherName, @PublicationYear, @TotalCopies, @AvailableCopies;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @CategoryID INT = (SELECT CategoryID FROM Library.Categories WHERE CategoryName = @CategoryName);
            DECLARE @PublisherID INT = (SELECT PublisherID FROM Library.Publishers WHERE PublisherName = @PublisherName);
            IF @CategoryID IS NULL
                THROW 50005, 'Category does not exist.', 1;
            IF @PublisherID IS NULL
                THROW 50006, 'Publisher does not exist.', 1;
            IF LEN(@ISBN) != 13
                THROW 50007, 'Invalid ISBN: ', 1;

            EXEC Library.AddBook @CategoryID, @PublisherID, @ISBN, @Title, @PublicationYear, @TotalCopies, @AvailableCopies;
            FETCH NEXT FROM book_cursor INTO @ISBN, @Title, @CategoryName, @PublisherName, @PublicationYear, @TotalCopies, @AvailableCopies;
        END;
        CLOSE book_cursor;
        DEALLOCATE book_cursor;

        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ImportBooksFromCSV', 'Successfully imported books from ' + @FilePath, GETDATE());
    END TRY
    BEGIN CATCH
        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ImportBooksFromCSV', ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')', GETDATE());
        IF CURSOR_STATUS('global', 'book_cursor') >= 0
        BEGIN
            CLOSE book_cursor;
            DEALLOCATE book_cursor;
        END;
        THROW;
    END CATCH;
END;
GO

-- Export Courses to CSV
IF OBJECT_ID('Education.ExportCoursesToCSV') IS NOT NULL DROP PROCEDURE Education.ExportCoursesToCSV;
GO
CREATE PROCEDURE Education.ExportCoursesToCSV
    @FilePath VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @FilePath IS NULL OR @FilePath = ''
            THROW 50001, 'File path cannot be empty.', 1;

        IF NOT EXISTS (SELECT 1 FROM sys.configurations WHERE name = 'xp_cmdshell' AND value_in_use = 1)
            THROW 50002, 'xp_cmdshell is disabled. Enable it using sp_configure.', 1;

        DECLARE @Command NVARCHAR(4000) = 'bcp "SELECT c.CourseCode, c.CourseName, d.DepartmentName, c.Credits FROM AcademicSystem.Education.Courses c INNER JOIN Education.Departments d ON c.DepartmentID = d.DepartmentID" queryout ' + QUOTENAME(@FilePath, '"') + ' -c -T -S ' + QUOTENAME(@@SERVERNAME, '"');
        EXEC xp_cmdshell @Command;

        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ExportCoursesToCSV', 'Successfully exported courses to ' + @FilePath, GETDATE());
    END TRY
    BEGIN CATCH
        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ExportCoursesToCSV', ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')', GETDATE());
        THROW;
    END CATCH;
END;
GO

-- Import Courses from CSV
IF OBJECT_ID('Education.ImportCoursesFromCSV') IS NOT NULL DROP PROCEDURE Education.ImportCoursesFromCSV;
GO
CREATE PROCEDURE Education.ImportCoursesFromCSV
    @FilePath VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @FilePath IS NULL OR @FilePath = ''
            THROW 50001, 'File path cannot be empty.', 1;

        DECLARE @FileExists INT;
        DECLARE @FileCheck TABLE (FileExists INT, DirectoryExists INT, ParentDirectoryExists INT);
        INSERT INTO @FileCheck
        EXEC xp_fileexist @FilePath;
        SELECT @FileExists = FileExists FROM @FileCheck;
        IF @FileExists = 0
            THROW 50003, 'File does not exist ', 1;

        IF OBJECT_ID('tempdb..#TempCourses') IS NOT NULL DROP TABLE #TempCourses;
        CREATE TABLE #TempCourses (
            CourseCode VARCHAR(10),
            CourseName VARCHAR(100),
            DepartmentName VARCHAR(100),
            Credits INT
        );

        DECLARE @Sql NVARCHAR(4000) = 'BULK INSERT #TempCourses FROM ' + QUOTENAME(@FilePath, '''') + ' WITH (FIELDTERMINATOR = ''\t'', ROWTERMINATOR = ''\n'', FIRSTROW = 2)';
        EXEC sp_executesql @Sql;

        INSERT INTO Education.Courses (DepartmentID, CourseCode, CourseName, Credits)
        SELECT d.DepartmentID, t.CourseCode, t.CourseName, t.Credits
        FROM #TempCourses t
        INNER JOIN Education.Departments d ON t.DepartmentName = d.DepartmentName
        WHERE NOT EXISTS (
            SELECT 1 FROM Education.Courses c 
            WHERE c.CourseCode = t.CourseCode AND c.DepartmentID = d.DepartmentID
        );

        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ImportCoursesFromCSV', 'Successfully imported courses from ' + @FilePath, GETDATE());
    END TRY
    BEGIN CATCH
        INSERT INTO Education.ErrorLog (ProcedureName, ErrorMessage, ErrorDate)
        VALUES ('ImportCoursesFromCSV', ERROR_MESSAGE() + ' (Line: ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ')', GETDATE());
        THROW;
    END CATCH;
END;
GO