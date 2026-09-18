-- Create the database
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'AcademicSystem')
DROP DATABASE AcademicSystem;
GO

CREATE DATABASE AcademicSystem;
GO

USE AcademicSystem;
GO

-- Create schemas
CREATE SCHEMA Shared;
GO
CREATE SCHEMA Education;
GO
CREATE SCHEMA Library;
GO