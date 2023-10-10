create database Project;
create table Employee_Dept(
empNo int not null primary key,
Ename varchar(50),
Job varchar(50) default "CLERK",
 mgr int,
 HireDate date,
 sal int not null,
 comm int,
 deptno int,
  foreign key (deptno) references DEPT(deptno)
 
 );
 
 insert into Employee_Dept
 values(7369,"SMITH","CLERK",7902,'1890-12-17',800,null,20),
		(7499,"ALLEN","SALESMAN",7698,'1981-02-20',1600,300,30),
        (7521,"WARD","SALESMAN",7698,'1981-02-22',1250,500,30),
        (7566,"JONES","MANAGER",7839,'1981-04-02',2975,NULL,20),
        (7654,"MARTIN","SALESMAN",7698,'1981-09-28',1250,1400,30),
        (7698,"BLAKE","MANAGER",7839,'1981-05-01',2850,NULL,30),
        (7782,"CLARK","MANAGER",7839,'1981-06-09',2450,NULL,10),
        (7788,"SCOTT","ANALYST",7566,'1987-04-19',3000,NULL,20),
        (7839,"KING","PRESIDENT",null,'1981-11-17',5000,NULL,10),
        (7844,"TURNER","SALESMAN",7698,'1981-09-08',1500,0,30),
        (7876,"ADAMS","CLERK",7788,'1987-05-23',1100,NULL,20),
        (7900,"JAMES","CLERK",7698,'1981-12-03',950,NULL,30),
        (7902,"FORD","ANALYST",7566,'1981-12-03',3000,NULL,20),
        (7934,"MILLER","CLERK",7782,'1982-01-23',1300,NULL,10);
        
   CREATE TABLE DEPT(
   deptno int primary key,
   dname varchar(25),
   loc varchar(25)
   );
   
   insert into DEPT 
   values (10,"OPERTIONS","BOSTON"),
	(20,"RESEARCH","DALLAS"),
    (30,"SALES","CHICHAGO"),
    (40,"ACCOUNTING","NEW YORK");
    
    
   
    
     /***3.	List the Names and salary of the employee whose salary is greater than 1000*/
    
    select  
    Ename, 
    Job,  
    sal
    from employee_dept
    where sal > 1000
    order by sal desc;
    
   /*** 4.	List the details of the employees who have joined before end of September 81.***/
    SELECT *
FROM employee_dept
WHERE HireDate<('1981-1-1');
    
    
    /***5.	List Employee Names having I as second character****/
    
    SELECT Ename
FROM employee_dept 
WHERE Ename LIKE '_i%';
   
   
  /**** 6.	List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns****/
   
   select Ename as Name,
		sal,
        sal*0.4 as Allowances,
        sal*0.1 as PF,
        sal*0.5 as Net_salary 
        FROM employee_dept;
   
   
   /**** 7.List Employee Names with designations who does not report to anybody***/
   
   select Ename,
		Job
        FROM employee_dept
        WHERE mgr IS NULL;
   
    /*8.	List Empno, Ename and Salary in the ascending order of salary.*/
    
    select empNo,
    Ename,
    sal 
    from employee_dept 
    order by sal asc;
    
    /*9.	How many jobs are available in the Organization ?*/
    
    select count(distinct Job) 
    from employee_dept;

   /** 10.	Determine total payable salary of salesman category**/
   
   select sal,sum(sal)  as Total_payable_salary
   from employee_dept 
   where Job='SALESMAN';

   /*****11.	List average monthly salary for each job within each department  */
   
   select count(*),
   avg(sal),
   deptno,
   Ename,
   job
   from Employee_Dept
   group by job
   order by count(deptno) ;
   
   
   /****12.	Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working.***/
   
   SELECT 
		  e.Ename,
		  e.Job,  
		  e.sal, 
		  d.dname
FROM Employee_Dept e,
     DEPT d
WHERE e.deptno = d.deptno;
   
 /****  13.	  Create the Job Grades Table as below*/
 
 create table Job_Grade(
 grade varchar(5),
 lowest_sal int,
 highest_sal int
 );
   
   insert into	Job_Grade
   values ("A",0,999),
		("B",1000,1999),
        ("C",2000,2999),
        ("D",3000,3999),
        ("E",4000,5000);
   
  /***14.	Display the last name, salary and  Corresponding Grade. ***/
   
select E.ename,
		e.sal,
		J.grade
        from Employee_Dept E join Job_Grade J
        on E.sal between J.lowest_sal and J.highest_sal;
    
   /*15.	Display the Emp name and the Manager name under whom the Employee works in the below format Emp Report to Mgr.*/

   Select W.Ename "Emp Report", M. Ename " Manager" 
   From Employee_Dept W join Employee_Dept M on (w.mgr=m.empno) ;
   
   /*16.	Display Empname and Total sal where Total Sal (sal + Comm)*/
   
   select 
   Ename,
   sal,
   comm,
   sal+comm as Total_salary 
   from Employee_Dept;
   
   
 /*  17.	Display Empname and Sal whose empno is a odd number*/
 
    select Ename,
    sal,
    empNo 
    from Employee_Dept 
    where empNo % 2 =1;
    
    
    /*18.	Display Empname , Rank of sal in Organisation , Rank of Sal in their department*/
    
    select dense_rank() over (order by sal desc) as rank_org, 
    dense_rank () over (partition by deptno order by sal) as Rank_dept,
    deptno,
    Ename 
    from Employee_Dept;  

    
    /*19.	Display Top 3 Empnames based on their Salary*/

    select 
    Ename,
    sal 
    from Employee_Dept 
    order by sal desc limit 3;
    
/*20. Display Empname who has highest Salary in Each Department.*/
    
  select Ename,
	max(sal),
	dname
  from Employee_Dept E right join dept D on E.deptno = D.deptno 
  group by dname;  
    
