--Q 6:

declare
    type t is table of number index by varchar2(20);
    ac t;
begin
    ac('a'):=10;
    ac('b'):=20;
    ac('c'):=30;


    ac.delete('a', 'b');
    
    dbms_output.put_line(ac.count);

end;


--Q 46:

create or replace package manage_employees is
    tax_rate constant number(5, 2) := .28;
    v_id number;
    procedure insert_emp(p_deptno number, p_sal number);
    procedure delete_emp;
    procedure update_emp;
    function calc_tax(p_sal number) return number;
end manage_employees;

--Q 47:
--Yes alleen in EXECUTION kunnen andere blocks genest worden, niet in je declarative section

--Q 47:
alter table emp_copy disable all triggers ;

create or replace trigger testtrigger after update on emp_copy
    for each row
begin
    :OLD.first_name:='SH';
    dbms_output.put_line(:new.first_name);
end;

update emp_copy
set first_name = 'sam'
where employee_id=101;


--52:
--B is ook waar AFAIK

--Q 55:
create table test
(
    emp_id number,
    Emp_Name varchar2 (30),
    Dept_ID number,
    Salary number
);

CREATE or replace procedure Add_Emp (p_emp_id in number, p_name Employees.Emp_Name%type, p_dept_id number, p_salary Employees.Salary%type)
    return number is
begin
    insert into employees (emp_id, emp_name, dept_id, salary) values (p_emp_id, p_name, p_dept_id, p_salary);
end;



create or replace procedure proc1 is
begin
    dbms_output.put_line('test');
end;