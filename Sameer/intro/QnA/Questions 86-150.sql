--Q 90:
declare
    sal_too_high exception;
    pragma exception_init (sal_too_high, -20000);
begin
    raise_application_error(-20000, 'msg');
exception
    when sal_too_high then
    dbms_output.put_line('yep');
end;

--Q 107:
declare
    a constant number:=20;
 
begin
    dbms_output.put_line(a);
end;
--Not possible
declare
    type r is record(a number, b constant varchar2(20):='sam');
begin
    dbms_output.put_line('test');
end;

declare
    type r is record(a number not null:=20, b  varchar2(20):='sam');
    rec constant r:=r(a => 02, b => 20);
begin
--     rec.b:=40;
    dbms_output.put_line('test');
end;


--Q 108:
declare
    type r is record(a sys_refcursor, b number);
    rec r;
begin
    null;
end;


--Q 133:
declare
    type tab_typ is table of employees.last_name%type;
    arr tab_typ:=tab_typ();

begin
    select LAST_NAME bulk collect into arr from employees;
    forall i in 1..arr.last
        insert into last_names (last_name) values (arr(i));
    
    dbms_output.put_line(sql%bulk_rowcount(10));
end;

drop table emp_by_dept;
create table emp_by_dept
(
    employee_id   number(6) not null,
    department_id number(4) not null
);
--Omdat die laatste department id geen enkele rows heeft in employees table
--Vandaar dat er daar 0 rows zijn effected
declare
    type dept_tab is table of departments.department_id%type ;
    deptnums dept_tab ;
begin
    select department_id bulk collect into deptnums from departments;
    forall i in 1..deptnums.count
        insert into emp_by_dept
        select employee_id, department_id
        from employees
        where department_id = deptnums(i);
    dbms_output.put_line(sql%bulk_rowcount(deptnums.count));
    dbms_output.put_line(sql%rowcount);
end;


create table last_names(
    last_name varchar2(100)
);

select *
from last_names;
truncate table last_names;


/
drop table emp_by_dept;
create table emp_by_dept(
    employee_id number(7) not null,
    department_id number not null
);

--Q 137:


alter session set plsql_warnings='DISABLE:ALL';
alter session set plsql_warnings='ENABLE:PERFORMANCE';
alter session set plsql_warnings='ENABLE:INFORMATIONAL';


create or replace procedure warningProc is
    x constant boolean:=true;
begin
    if x then
        dbms_output.put_line('TRUE');
    else
        dbms_output.put_line('false');
    end if;

    dbms_warning.ADD_WARNING_SETTING_CAT()
end;

begin
    dbms_warning.ADD_WARNING_SETTING_CAT()
end;


-- q 138:
create or replace trigger testtrigger
before update on emp_copy 
begin
    dbms_output.put_line(:old.last_name);
end;



-- Q 141:
create or replace package pkg_type
is
debug constant boolean:=false;
trace constant boolean:=true;
end;



create or replace procedure testProc is
begin
    if pkg_type.debug then
        dbms_output.put_line('true');
    else 
        dbms_output.put_line('false');
    end if;
end;


begin
    testProc;
end;



create or replace package pkg is
debug constant boolean:=true;
trace constant boolean:=false;
end pkg;


create or replace procedure proc1 is
begin
    $if pkg.debug $then
        dbms_output.put_line('Debugging on');
    $else
        dbms_output.put_line('Debugging off');
    $end
end;

select * from user_source
where name='PROC1';


begin
    proc1;
end;



--Q 143:
create or replace procedure myProc authid current_user is
    l_var varchar2(20);
begin
    select LAST_NAME into l_var from employees where employee_id=100;
    dbms_output.put_line(l_var);
end;


begin
    myProc;
end;



grant execute on myProc to test;



declare
    type emprectyp is record (emp_name varchar2(30), salary number(8, 2));
    type fuck is table of emprectyp index by pls_integer;

    array fuck;
    array2 fuck;
    l_index number:=1;

    function highest_salary return fuck is
        emp_info emprectyp;
        cursor cur_emp_cursor is select first_name, salary
                                 from employees
                                 where salary = (select max(salary) from employees);
        begin
        open cur_emp_cursor;
        loop
            fetch cur_emp_cursor into emp_info;
            exit when cur_emp_cursor%notfound;
            l_index:=l_index+1;
            array(l_index):=emp_info;
        end loop;
        close cur_emp_cursor;
        return array;
    end highest_salary;
begin
    array2:=highest_salary();
    dbms_output.put_line(array2.count);


    for i in array2.first..array2.last loop
        dbms_output.put_line(array2(i).emp_name || ' ' || array2(i).salary);
        end loop;
end;


select first_name, salary
from employees
where salary = (select max(salary) from employees);



declare
    v_wage number not null := 5000;
    v_total_wages v_wage%type := 20;
    work_complete constant boolean := true;
    all_work_complete work_complete%type;
begin
    dbms_output.put_line(v_wage); dbms_output.put_line(v_total_wages);
    if work_complete then
        dbms_output.put_line('true');
    else dbms_output.put_line('false');
    end if;
    if all_work_complete then
    dbms_output.put_line('true');
    else dbms_output.put_line('false');
    end if;
end;


declare
    v_wage number not null := 5000; v_total_wages v_wage%type := 20; work_complete constant boolean := true; all_work_complete work_complete%type;
begin
    dbms_output.put_line(v_wage); dbms_output.put_line(v_total_wages);
    if work_complete then dbms_output.put_line('true'); else dbms_output.put_line('false'); end if;
    if all_work_complete then dbms_output.put_line('true'); else dbms_output.put_line('false'); end if;end;