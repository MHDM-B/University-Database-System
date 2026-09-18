USE AcademicSystem;
GO

-- Drop triggers if they exist
IF OBJECT_ID('Education.TriggerStudentRegistration') IS NOT NULL DROP TRIGGER Education.TriggerStudentRegistration;
IF OBJECT_ID('Education.TriggerStudentStatusChange') IS NOT NULL DROP TRIGGER Education.TriggerStudentStatusChange;
IF OBJECT_ID('Shared.TriggerValidateNationalCode') IS NOT NULL DROP TRIGGER Shared.TriggerValidateNationalCode;
GO

-- Trigger to create library account on student registration
CREATE TRIGGER Education.TriggerStudentRegistration
ON Education.Students
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Library.LibraryUsers (LibraryUserID, RegistrationDate, IsActive)
    SELECT i.StudentID, i.EnrollmentDate, 1
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM Library.LibraryUsers WHERE LibraryUserID = i.StudentID
    );
    INSERT INTO Library.LibraryLog (EventType, EventDescription, PersonID)
    SELECT 'LibraryAccountCreated', 'Library account created for student ID ' + CAST(i.StudentID AS NVARCHAR), i.StudentID
    FROM inserted i;
END;
GO

-- Trigger to update library account status on student status change
CREATE TRIGGER Education.TriggerStudentStatusChange
ON Education.Students
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Status)
    BEGIN
        UPDATE Library.LibraryUsers
        SET IsActive = CASE 
            WHEN i.Status = 'Active' THEN 1 
            ELSE 0 
        END
        FROM inserted i
        JOIN deleted d ON i.StudentID = d.StudentID
        WHERE Library.LibraryUsers.LibraryUserID = i.StudentID
        AND i.Status != d.Status;
        
        INSERT INTO Library.LibraryLog (EventType, EventDescription, PersonID)
        SELECT 'LibraryAccountStatusChanged', 
               'Library account ' + CASE 
                   WHEN i.Status = 'Active' THEN 'activated' 
                   ELSE 'deactivated' 
               END + ' for student ID ' + CAST(i.StudentID AS NVARCHAR),
               i.StudentID
        FROM inserted i
        JOIN deleted d ON i.StudentID = d.StudentID
        WHERE i.Status != d.Status;
    END
END;
GO

-- Trigger to validate national code on person insertion (updated to include PersonID)
CREATE TRIGGER Shared.TriggerValidateNationalCode
ON Shared.Person
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE Education.IsNationalCodeValid(NationalCode) = 0)
    BEGIN
        RAISERROR ('Invalid National Code', 16, 1);
        RETURN;
    END
    INSERT INTO Shared.Person (NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address)
    SELECT NationalCode, FirstName, LastName, DateOfBirth, Email, PhoneNumber, Address
    FROM inserted;
END;
GO