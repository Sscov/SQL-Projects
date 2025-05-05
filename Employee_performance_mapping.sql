/*generate reports on employee details, their performance, and on the project that the employees have undertaken, 
 * to analyze the employee database and extract specific data based on different requirements. 
 */

/*                     TASK
 * To facilitate a better understanding, managers have provided ratings for each employee which will help the HR department 
 * to finalize the employee performance mapping. As a DBA, you should find the maximum salary of the employees and ensure that all 
 * jobs meet the organization's profile standard. You also need to calculate bonuses to find extra costs for expenses. 
 * This will improve the organization's overall performance by ensuring all the employees required receive training. */
 	


/*2)Create tables then import data_science_team.csv, proj_table.csv, and emp_record_table.csv 
 		into the employee database from the given resources. */


/*				Data_science_team
 * EMP_ID – ID of the employee
FIRST_NAME – First name of the employee
LAST_NAME – Last name of the employee
GENDER – Gender of the employee
ROLE – Post of the employee
DEPT – Field of the employee
EXP – Years of experience the employee has
COUNTRY – Country in which the employee is presently living
CONTINENT – Continent in which the country is
 */

CREATE TABLE IF NOT EXISTS Data_science_team(
EMP_ID Varchar(255) Not Null,
FIRST_NAME Varchar(255) NOT NULL,
LAST_NAME Varchar(255) NOT NULL,
GENDER Varchar(255),
ROLE Varchar(255),
DEPT Varchar(255),
EXP Integer,
COUNTRY Varchar(255),
CONTINENT Varchar(255),
Foreign Key (EMP_ID) References emp_record_table(EMP_ID)
);


/*					Proj_table
 * PROJECT_ID – ID for the project
PROJ_Name – Name of the project
DOMAIN – Field of the project
START_DATE – Day the project began
CLOSURE_DATE – Day the project was or will be completed
DEV_QTR – Quarter in which the project was scheduled
STATUS – Status of the project currently
 */

CREATE TABLE IF NOT EXISTS Proj_table(
PROJECT_ID Varchar(255) Primary Key Not Null,
PROJ_Name Varchar(255),
DOMAIN Varchar(255),
START_DATE Date,
CLOSURE_DATE Date,
DEV_QTR Varchar(255),
STATUS Varchar(255)
);



/*                emp_record_table       
											
EMP_ID – ID of the employee
FIRST_NAME – First name of the employee
LAST_NAME – Last name of the employee
GENDER – Gender of the employee
ROLE – Post of the employee
DEPT – Field of the employee
EXP – The employee’s years of experience
COUNTRY – The employee’s current country of residence
CONTINENT – The employee’s continent of residence
SALARY – Salary of the employee
EMP_RATING – Performance rating of the employee
MANAGER_ID – The manager mapped to the employee
PROJ_ID – The project on which the employee is working or has worked on
 */

CREATE TABLE IF NOT EXISTS emp_record_table(
EMP_ID Varchar(255) Primary KEY NOT NULL,
FIRST_NAME Varchar(255) NOT NULL,
LAST_NAME Varchar(255) NOT NULL,
GENDER Varchar(255),
ROLE Varchar(255),
DEPT Varchar(255),
EXP Integer,
COUNTRY Varchar(255),
CONTINENT Varchar(255),
SALARY Float,
EMP_RATING Integer,
MANAGER_ID Varchar(255),
PROJECT_ID Varchar(255),
Foreign Key (PROJECT_ID) References Proj_table(PROJECT_ID)
Foreign Key (MANAGER_ID) References emp_record_table(EMP_ID)
);

-- 4) Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, 
 	---and make a list of employees and details of their department.

SELECT 
EMP_ID,
FIRST_NAME,
LAST_NAME,
GENDER, 
DEPT as Department,
ROLE
FROM emp_record_table ert;  

 
-- * 5)Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
	--less than two return "Below Average", greater than four return "Above Average", and between two and four return "Average".

SELECT 
EMP_ID,
FIRST_NAME,
LAST_NAME,
GENDER, 
DEPT as Department,
EMP_RATING,
case 
	when (EMP_RATING) >4 then 'Above Average'
	when (EMP_RATING) between 2 and 4 then 'Average'
	when (EMP_RATING) <2 Then 'Below Average'
end as Employee_Rating
FROM emp_record_table ert;

-----------------------------
/* 6)
 Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table 
 	and then give the resultant column alias as NAME. */

SELECT 
concat(FIRST_NAME, ' ',LAST_NAME) as NAME
FROM emp_record_table ert 
WHERE ert.DEPT like 'Finance';

/*
 * 7)
 Write a query to list only those employees who have someone reporting to them. 
 	Also, show the number of reporters (including the President).*/


SELECT concat(ert2.FIRST_NAME, ' ', ert2.LAST_NAME) AS Manager_Name, ert2.ROLE, 
count(ert.EMP_ID) AS Reporting_Amount
FROM emp_record_table ert
JOIN emp_record_table ert2 ON ert.MANAGER_ID = ert2.EMP_ID
GROUP BY Manager_Name;

 /* 
 * 8)
  Write a query to list all the employees from the healthcare and finance departments using union. 
  	Take data from the employee record table.*/
  	
SELECT *
FROM emp_record_table ert
WHERE DEPT like 'Healthcare'
UNION
SELECT *
FROM emp_record_table ert
WHERE dept like 'Finance'
ORDER BY dept;
  	
 /* 
 * 9)
  Write a query to list employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, 
  	and EMP_RATING. Include the respective employee rating along with the max emp rating for each department.*/
  	
WITH CTE AS (
    SELECT DEPT, MAX(EMP_RATING) AS Max_Dept_Rating
    FROM emp_record_table ert
    GROUP BY DEPT
)
SELECT
ert.FIRST_NAME,
ert.LAST_NAME,
ert.ROLE,
ert.DEPT,
ert.EMP_RATING,
cte.Max_Dept_Rating
FROM emp_record_table ert
JOIN CTE cte ON ert.DEPT = cte.DEPT
ORDER BY ert.EMP_RATING DESC;

 /* 
 * 10)
 * Write a query to calculate the minimum and the maximum salary of the employees in each role. 
 * 		Take data from the employee record table. */

WITH CTE AS (
    SELECT role, 
    Min(ert.salary) AS Min_Role_Salary,
    MAX(ert.salary) AS Max_Role_Salary
    FROM emp_record_table ert
    GROUP BY role
)
SELECT
ert.FIRST_NAME,
ert.LAST_NAME,
ert.role,
ert.SALARY,
cte.Min_Role_Salary,
cte.Max_Role_Salary
FROM emp_record_table ert
JOIN CTE cte ON ert.role = cte.role
 Order By ert.salary desc;

 /* 11)
 	Write a query to assign ranks to each employee based on their experience. Take data from the employee record table. */

SELECT
EMP_ID,
FIRST_NAME,
LAST_NAME,
EXP,
rank() OVER (ORDER BY EXP DESC) AS Experience_Rank
FROM emp_record_table ert;

 /* 12)
 Write a query to create a view that displays employees in various countries whose salary is more than six thousand. 
 	Take data from the employee record table. */

CREATE VIEW High_Salary_Employees_by_Country AS
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    COUNTRY,
    SALARY
FROM emp_record_table  
WHERE SALARY > 6000 AND COUNTRY IS NOT NULL;

 -----------
 SELECT *
 FROM High_Salary_Employees_by_Country;
 --------

 /* 13)
 Write a nested query to find employees with experience of more than ten years. Take data from the employee record table. */
  
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    EXP
FROM emp_record_table   
WHERE EMP_ID IN (
			 	 SELECT
			     EMP_ID    
			     FROM emp_record_table    
			     WHERE EXP > 10
    			);

/* 14)
 Write a query to check whether the job profile assigned to each employee in the data science team matches the organization’s 
 		set standard.The standard being: 

For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'. */
 
SELECT 
EMP_ID,
FIRST_NAME,
LAST_NAME,
ROLE,
EXP,
case 
	when (dst.exp) between 12 and 16 then 'MANAGER'
	when (dst.exp) between 10 and 12 then 'LEAD DATA SCIENTIST'
	when (dst.exp) between 5 and 10 then 'SENIOR DATA SCIENTIST'
	When (dst.exp) between 2 and 5 then 'ASSOCIATE DATA SCIENTIST'
	when (dst.exp) between 0 and 2 then 'JUNIOR DATA SCIENTIST'
end as Standard_Check
FROM Data_science_team dst; 


/* 15)
 Write a query to calculate the bonus for all the employees, based on their ratings and salaries 
 	(Use the formula: 5% of salary * employee rating). */

SELECT 
concat(ert.FIRST_NAME, ' ',ert.LAST_NAME) as NAME,
(ert.SALARY * 0.05 * ert.EMP_RATING) as Bonus  
FROM emp_record_table ert; 


/* 16)
 Write a query to calculate the average salary distribution based on the continent and country. 
 	Take data from the employee record table.
 */


SELECT
CONTINENT,
COUNTRY,
round(AVG(SALARY) OVER (PARTITION BY COUNTRY), 2) AS Country_Average_Salary,
round(AVG(SALARY) OVER (PARTITION BY CONTINENT), 2) AS Continent_Average_Salary
FROM emp_record_table ert
GROUP BY CONTINENT, COUNTRY
ORDER BY Continent_Average_Salary, Country_Average_Salary ; 




