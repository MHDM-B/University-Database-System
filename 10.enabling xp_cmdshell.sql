USE master;
GO

-- Enable advanced options (required to configure xp_cmdshell)
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

-- Enable xp_cmdshell
EXEC sp_configure 'xp_cmdshell', 1;
GO
RECONFIGURE;
GO

-- Optionally, hide advanced options after enabling xp_cmdshell
EXEC sp_configure 'show advanced options', 0;
GO
RECONFIGURE;
GO