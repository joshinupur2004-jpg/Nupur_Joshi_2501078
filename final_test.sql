-- Q1)
create database final_mysql_test;
use final_mysql_test;

-- Q2)
create table department(
department_id int primary key,
department_name varchar(30) not null,
location varchar(100)
);

create table employees(
employee_id int primary key,
employee_name varchar(100) not null,
department_id int,
salary decimal(10,2),
foreign key(department_id) references department(department_id)
);

insert into department (department_id, department_name, location) values
(101, 'Human Resources', 'Mumbai'),
(102, 'Finance', 'Delhi'),
(103, 'IT', 'Bangalore'),
(104, 'Marketing', 'Hyderabad'),
(105, 'Operations', 'Pune');

insert into employees (employee_id, employee_name, department_id, salary, hire_date) values
(1, 'Amit Sharma', 101, 55000, '2020-01-15'),
(2, 'Priya Verma', 102, 60000, '2019-03-10'),
(3, 'Rahul Mehta', 103, 48000, '2021-07-22'),
(4, 'Sneha Kulkarni',105, 52000, '2018-11-05'),
(5, 'Vikram Singh', 104, 75000, '2022-02-18'),
(6, 'Neha Joshi', 102, 58000, '2020-09-30');

-- Q3)
alter table employees add column email varchar(100);
update employees set email = CONCAT(employee_name, '@company.com');

-- Q4)
alter table employees add column status varchar(20) default 'Active';
update employees set status = 'Inactive' where employee_id = 108;

-- Q5)
select employee_name, salary from employees where salary between 50000 and 90000 order by salary DESC;

-- Q6)
select employee_name from employees where employee_name like 'A%' or employee_name like '%r%';

-- Q7)


 -- Q8) 
select d.department_name, avg(e.salary) as AvgSalary from department d join employees e on d.department_id = e.department_id
group by d.department_name having avg(e.salary) > 70000;

-- Q9)
select d.department_name, COUNT(e.employee_id) as NumEmployees from department d
inner join employees e on d.department_id = e.department_id
group by d.department_name;

-- Q10)
select employee_name, salary from employees where salary > (select avg(salary) from employees);

-- Q11)
select employee_name, salary, department_id from employees e where salary > (
select avg(salary) from employees where department_id = e.department_id
);

-- Q12) 
select department_name
from department d
where exists (select 1 from employees e where e.department_id = d.department_id);

select department_name
FROM department d
WHERE NOT EXISTS (SELECT 1 FROM employees e WHERE e.department_id = d.department_id);

-- Q13)
SELECT employee_name, department_id, salary,
       DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS RankInDept
FROM employees;

-- Q14)
SELECT employee_name, department_id, salary
FROM (
    SELECT employee_name, department_id, salary,
           ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS RowNum
    FROM employees
) AS Sub
WHERE RowNum <= 2;

-- Q15)
WITH DeptAvg AS (
    SELECT department_id, AVG(salary) AS DeptAvgSalary
    FROM employees
    GROUP BY department_id
)
SELECT e.employee_name, d.department_name, e.salary, d.location
FROM employees e
JOIN department d ON e.department_id = d.department_id
JOIN DeptAvg da ON e.department_id = da.department_id
WHERE e.salary > da.DeptAvgSalary;

-- Create view
CREATE VIEW employee_department_report AS
SELECT e.employee_name, d.department_name, e.salary, d.location
FROM employees e
JOIN department d ON e.department_id = d.department_id;