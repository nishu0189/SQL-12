

--PROCEDURE:- is the database object 

-- DROP PROCEDURE new1


--CREATE PROCEDURE
create PROCEDURE  new1 as
select * from emp

-- EXECUTE PROCEDURE
exec new1

-----------------------------------------------PROCEDURE with INPUT VARIABLE @salary-----------------------------------------------------------------------------


--CHANGE THE PROCEDURE FUNC USING ALTER

ALTER procedure new1 (@salary int, @dept_id int) 
as
select *
from emp
where salary > @salary  AND dept_id = @dept_id;
----------------------------------------------
--run1
exec new1 @salary = 65000, @dept_id = 100

--OR RUN2 
exec new1  65000, 100

---------------------------------two table show in under t1 procedure---------------------------------------------------------------------------------

create procedure t1(@sal int , @dept int)
as 
select * from emp where salary > @sal
select * from dept where dept_id = @dept 

exec t1 50000, 100

------------------------------------------------insertion in procedure----------------------------------------------------------
Alter procedure new1 (@salary int, @dept_id int)
as
if NOT EXISTS ( Select 1 from dept where dept_id = 700) --If you run this multiple times, the same (700, 'data') row will be inserted each time unless you handle duplicates.      
insert into dept values(700,'data')  --insertion
select salary, dept_id  --selection form dept
from emp
where salary > @salary AND dept_id = @dept_id 
select * from dept -- both the table emp n dept will run under the new1 procedure

----------------------------------------------
--run
exec new1 @salary = 65000, @dept_id = 100

-- now delete from  dept where dept_id = 700 
delete from dept 
where dept_id = 700

-----------------------------------------------print func in procedure(declare variable)-----------------------------------------------------------------------------------

Alter procedure new1 (@salary int , @dept_id int)  
as
declare @cnt int                --1. declare variable cnt

select @cnt = count(*) from emp  --2. store the count in cnt
where dept_id = @dept_id

if (@cnt =0)                     --3. check is cnt is empty
print 'there is NO emp in this Dept ';  --4. print
else print 'there is ' + CAST(@cnt AS VARCHAR) + ' employee in ' + Cast(@dept_id AS VARCHAR)
----------------------------------------------

--------run
exec new1 5000 , 700



-----------------------------------------------------------OUTSIDE VARIABLE-----------------------------------------------------------------------

Alter procedure new1 (@dept_id int, @cnt int OUT) --OUTSIDE VARIABLE
AS
select @cnt = count(*) from emp
where @dept_id = dept_id

if (@cnt =0)
print 'NO EMP'
----------------------------------------------

-- create variable outside
declare @outside_cnt int

--execute variable
exec new1 100, @outside_cnt OUT

print  @outside_cnt -- can we print this variable outside the procedure


-----------------------------------------------------FUNCTIONS-----------------------------------------------------------------------------

select * from emp

-- drop function multi

------------------------------------------1.INTEGER PARAMETER FUNCTION
CREATE FUNCTION multi(@a int, @b int)
returns integer   --what will it return
as 
begin
return (select  @a * @b)
end;

select [dbo].[multi](2,4) as Result  --[dbo].[multi] means schema_name.obj_name



------------------------now we can use our multi function---------------------

select datepart(year,or_date), -- INBUILT FUNCTION
or_date,id, sales,
[dbo].[multi](id,sales) as our_func --SELF MADE FUNCTION
from orders;


---------------------------2. DECIMAL PARAMETER IN FUCTION----------------------------

Create function DecMulti(@a int , @b decimal(6,2))
returns decimal(6,2)
as
begin
return( select @a*@b)
end

select [dbo].[DecMulti](8,2.3)

--------------------3. DEFAULT PARAMETER IN FUCTION--------------
Create Function DefMulti(@a int, @b int = 100) --@b is default value
Returns int
as 
begin 
return (select @a*@b)
end

select [dbo].[DefMulti](4,default) -- @b = 100(default) 

select [dbo].[DefMulti](4,3) -- @b = 3

---------------------------------------PIVOT-------------------------------------------------------------------------------------------
--convert the row in the column view
/* category  year  sale                  PIVOTE:-  category   sale19  sale20
   A         2019  490                              A          490      NULL
   B         2019  60                               B          60       155 
   C         2020  800                              C          70       800
   C         2019  70                               
   B         2020  55                 THIS SHOWS the row yr of 2019 n 2020 in seperate col of sale19 n sale20        
   B         2020  100

*/



--this not the pivot operation but it achieve the pivot like transformation using conditional aggregation
Select category,
sum(case when datepart(year,or_date) = 2019 then sales end) as sale19,
sum(case when datepart(year,or_date)  = 2024 then sales end) as sale24
from orders
group by category

-----SAME 
  
--------------------------PIVOT OPERATION-----------------------------------------
select category , [2019] as sale19, [2024] as sale24
from
(
select category, DATEPART(year,or_date) as yrs , sales
from orders) SourceTable
PIVOT (
sum(sales) FOR yrs in ([2019],[2024])  --Integer value pass as the square bracket
) PivotTable


-------------------------------------------------------------

select * from 
(
Select category, region, sales
from orders) SourceTable
PIVOT(
SUM(Sales) FOR region IN (north,west,northeast) --As we have provide the northeast that is not such val then it show all the val NULL under this col
) PivotTable


-----------------------------------------------UNPIVOTE----------------------------------------------------------------

------------------using union 

SELECT category, '2019' AS year, sale19 AS sale FROM pivoted_sales_table
WHERE sale19 IS NOT NULL
UNION ALL
SELECT category, '2020' AS year, sale20 AS sale FROM pivoted_sales_table
WHERE sale20 IS NOT NULL;

------------------------------
SELECT category, year, sale
FROM (
    SELECT category, sale19, sale20
    FROM pivoted_sales_table  -- Replace with your actual pivoted table
) p
UNPIVOT (
    sale FOR year IN (sale19, sale20)
) AS unpvt;


-------------------------------------------------STORING RESULTS IN TABLE----------------------------------------------------------------

--just add (INTO + Table_name) in the Query , then the result of that query will store in the Table_name

-- drop table WEST_TABLE

Select id,region,sales INTO WEST_TABLE
from orders 
where region = 'west';

--see the resultant that was store in the WEST_TABLE 

select * from WEST_TABLE

------------------------------------OR------------------------------------

create table WEST__TABLE AS (Select id,region,sales  -- BUT IN OTHER DATABASS
from orders 
where region = 'west');

--------------------------------USE CASE OF CREATING TABLE OF RESULANTANT
 
 --1. create a table that contain val of orders table
 select * into order_backup  
 from orders

 --2. lets something gone wrong the orders table then delete the table
 Truncate table orders

 --3. again insert value in original orders table from the order_backup table
 insert into orders select * from order_backup

 --4. see all the value after insertion 
 select * from orders


 --all the ddl command like truncate, drop,alter,create can not be rollback(reverse)

 --delete can be rollback

----------------------------------------------------------------------------------------------------------------------------------



