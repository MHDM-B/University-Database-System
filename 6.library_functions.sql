USE AcademicSystem;
GO

-- Drop functions if they exist
IF OBJECT_ID('Library.GetAvailableBookCount') IS NOT NULL DROP FUNCTION Library.GetAvailableBookCount;
IF OBJECT_ID('Library.GetUserLoanCount') IS NOT NULL DROP FUNCTION Library.GetUserLoanCount;
IF OBJECT_ID('Library.GetBooksByCategory') IS NOT NULL DROP FUNCTION Library.GetBooksByCategory;
GO

-- Function to get available copies of a book
CREATE FUNCTION Library.GetAvailableBookCount (@BookID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Available INT;
    SELECT @Available = AvailableCopies
    FROM Library.Books
    WHERE BookID = @BookID;
    RETURN ISNULL(@Available, 0);
END;
GO

-- Function to count active loans for a user
CREATE FUNCTION Library.GetUserLoanCount (@LibraryUserID INT)
RETURNS INT
AS
BEGIN
    DECLARE @LoanCount INT;
    SELECT @LoanCount = COUNT(*)
    FROM Library.Loans
    WHERE LibraryUserID = @LibraryUserID
    AND ReturnDate IS NULL;
    RETURN ISNULL(@LoanCount, 0);
END;
GO

-- Function to get books by category
CREATE FUNCTION Library.GetBooksByCategory (@CategoryID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT b.BookID, b.Title, b.ISBN
    FROM Library.Books b
    WHERE b.CategoryID = @CategoryID
);
GO