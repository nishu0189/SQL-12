# SQL-12
### 📘 SQL Practice: Procedures, Functions, Pivoting & Data Storage
This notebook showcases advanced SQL topics beyond basic querying — including Stored Procedures, User-Defined Functions, Pivot/Unpivot Operations, and Storing Query Results into Tables. These are commonly used in real-world SQL development, especially in BI reporting, ETL pipelines, and backend data processing.

### ✅ Topics Covered
🔹 Stored Procedures
Basic Procedure Creation

Executing procedures with EXEC

Input parameters to filter rows (e.g., @salary, @dept_id)

Returning multiple result sets from different tables

Conditional INSERT using IF NOT EXISTS

Using PRINT statements with declared variables

Declaring OUT parameters to pass values outside the procedure

Real-world scenario: check employee count and return message accordingly

🔹 Functions
Scalar functions returning INT and DECIMAL

Default parameters in functions

Using functions inside SELECT statements

Combining user-defined functions with built-in functions (e.g., DATEPART())

🔹 Pivoting Data
Pivot using conditional aggregation

sql
Copy
Edit
SUM(CASE WHEN year = 2024 THEN sales END)
Native PIVOT syntax using:

sql
Copy
Edit
PIVOT (SUM(sales) FOR year IN ([2019], [2024]))
Multi-dimensional pivoting using category & region

UNPIVOT operations using:

UNION ALL

UNPIVOT clause to convert columns back into rows

🔹 Storing Query Results into Tables
Creating backup or intermediate tables using SELECT ... INTO syntax

Use case: creating backups, rolling forward changes, or restoring tables

Difference between TRUNCATE, DELETE, and their rollback behavior

🗃️ Tables Used
emp: Employee data (e_id, dept_id, salary, age)

dept: Department metadata (dept_id, dept_name)

orders: Sales transaction table (id, or_date, region, sales, category)

📌 Key SQL Concepts Practiced
Dynamic procedures with parameters

Conditional logic using IF, EXISTS

String concatenation inside PRINT

Function overloading and default values

Year-wise pivoting and multi-region sales transformation

Safely inserting into tables using checks

Rebuilding original data using backup tables
