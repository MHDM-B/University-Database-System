USE AcademicSystem;
GO

-- Drop function if it exists
IF OBJECT_ID('Shared.GenerateNationalCode') IS NOT NULL DROP FUNCTION Shared.GenerateNationalCode;
GO

-- Function to generate a valid national code based on an input number
CREATE FUNCTION Shared.GenerateNationalCode (@InputNumber INT)
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @BaseNumber VARCHAR(9),
            @NationalCode VARCHAR(10),
            @Sum INT,
            @N INT,
            @R INT;

    -- Generate a 9-digit base number by padding the input number
    -- Use a prefix (e.g., '12') and pad the input to ensure uniqueness
    SET @BaseNumber = '12' + RIGHT('000000' + CAST(@InputNumber AS VARCHAR(7)), 7);

    -- Avoid invalid patterns by adjusting if necessary
    IF @BaseNumber IN ('000000000', '111111111', '222222222', '333333333', '444444444', 
                       '555555555', '666666666', '777777777', '888888888', '999999999')
        SET @BaseNumber = '12' + RIGHT('000000' + CAST(@InputNumber + 1 AS VARCHAR(7)), 7);

    -- Calculate check digit
    SET @Sum = 0;
    SET @N = 10;

    WHILE @N > 1
    BEGIN
        SET @Sum = @Sum + (CONVERT(INT, SUBSTRING(@BaseNumber, 11 - @N, 1)) * @N);
        SET @N = @N - 1;
    END;

    SET @R = @Sum % 11;

    IF @R < 2
        SET @NationalCode = @BaseNumber + CAST(@R AS VARCHAR(1));
    ELSE
        SET @NationalCode = @BaseNumber + CAST(11 - @R AS VARCHAR(1));

    RETURN @NationalCode;
END;
GO