USE AcademicSystem;
GO

-- Drop procedures if they exist
IF OBJECT_ID('Library.BorrowBook') IS NOT NULL DROP PROCEDURE Library.BorrowBook;
IF OBJECT_ID('Library.ReturnBook') IS NOT NULL DROP PROCEDURE Library.ReturnBook;
IF OBJECT_ID('Library.RecommendBooks') IS NOT NULL DROP PROCEDURE Library.RecommendBooks;
IF OBJECT_ID('Library.AddBook') IS NOT NULL DROP PROCEDURE Library.AddBook;
GO

CREATE PROCEDURE Library.AddBook
    @CategoryID INT,
    @PublisherID INT,
    @ISBN VARCHAR(13),
    @Title NVARCHAR(200),
    @PublicationYear INT,
    @TotalCopies INT,
    @AvailableCopies INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

		IF @ISBN NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR EXISTS(SELECT 1 FROM Library.Books WHERE ISBN = @ISBN)
		BEGIN
			RAISERROR('Invalid ISBN' , 16 , 1);
			RETURN;
		END

        DECLARE @NewBookID INT;

        INSERT INTO Library.Books (CategoryID, PublisherID, ISBN, Title, PublicationYear, TotalCopies, AvailableCopies)
        VALUES (@CategoryID, @PublisherID, @ISBN, @Title, @PublicationYear, @TotalCopies, @AvailableCopies);

        SELECT @NewBookID = BookID
        FROM Library.Books
        WHERE ISBN = @ISBN;

        IF @NewBookID IS NULL
        BEGIN
            RAISERROR ('Failed to retrieve BookID. Insert into Library.Books failed.', 16, 1);
            ROLLBACK;
            RETURN;
        END;

        INSERT INTO Library.LibraryLog (EventType, EventDescription, PersonID)
        VALUES ('BookAdded', 'New book added: ' + @Title + ' (ID: ' + CAST(@NewBookID AS NVARCHAR) + ')', NULL);

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

-- Procedure to borrow a book
CREATE PROCEDURE Library.BorrowBook
    @LibraryUserID INT,
    @BookID INT,
    @DueDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    IF Library.GetAvailableBookCount(@BookID) = 0
    BEGIN
        RAISERROR ('No available copies', 16, 1);
        RETURN;
    END
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Library.Loans (LibraryUserID, BookID, DueDate)
        VALUES (@LibraryUserID, @BookID, @DueDate);

		DECLARE @NewLoanID INT;

		SELECT @NewLoanID = MAX(LoanID) FROM Library.Loans WHERE LibraryUserID = @LibraryUserID AND BookID = @BookID AND DueDate = @DueDate;
		
        INSERT INTO Library.LoanHistory (LoanID, Status)
        VALUES (@NewLoanID, 'Borrowed');
        INSERT INTO Library.LibraryLog (EventType, EventDescription, PersonID)
        VALUES ('BookBorrowed', 'Book ID ' + CAST(@BookID AS NVARCHAR) + ' borrowed', @LibraryUserID);
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- Procedure to return a book
CREATE PROCEDURE Library.ReturnBook
    @LoanID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @BookID INT, @LibraryUserID INT;
        SELECT @BookID = BookID, @LibraryUserID = LibraryUserID
        FROM Library.Loans
        WHERE LoanID = @LoanID;
        UPDATE Library.Loans
        SET ReturnDate = GETDATE()
        WHERE LoanID = @LoanID;
        UPDATE Library.Books
        SET AvailableCopies = AvailableCopies + 1
        WHERE BookID = @BookID;
        INSERT INTO Library.LoanHistory (LoanID, Status)
        VALUES (@LoanID, 'Returned');
        INSERT INTO Library.LibraryLog (EventType, EventDescription, PersonID)
        VALUES ('BookReturned', 'Book ID ' + CAST(@BookID AS NVARCHAR) + ' returned', @LibraryUserID);
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- Procedure for book recommendations using collaborative filtering
CREATE PROCEDURE Library.RecommendBooks
    @LibraryUserID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Clear existing recommendations for the user
    DELETE FROM Library.BookRecommendations WHERE LibraryUserID = @LibraryUserID;

    -- Insert new recommendations based on student's enrolled courses
    INSERT INTO Library.BookRecommendations (LibraryUserID, BookID, RecommendationScore)
    SELECT 
        @LibraryUserID,
        b.BookID,
        CASE 
            WHEN sc.StudentID IS NOT NULL THEN 2 -- Higher score for books matching enrolled courses
            ELSE 1 -- Lower score for category match only
        END AS RecommendationScore
    FROM Library.Books b
    INNER JOIN Library.Categories bc ON b.CategoryID = bc.CategoryID
    INNER JOIN Education.Courses c ON bc.CategoryName = CAST(c.DepartmentID AS NVARCHAR(50))
    LEFT JOIN Education.StudentCourses sc ON c.CourseID = sc.OfferingID 
        AND sc.StudentID = @LibraryUserID
    WHERE b.AvailableCopies > 0
        AND EXISTS (SELECT 1 FROM Library.LibraryUsers WHERE LibraryUserID = @LibraryUserID AND IsActive = 1);

    -- Log the recommendation event
    INSERT INTO Library.LibraryLog (EventType, EventDescription, EventDate, PersonID)
    VALUES ('RecommendationGenerated', 'Book recommendations generated for LibraryUserID ' + CAST(@LibraryUserID AS VARCHAR(10)), GETDATE(), @LibraryUserID);
END;
GO