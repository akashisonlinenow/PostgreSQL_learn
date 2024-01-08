-- CREATE TABLE IF NOT EXISTS STAFF
-- (
--     STAFF_ID         VARCHAR(20)
--   , STAFF_TYPE       VARCHAR(30)
--   , SCHOOL_ID        VARCHAR(20)
--   , FIRST_NAME       VARCHAR(100) NOT NULL
--   , LAST_NAME        VARCHAR(100) NOT NULL
--   , AGE              INT
--   , DOB              DATE
--   , GENDER           VARCHAR(10) CHECK (GENDER IN ('M', 'F', 'Male', 'Female'))
--   , JOIN_DATE        DATE
--   , ADDRESS_ID       VARCHAR(20)
--   , CONSTRAINT PK_STAFF PRIMARY KEY(STAFF_ID)
--   , CONSTRAINT FK_STAFF_SCHL FOREIGN KEY(SCHOOL_ID) REFERENCES SCHOOL(SCHOOL_ID)
--   , CONSTRAINT FK_STAFF_ADDR FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID)
-- );

-- select * from address;
-- select * from school;
-- select * from staff;

-- select * from STAFF_NEW;

-- commit;

-- -- ddl commands
-- drop table staff;


-- insert into address values('ADR1001', '44940 Bluestern Circle', 'Baton Rouge', 'Louisiana', 'United States');
-- insert into school values('SCHL1001', 'Noble School','CBSE', 'ADR1001');

-- alter table staff drop column JOIN_DATE; -- drop a column
-- alter table staff alter column AGE type varchar(5); --change datatype of a cloumn
-- alter table staff rename to STAFF_NEW; -- rename the table
-- alter table STAFF_NEW rename column FIRST_NAME to FULL_NAME; --rename column
-- alter table STAFF_NEW add constraint UNQ_STF unique (STAFF_TYPE); -- add a constraint to existing table 
-- drop table STAFF_NEW;

-- -- dml commands (DINU)
-- select * from address;

-- insert into address (address_id, street, city, state, country)
-- 	values('ADR1011', '44940 Bluestern Circle', 'Baton Rouge', 'Louisiana', 'USA');
-- insert into address	values('ADR1012', '029 kropf point', 'Richmond', 'Virginia', 'USA');

-- insert into address	values
-- 	('ADR1013', '029 kropf point', 'Richmond', 'Virginia', 'USA'),
-- 	('ADR1014', '030 kropf point', 'Roanoke', 'Virginia', 'USA'),
-- 	('ADR1015', '031 kropf point', 'Atlanta', 'Georgia', 'USA'),
-- 	('ADR1016', '032 kropf point', 'Seattle', 'Washington', 'USA');

-- update address set country= 'Malaysia' where address_id = 'ADR1014';

-- update address 
-- set country= 'India', city='Mumbai' where 
-- address_id = 'ADR1012';

-- select * from school;

-- delete from address where country = 'Malaysia'; -- deleted only one row 
-- delete from school;
-- delete from address;

-- dql commands
select * from school;
select * from subjects;
select * from staff;
select * from staff_salary;
select * from classes;
select * from students;
select * from parents;
select * from student_classes;
select * from student_parent;
select * from address;

--diff sql operators - =,<,>,>=,<=,<>,!=,BETWEEN, ORDER BY, IN, NOT IN, LIKE, ALIASE, DISTINCT, LIMIT, CASE
-- arithmetic +,-,/,*,%
-- logical AND, OR, NOT, IN, NOT in, BETWEEN, LIKE etc.
-- comparison =,<,>,>=,<=,<>,!=

select * from subjects where subject_name='Mathematics';
select * from subjects where subject_name<>'Mathematics';
select * from staff_salary where salary BETWEEN 11000 AND 15000 order by salary;
select * from staff_salary where salary >=11000 AND salary<=15000 order by salary desc;
select * from classes where teacher_id LIKE 'STF100_' order by teacher_id;
select * from students where last_name IN ('Brownell', 'Kinmond');
select * from students where last_name not IN ('Brownell', 'Kinmond');
select (5+2) total;

select * from staff;
select distinct staff_type as st from staff;

-- case statements
select *,
	case when salary>=10000 then 'High salary'
		when salary between 8000 and 10000 then 'Medium salary'
		when salary<=8000 then 'low salary'
	end as range
from staff_salary
order by 2 desc ;

-- two ways to write sql query :-
-- 1) using JOIN keyword between tables in FROM clause
select t1.column1 as c1, t1.column2 as c2, t2.column3 as c3 
	from table1 as t1           -- t1, t2 alaise for tables
	join table2 as t2			-- c1, c2, c3 aliases for columns
	on t1.c1 = t2.c1
	and t1.c2 = t2.c2;
	
-- 2) using ,  between tables in FROM clause
select t1.column1 as c1, t1.column2 as c2, t2.column3 as c3 
	from table1 as t1, table2 as t2           -- t1, t2 alaise for tables	-- c1, c2, c3 aliases for columns
	where t1.c1 = t2.c1
	and t1.c2 = t2.c2;			-- both conditions should satisfy for the query to fetch data

-- fetch all class name where music is taught as a subject
select class_name from classes as c join subjects as s on c.subject_id = s.subject_id where s.subject_name='Music';  

--fetch the full name of all staff who teach mathematics
select distinct (first_name||' '||last_name) as full_name from staff as stf
	join classes as cls on stf.staff_id=cls.teacher_id
	join subjects as sub on cls.subject_id=sub.subject_id
	where sub.subject_name='Mathematics';

-- unoin and union all
-- fetch all staff who teach grade 8,9,10 and also fetch all the non-teching staff
select stf.staff_type, (stf.first_name||' '||stf.last_name) as full_name, stf.age,
	(case when stf.gender='M' then 'Male'
	 	when stf.gender='F' then 'Female'             -- while using union, no. of column in first and second should be same, and datatype of the select in both the query should be same
	end ) as Gender,
	stf.join_date
	from staff stf				
	join classes as cls 
	on cls.teacher_id = stf.staff_id
	where stf.staff_type='Teaching'
	and cls.class_name in ('Grade 8', 'Grade 9', 'Grade 10')
union													-- union takes all the common elements only once. hence no duplicacy, to include duplicacy use union all in place of union
select stf.staff_type, (stf.first_name||' '||stf.last_name) as full_name,
	stf.age, 
	(case when stf.gender='Male' then 'M'
		when stf.gender='Female' then 'F'
	end) as Gender,
	stf.join_date
	from staff as stf
	where stf.staff_type='Non-Teaching';
	
-- group by statements
--count no. of students in each class
select stcls.class_id, count(1) as no_of_students
from student_classes as stcls
group by stcls.class_id
order by stcls.class_id;

--fetch only those classes which have >100 students
select stcls.class_id, count(1) as no_of_students
from student_classes as stcls
group by stcls.class_id
having count(1)>100
order by stcls.class_id;

--parents with more than one kid in shool
select sp.parent_id, count(1) as no_of_kids from student_parent as sp
group by sp.parent_id
having count(1)>1
order by sp.parent_id;

-- Subquery- - query written inside a query
-- fetch the details of parents having more than one student going to school
