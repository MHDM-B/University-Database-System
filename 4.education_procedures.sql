USE AcademicSystem;
GO

-- Drop procedures if they exist
IF OBJECT_ID('Education.AddStudent') IS NOT NULL DROP PROCEDURE Education.AddStudent;
IF OBJECT_ID('Education.SuggestCourses') IS NOT NULL DROP PROCEDURE Education.SuggestCourses;
IF OBJECT_ID('Education.UpdateStudentStatus') IS NOT NULL DROP PROCEDURE Education.UpdateStudentStatus;
GO

-- Procedure to add a new student
CREATE PROCEDURE Education.AddStudent
    @NationalCode VARCHAR(10),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DateOfBirth DATE,
    @Email NVARCHAR(100),
    @PhoneNumber VARCHAR(15),
    @Address NVARCHAR(200),
    @DepartmentID INT,
    @EnrollmentDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    IF Education.IsNationalCodeValid(@NationalCode) = 0
    BEGIN
        RAISERROR ('Invalid National Code', 16, 1);
        RETURN;
    END
    BEGIN TRY
        BEGIN TRANSACTION;

		DECLARE @InsertedIDs TABLE (PersonID INT);

        INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
        VALUES (@NationalCode, @FirstName, @LastName, @DateOfBirth, @Email, @PhoneNumber, @Address);

        DECLARE @PersonID INT;
		SELECT @PersonID = PersonID
        FROM Shared.Person
        WHERE NationalCode = @NationalCode;

        INSERT INTO Education.Students (StudentID, DepartmentID, EnrollmentDate, Status)
        VALUES (@PersonID, @DepartmentID, @EnrollmentDate, 'Active');
        INSERT INTO Education.EducationLog (EventType, EventDescription, PersonID)
        VALUES ('StudentAdded', 'New student registered: ' + @FirstName + ' ' + @LastName, @PersonID);
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- Procedure to suggest courses for a student based on curriculum
CREATE PROCEDURE Education.SuggestCourses
    @StudentID INT,
    @SemesterID INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Education.CourseSuggestions (StudentID, CourseID, SemesterID, [Priority])
    SELECT @StudentID, cc.CourseID, @SemesterID, cc.SemesterPriority
    FROM Education.CurriculumCourses cc
    JOIN Education.Curriculums c ON cc.CurriculumID = c.CurriculumID
    JOIN Education.Students s ON c.DepartmentID = s.DepartmentID
    JOIN Education.CourseOfferings co ON cc.CourseID = co.CourseID AND co.SemesterID = @SemesterID
    WHERE s.StudentID = @StudentID
    AND cc.CourseID NOT IN (
        SELECT co.CourseID
        FROM Education.StudentCourses sc
        JOIN Education.CourseOfferings co ON sc.OfferingID = co.OfferingID
        WHERE sc.StudentID = @StudentID AND sc.Grade >= 10
    )
    AND NOT EXISTS (
        SELECT 1
        FROM Education.CourseSuggestions cs
        WHERE cs.StudentID = @StudentID AND cs.CourseID = cc.CourseID AND cs.SemesterID = @SemesterID
    );
END;
GO

-- Procedure to update student status
CREATE PROCEDURE Education.UpdateStudentStatus
    @StudentID INT,
    @NewStatus NVARCHAR(20),
    @Reason NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    IF @NewStatus NOT IN ('Active', 'Graduated', 'Expelled', 'Withdrawn')
    BEGIN
        RAISERROR ('Invalid status', 16, 1);
        RETURN;
    END
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE Education.Students
        SET Status = @NewStatus
        WHERE StudentID = @StudentID;
        INSERT INTO Education.StudentStatusHistory (StudentID, Status, Reason)
        VALUES (@StudentID, @NewStatus, @Reason);
        INSERT INTO Education.EducationLog (EventType, EventDescription, PersonID)
        VALUES ('StatusUpdated', 'Student status changed to ' + @NewStatus + ': ' + @Reason, @StudentID);
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO