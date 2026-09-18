USE AcademicSystem;
GO

-- Drop functions if they exist
IF OBJECT_ID('Education.GetStudentPassedCredits') IS NOT NULL DROP FUNCTION Education.GetStudentPassedCredits;
IF OBJECT_ID('Education.GetSemesterCourses') IS NOT NULL DROP FUNCTION Education.GetSemesterCourses;
IF OBJECT_ID('Education.IsNationalCodeValid') IS NOT NULL DROP FUNCTION Education.IsNationalCodeValid;
GO

-- Function to calculate total credits passed by a student
CREATE FUNCTION Education.GetStudentPassedCredits (@StudentID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalCredits INT;
    SELECT @TotalCredits = SUM(c.Credits)
    FROM Education.StudentCourses sc
    JOIN Education.CourseOfferings co ON sc.OfferingID = co.OfferingID
    JOIN Education.Courses c ON co.CourseID = c.CourseID
    WHERE sc.StudentID = @StudentID
    AND sc.Grade >= 10; -- Assuming 10 is the passing grade
    RETURN ISNULL(@TotalCredits, 0);
END;
GO

-- Function to get courses offered in a specific semester
CREATE FUNCTION Education.GetSemesterCourses (@SemesterID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT c.CourseID, c.CourseCode, c.CourseName, c.Credits
    FROM Education.CourseOfferings co
    JOIN Education.Courses c ON co.CourseID = c.CourseID
    WHERE co.SemesterID = @SemesterID
);
GO

-- Function to validate national code (based on ISMELLICODE logic)
CREATE FUNCTION Education.IsNationalCodeValid (@NationalCode VARCHAR(10))
RETURNS BIT
AS
BEGIN
    DECLARE @first_number INT,
            @num INT,
            @counter INT = 0,
            @s INT = 0,
            @r INT,
            @i INT = 1;

    IF ISNUMERIC(@NationalCode) = 0 OR LEN(@NationalCode) != 10
        RETURN 0;

    SET @first_number = CAST(LEFT(@NationalCode, 1) AS INT);

    -- Loop through digits 1 to 9
    WHILE @i <= 9
    BEGIN
        SET @num = CAST(SUBSTRING(@NationalCode, @i, 1) AS INT);
        IF @num = @first_number
            SET @counter = @counter + 1;
        SET @s = @s + @num * (11 - @i);
        SET @i = @i + 1;
    END;

    -- Calculate control digit
    SET @r = @s % 11;
    IF @r > 1
        SET @r = 11 - @r;

    -- Check if control digit matches and not all digits are the same
    IF @r = CAST(RIGHT(@NationalCode, 1) AS INT) AND @counter < 9
        RETURN 1;
    
    RETURN 0;
END;
GO