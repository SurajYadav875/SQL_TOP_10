##Q1(a): Find the list of employees whose salary ranges between 2L to 3L.

select *
from employee
where Salary between 200000 and 300000;

##attempt 2

select *
from employee
where Salary >=200000 ;

##Q1(b): Write a query to retrieve the list of employees from the same city.
SELECT * FROM suraj.employee;

select *
From employee e1,
employee e2
where e1.city=e2.city and e1.EmpID != e2.EmpID;

#Q1(c): Query to find the null values in the Employee table.
select *
from employee
where EmpID is null;

#Q2(a): Query to find the cumulative sum of employee’s salary.

select	EmpName,salary,sum(salary) over(order by EmpId) as Cummalitav_salary
from employee;

#Q2(b): What’s the male and female employees ratio.

select
		(count(*) filter (where gender="M")*100.0 / count(*)) as Male, 
		(count(*) filter (where gender="F")*100.0 / count(*)) as Female

from employee;
SELECT
    (SUM(CASE WHEN [gender] = 'M' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS MALEPCT,
    (SUM(CASE WHEN [gender] = 'F' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS FEMALEPCT
FROM Employee;

#Q2(c): Write a query to fetch 50% records from the Employee table.
select * from employee
where empID<= (select Count(EmpID)/2 from employee)

##3.aQuery to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’##


select salary,concat(substring(salary::text,length(salary::text)-2)'xx')as masked_no
from employee
SELECT Salary, CONCAT(LEFT(CAST(Salary AS text), LEN(CAST(Salary AS text))-2), 'XX')
AS masked_number
FROM Employee

SELECT Salary,
CONCAT(LEFT(Salary, len(Salary)-2),'XX') as masked_salary
FROM Employee

select * from employee
SELECT Salary,
CONCAT(SUBSTRING(Salary::text, 1, LENGTH(Salary::text)-2), 'XX') as masked_number
FROM Employee

#Q4: Write a query to fetch even and odd rows from Employee table.

SELECT * FROM
(SELECT *, ROW_NUMBER() OVER(ORDER BY EmpId) AS
RowNumber
FROM Employee) AS Emp
WHERE Emp.RowNumber % 2 = 0

select* from
(select*,row_number() over(order by EmpId)as RowNumber
	from employee)as emp
where Emp.RowNumber%2=1

select* from employee
where mod(EmpID,2)=0;

#Q5(a): Write a query to find all the Employee names whose name:
#• Begin with ‘A’
#• Contains ‘A’ alphabet at second place
#• Contains ‘Y’ alphabet at second last place
#• Ends with ‘L’ and contains 4 alphabets
#• Begins with ‘V’ and ends with ‘A’#


SELECT * FROM Employee WHERE EmpName LIKE 'A%';
SELECT * FROM Employee WHERE EmpName LIKE '_a%';
SELECT * FROM Employee WHERE EmpName LIKE '%y_';
SELECT * FROM Employee WHERE EmpName LIKE '____l';
SELECT * FROM Employee WHERE EmpName LIKE 'V%a';

#Q5(b): Write a query to find the list of Employee names which is:
#• starting with vowels (a, e, i, o, or u), without duplicates
#• ending with vowels (a, e, i, o, or u), without duplicates
#• starting & ending with vowels (a, e, i, o, or u), without duplicates

SELECT DISTINCT EmpName
FROM Employee
WHERE LOWER(EmpName) REGEXP '^[aeiou]';

SELECT DISTINCT EmpName
FROM Employee
WHERE LOWER(EmpName) REGEXP '[aeiou]$';

SELECT DISTINCT EmpName
FROM Employee
WHERE LOWER(EmpName) REGEXP '^[aeiou].*[aeiou]$';

#Q6: Find Nth highest salary from employee table with and without using the TOP/LIMIT keywords.
select salary,EmpName from employee e1
where 2=(select count(distinct(e2.Salary))
				from employee e2
				where e2.salary>e1.Salary);

#Q7(a): Write a query to find and remove duplicate records from a table.

SELECT EmpID, EmpName, gender, Salary, city,
COUNT(*) AS duplicate_count
FROM Employee
GROUP BY EmpID, EmpName, gender, Salary, city
HAVING COUNT(*) > 1;

#Q7(b): Query to retrieve the list of employees working in same project.
with CTE as

(SELECT e.EmpID,E.EmpName,Ed.Project
from Employee e
inner Join EmployeeDetail ed
on e.EmpID= ed.EmpID)
select c1.EmpName, c2.EmpName, c1.project
from CTE c1, CTE c2
where c1.project=c2.project AND c1.EmpID != c2.EmpID AND c1.EmpID < c2.EmpID;
 
#Q8: Show the employee with the highest salary for each project

select ed.Project,max(e.salary) as highest_Salary_dept
from employee  e
inner join employeedetail ed
on e.EmpID=ed.EmpID
group by project
order by highest_Salary_dept desc;

WITH CTE AS
(SELECT project, EmpName, salary,
ROW_NUMBER() OVER (PARTITION BY project ORDER BY salary DESC) AS row_rank
FROM Employee AS e
INNER JOIN EmployeeDetail AS ed
ON e.EmpID = ed.EmpID)
SELECT project, EmpName, salary
FROM CTE
WHERE row_rank = 1;

#Q9: Query to find the total count of employees joined each year
SELECT extract(YEAR FROM ED.doj) AS JoinYear, COUNT(*) AS EmpCount
FROM Employee AS e
INNER JOIN EmployeeDetail AS ed ON e.EmpID = ed.EmpID
GROUP BY JoinYear
ORDER BY JoinYear ASC;


select * from EmployeeDetail;
#Q10: Create 3 groups based on salary col, salary less than 1L is low, between 1 -2L is medium and above 2L is High
SELECT EmpName, Salary,

CASE
WHEN Salary > 200000 THEN 'High'
WHEN Salary >= 100000 AND Salary <= 200000 THEN 'Medium'
ELSE 'Low'
END AS SalaryStatus

FROM Employee





