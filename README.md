# University Database System

A SQL Server database system designed to manage **university education and library operations** using relational database design, stored procedures, functions, triggers, access control, and automated data management.

## Features

* **Two database schemas**

  * Education
  * Library

* **Normalized relational database design**

  * 15+ tables for the Education schema
  * 10+ tables for the Library schema

* **Education management**

  * Student and course management
  * Course enrollment
  * Curriculum management
  * Semester and academic status management
  * GPA and remaining-credit calculations

* **Library management**

  * Student library accounts
  * Book management
  * Borrowing and returning
  * Library access control

* **Course recommendation system**

  * Considers the student's academic history
  * Uses curriculum and semester priorities
  * Recommends currently offered courses

* **Book recommendation system**

  * Uses simple collaborative filtering
  * Finds students with similar borrowing history
  * Recommends up to 3 relevant books

* **Database logic**

  * SQL functions
  * Stored procedures
  * Logical triggers
  * Event logging

* **Cross-schema automation**

  * Automatic library account creation after student registration
  * Library access management based on student status
  * National ID validation during initial registration

* **Role-based access control**

  * Admin permissions for student management
  * Librarian permissions for borrowing and returning
  * Student-level access to permitted functions and procedures
  * Controlled course enrollment

* **Data management**

  * Excel import/export using `BULK INSERT`
  * SQL Server Agent scheduled operations
  * Database backup

## Technologies

* **Microsoft SQL Server**
* **SQL Server Management Studio (SSMS)**
* **T-SQL**
* **SQL Server Agent**
* **BULK INSERT**

## Project Structure

```text
University-Database-System/
│
├── README.md
├── 1.create_database_and_schemas.sql
├── 2.create_tables.sql
├── 3.education_functions.sql
├── 4.education_procedures.sql
├── 5.education_triggers.sql
├── 6.library_functions.sql
├── 7.library_procedures.sql
├── 8.library_triggers.sql
├── 9.generate_national_code_function.sql
├── 10.enabling xp_cmdshell.sql
├── 11.excel_import_export.sql
├── 12.setup_roles_permissions.sql
├── 13.insert_data.sql
├── 14.test_functions_procedures.sql
└── AcademicSystem.bak
```

## Main SQL Components

| File                                    | Description                                     |
| --------------------------------------- | ----------------------------------------------- |
| `1.create_database_and_schemas.sql`     | Database and schema creation                    |
| `2.create_tables.sql`                   | Table definitions                               |
| `3.education_functions.sql`             | Education-related functions                     |
| `4.education_procedures.sql`            | Education stored procedures                     |
| `5.education_triggers.sql`              | Education triggers                              |
| `6.library_functions.sql`               | Library-related functions                       |
| `7.library_procedures.sql`              | Library stored procedures                       |
| `8.library_triggers.sql`                | Library triggers                                |
| `9.generate_national_code_function.sql` | National ID generation/validation functionality |
| `10.enabling xp_cmdshell.sql`           | Required SQL Server configuration               |
| `11.excel_import_export.sql`            | Excel data import/export                        |
| `12.setup_roles_permissions.sql`        | Database roles and permissions                  |
| `13.insert_data.sql`                    | Test/sample data                                |
| `14.test_functions_procedures.sql`      | Function and procedure tests                    |
| `AcademicSystem.bak`                    | SQL Server database backup                      |
