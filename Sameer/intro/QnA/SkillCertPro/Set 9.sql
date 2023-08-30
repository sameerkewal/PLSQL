declare
    high_sal exception;
    high_sal exception;
begin
    null;
end;


--Q 31
--Omdat je geen subprogram kan maken in een begin block van een normale trigger
--Maar in een compound trigger kan het wel
drop table emp_copy;
create table emp_copy
as select * from employees;



 create or replace trigger testTrigger
for update or delete or insert on emp_copy
compound trigger
    procedure shit is
        begin
            dbms_output.put_line('i am inside a trigger');
        end;
after each row is
begin
    shit;
 end after each row;
 end;


delete from emp_copy
where employee_id=101;


--Q 32
drop procedure test;

create or replace function test return varchar2 is
    l_email varchar2(30):=test;
begin
    update emp_copy
    set email = 'skewal@com'
    where employee_id = 191
    returning email into l_email;
    return l_email;
end;


select email, test from emp_copy
where EMPLOYEE_ID>190;

declare
    l_email varchar2(200);
begin
    l_email:=test();
    dbms_output.put_line(l_email);
end;


select email from emp_copy
where EMPLOYEE_ID>190;


drop table orders;


create table orders(
    order_id number,
    order_total number(8, 2)
);


declare
    v_order_id orders.order_id%type;
    v_order_total constant orders.order_total%type:=1000;
    v_all_order_total v_order_total%type;
begin
    v_order_id:=null;
    dbms_output.put_line('Order total is ' || v_order_total);
end;



declare
    c_id customers.id%type;
    c_name customers.name%type;
    c_addr customers.address%type;
    cursor c_customers is select id, name, address from customers;
                                                                                                             from customers;
begin
    loop
        fetch c_customers into c_id, c_name, c_addr;
        exit when c_customers%notfound;
        dbms_output.put_line(c_id || ' ' || c_name || ' ' || c_addr);
    end loop;
    close c_customers;
end;


--Q 59:
declare
    a number(2);
begin
    for a in reverse 10..20 loop
        end loop;
    dbms_output.put_line(a);
end;


declare
    a number(2):=9;
begin
    while a<30 loop
        a:=a+3;
        end loop;
    dbms_output.put_line(a);
end;


declare
    low number;
    high number;
begin
    low:=4;
    high:=4;

    for i in low..high loop
        dbms_output.put_line(i);
        end loop;
end;

--Q 21
<<outer_block>>
declare
    salary number;
    sal_too_high exception;
begin
    <<inner_block>>
    declare
        salary number:=2000;
    begin
        if salary=2000 then
            raise sal_too_high;
        end if;
    exception
        when sal_too_high then
        declare
        l_var number:=20;
        begin
            declare
                l_var_number number;

            begin
            dbms_output.put_line(l_var);
            end;

        end;

    end inner_block;
end outer_block;


--Q 36
--Geen van de volgende mogen
create or replace function testfunc return number(8, 2)
is
begin
    return 20;
end;


create or replace function testfunc(p1 varchar2(20)) return varchar2
is begin
    return 's';
end;


select salary
from employees
where employee_id=195;


declare
    v_sal number(10, 2):=1000;
begin
    dbms_output.put_line(v_sal);
    declare
        v_sal number;
    begin
        select SALARY into v_sal from employees where employee_id=195;
        dbms_output.put_line(v_sal);
        declare
            v_sal number:=50000;
        begin <<b3>>
        dbms_output.put_line(v_sal);
        end b3;
        dbms_output.put_line(v_sal);
    end;
end;


select * from user_dependencies;


--Q 52:
drop view emp_vw;
create or replace view emp_vw as
select emp.employee_id, j.job_id, job_title, min_salary, max_salary  from emp_copy emp join hr.jobs j on j.job_id = emp.job_id;



create or replace trigger emp_trigger
instead of insert or update or delete on emp_vw
begin
    dbms_output.put_line(:old.job_id);
end;


delete from emp_vw
where employee_id=100;


--Q 54
declare
    c_id customers.id%type;
    c_name customers.name%type;
    c_addr customers.address%type;
    cursor c_customers is select id, name, address from customers;
                                                                                                             from customers;
begin
    loop
        fetch c_customers into c_id, c_name, c_addr;
        exit when c_customers%notfound;
        dbms_output.put_line(c_id || ' ' || c_name || ' ' || c_addr);
    end loop;
    close c_customers;
end;




