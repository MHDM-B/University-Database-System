USE AcademicSystem;
GO

-- Drop triggers if they exist
IF OBJECT_ID('Library.TriggerLoanStatus') IS NOT NULL DROP TRIGGER Library.TriggerLoanStatus;
IF OBJECT_ID('Library.TriggerBookAvailability') IS NOT NULL DROP TRIGGER Library.TriggerBookAvailability;
IF OBJECT_ID('Library.TriggerOverdueCheck') IS NOT NULL DROP TRIGGER Library.TriggerOverdueCheck;
GO

-- Trigger to log loan status changes
CREATE TRIGGER Library.TriggerLoanStatus
ON Library.Loans
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @statuses TABLE ([status] NVARCHAR(20));

    INSERT INTO Library.LoanHistory (LoanID, Status)
	OUTPUT inserted.Status into @statuses
    SELECT i.LoanID, CASE 
        WHEN i.ReturnDate IS NOT NULL THEN 'Returned'
        WHEN i.DueDate < GETDATE() THEN 'Overdue'
        ELSE 'Borrowed'
    END
    FROM inserted i
    LEFT JOIN deleted d ON i.LoanID = d.LoanID
    WHERE i.ReturnDate != d.ReturnDate OR d.LoanID IS NULL;
    
	DECLARE @status NVARCHAR(20);
	SELECT @status = [status] FROM @statuses;

	UPDATE Library.Books
	SET AvailableCopies = AvailableCopies + CASE WHEN @status = 'Returned' THEN 1 ELSE 0 END

    INSERT INTO Library.LibraryLog (EventType, EventDescription, PersonID)
    SELECT 'LoanStatusChanged', 
           'Loan ID ' + CAST(i.LoanID AS NVARCHAR) + ' status: ' + 
           CASE 
               WHEN i.ReturnDate IS NOT NULL THEN 'Returned'
               WHEN i.DueDate < GETDATE() THEN 'Overdue'
               ELSE 'Borrowed'
           END,
           i.LibraryUserID
    FROM inserted i
    LEFT JOIN deleted d ON i.LoanID = d.LoanID
    WHERE i.ReturnDate != d.ReturnDate OR d.LoanID IS NULL;
END;
GO

-- Trigger to prevent borrowing when no copies are available
CREATE TRIGGER Library.TriggerBookAvailability
ON Library.Loans
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Library.Books b ON i.BookID = b.BookID
        WHERE b.AvailableCopies = 0
    )
    BEGIN
        RAISERROR ('Cannot borrow book: No available copies', 16, 1);
        RETURN;
    END
    INSERT INTO Library.Loans (LibraryUserID, BookID, LoanDate, DueDate, ReturnDate)
    SELECT LibraryUserID, BookID, LoanDate, DueDate, ReturnDate
    FROM inserted;
    UPDATE Library.Books
    SET AvailableCopies = AvailableCopies - 1
    FROM inserted i
    WHERE Library.Books.BookID = i.BookID;
END;
GO

-- Trigger to mark overdue loans
CREATE TRIGGER Library.TriggerOverdueCheck
ON Library.Loans
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.LoanID = d.LoanID
        WHERE i.ReturnDate IS NULL AND i.DueDate < GETDATE() AND i.DueDate != d.DueDate
    )
    BEGIN
        INSERT INTO Library.LoanHistory (LoanID, Status)
        SELECT i.LoanID, 'Overdue'
        FROM inserted i
        WHERE i.ReturnDate IS NULL AND i.DueDate < GETDATE();
        
        INSERT INTO Library.LibraryLog (EventType, EventDescription, PersonID)
        SELECT 'LoanOverdue', 
               'Loan ID ' + CAST(i.LoanID AS NVARCHAR) + ' marked as overdue',
               i.LibraryUserID
        FROM inserted i
        WHERE i.ReturnDate IS NULL AND i.DueDate < GETDATE();
    END
END;
GO