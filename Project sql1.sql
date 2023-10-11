use project;
create table salespeople(snum int primary key,sname char(12) not null,city char(12) not null,comm int);
insert into salespeople values(1001,'Peel','London',0.12); 
insert into salespeople values(1002,'Serres','San Jose',0.13); 
insert into salespeople values(1003,'Axle Rod','New York',0.10); 
insert into salespeople values(1004,'Motika','London',0.11); 
insert into salespeople values(1007,'Refkin','Barcelona',0.15);


create table Cust (cnum int primary key,cname char(12),city char(12),rating int,snum int not null);
insert into Cust values (2001,'Hoffman','London',100,1001);
insert into Cust values (2002,'Giovanne','Rome',200,1003);  
insert into Cust values (2003,'Liu','San Jose',300,1002);  
insert into Cust values (2004,'Grass','Berlin',100,1002);  
insert into Cust values (2006,'Clemens','London',300,1007);  
insert into Cust values (2007,'pereira','Rome',100,1004);  
insert into Cust values (2008,'James','London',200,1007); 
use project;   

show tables;
desc cust;
select * from cust;


create table orders (onum int primary key,amt int,odate date,cnum int,snum int);

insert into orders values (3001,18.69,'1994-10-03',2008,1007);
insert into orders values (3002,1900.10,'1994-10-03',2007,1004);
insert into orders values (3003,767.19,'1994-10-03',2001,1001);
insert into orders values (3005,5160.45,'1994-10-03',2003,1002);
insert into orders values (3006,1098.16,'1994-10-04',2008,1007);
insert into orders values (3007,75.75,'1994-10-05',2004,1002);
insert into orders values (3008,4723.00,'1994-10-05',2006,1001);
insert into orders values (3009,1717.23,'1994-10-04',2002,1003);
insert into orders values (3010,1309.95,'1994-10-06',2004,1002);
insert into orders values (3011,9891.88,'1994-10-06',2006,1001);
select * from orders;

select sname,cname,s.city from salespeople s join cust c on
(s.city=c.city);


select distinct sname,cname from salespeople s join cust c on
(s.snum=c.snum);

select distinct onum,cname from cust c join salespeople s on
(s.city<>c.city and s.snum=c.snum) inner join orders o on (c.cnum=o.cnum);


select onum,cname from orders o join cust c on (o.cnum=c.cnum);


select cname,rating from cust order by rating;

select cname,snum from cust where snum in (select snum from cust group by snum having count(*)>1);


select sname,city from salespeople where city in (select city from salespeople group by city having count(*)>1);


select onum,sname,cnum from salespeople s join orders o on(s.snum=o.snum) where cnum=2008;


select onum,amt from orders where amt>(select avg(amt)from orders where odate>'1994-10-04');


select * from salespeople where sname in (select sname from salespeople where city='london');


select cname,cnum from cust c JOIN salespeople s on (c.snum=s.snum) where cnum >(select snum+1000 from salespeople where sname='serres');


select count(*),rating from cust group by rating having rating>(select avg(rating) from cust where city='Sanjose');


select * from cust where snum in (select snum from cust s where exists(
select * from cust p where p.snum=s.snum and p.cname<>s.cname));

