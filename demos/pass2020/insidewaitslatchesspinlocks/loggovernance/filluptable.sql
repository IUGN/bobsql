SET NOCOUNT ON;
GO
BEGIN TRANSACTION;
GO
DECLARE @x INT;
SET @x = 0;
WHILE (@x < 250000)
BEGIN
	INSERT INTO howboutthemcowboys VALUES (@x, 'x');
	SET @x = @x + 1;
END
GO
COMMIT TRANSACTION;
GO
SET NOCOUNT OFF;
GO


 