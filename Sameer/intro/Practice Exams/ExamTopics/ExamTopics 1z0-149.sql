--Q 2:

create or replace function testfunc(p1 in number, p2 in number) return number is
    begin
        return p1+p2;
    end;
declare
    p1 constant number:=20;
begin
    dbms_output.put_line(testfunc(p1, 90));
end;




--Q 10:
declare
    Number_of_days_between_March_and_April number;
 
begin
    null;
end;


--Q 14:
create or replace procedure pdt_report(p_pdt_price in out number) is
    cursor c_pdt(cur_price in out number) is
    select * from employees where salary>cur_price;
    v_pdt_name varchar2(20);
    l_var number:=2000;

begin
    for r in c_pdt(l_var) loop
        dbms_output.put_line(r.first_name);
        end loop;
end;

declare
    l_var number:=10000;
begin
    pdt_report(l_var);
end;




/

create or replace view test_vw
as select sysdate t from dual;



--Q 18:
declare
    sal number(2);
begin
    select SALARY into sal
    from employees
        where employee_id=100;
end;



--Q 19:
create or replace procedure report(upper(test)number)
    begin
        dbms_output.put_line(test);
    end;
    

    --Q 21:

drop trigger testtrigger;
create or replace trigger testtrigger
before drop on database
when(1=1)
begin
    raise_application_error(-20001, 'cannot drop table');
end;


drop table emp_temp;



select FIRST_NAME, avg(SALARY)
from employees
group by FIRST_NAME;



create or replace package pkg is
    type ac is table of number index by pls_integer;
end pkg;

declare
    ass_arr pkg.ac;

begin
    ass_arr(10):=100;
    ass_arr(20):=200;
    ass_arr(30):=300;
    execute immediate 'declare l_var pkg.ac:=:x;
    begin dbms_output.put_line(l_var.count); end;' using in ass_arr;

    execute immediate 'begin if :x then
        dbms_output.put_line(20);
    end if;
        end;' using in true;

end;


--Q 25:
create table emp_copy
as select *
from employees;


create or replace view emp_vw
as select *
from emp_copy;


create or replace package pkg is
    x number:=20;
    function f return number;
end pkg;

create or replace package body pkg is
    function f return number is
        l_var number;
    begin
        select SALARY into l_var from emp_vw
            where EMPLOYEE_ID=100;
        return 678;
    end;
end pkg;


drop view emp_vw;

begin
    pkg.x:=900;
end;

begin
    dbms_output.put_line(pkg.x);
end;

begin
    dbms_output.put_line(pkg.f);
end;



--Q 26:
create or replace;


declare
    SUBTYPE new_one IS NUMBER (1, 0);
    my_val new_one;
 
begin
    my_val:=-1;
end;



--q 28:
select dbms_rowid.rowid_is_valid(rowid) from employees;

select rowid from employees;

declare
    l_test varchar2(20);
    l_test2 rowid;
begin
    select rowid into l_test2 from employees
    where employee_id=100;
    
    dbms_output.put_line(l_test);
end;