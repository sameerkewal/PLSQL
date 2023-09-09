declare
l_index number:=0;
begin
    loop
        l_index:=l_index+1;
        continue when l_index=3;
        dbms_output.put_line(l_index);
        exit when l_index=10;
    end loop;
end;







--Question 40:
create or replace procedure procTest(p1 in number default 69)is
    begin
        p1:=20;
    end;



--Question 44:
create or replace function testfunc(test boolean) return number is
    begin
        return 20;
    end;



--It no work
select testfunc(true) from dual;

declare
l_value number;
l_boolean boolean:=true;
begin
select testfunc(l_boolean)into l_value from dual;
end;



--Q 48:

begin
    <<loop>>
    for i in 1..10 loop
        dbms_output.put_line(i);
        goto what;
        end loop loop;
    
    <<what>>
    dbms_output.put_line('in what block');
--     goto loop;

end;



--Question 63
create or replace procedure dependentProc is
    c sys_refcursor;

    emp_rec employees%rowtype;
    begin
        open c for select * from employees;
        dbms_output.put_line(c%rowcount);
        fetch c into emp_rec;
        close c;
        dbms_output.put_line(emp_rec.last_name);
--         dbms_output.put_line(c%rowcount);
    end;


begin
    DEPENDENTPROC();
end;


--Q 64:

SELECT Job_ID, first_name, AVG(Salary) AS Average_Salary
FROM Employees
GROUP BY Job_ID, first_name;

SELECT Job_ID, first_name, AVG(Salary) AS Average_Salary
FROM Employees
GROUP BY first_name, job_id;

drop table emp_copy;

create table emp_copy
as select * from employees;


--Q 66:
declare
    l_employees employees.last_name%type;
begin
    select first_name into l_employees
        from employees;
exception
    when TOO_MANY_ROWS then
    dbms_output.put_line(sql%rowcount);
    raise;
end;

--Q 85:
declare
    type r is record(a number, b varchar2(20));
    r_var1 r;
    r_var2 r_var1%type;
begin
    null;
end;


--Question 50:
declare
l_index number:=0;
begin
    <<loopie_loop>>
    loop
        l_index:=l_index+1;
        continue when l_index=3;
        dbms_output.put_line(l_index);
        exit  loopie_loop when l_index=10;
    end loop loopie_loop;
end;





























declare
    emp_rec employees%rowtype;
    l_result number:=69;
begin
--     select * into emp_rec from emp_copy where EMPLOYEE_ID=2000;
        update emp_copy set first_name = 'test' where EMPLOYEE_ID=100 returning salary into l_result;
    if sql%notfound then
        dbms_output.put_line(sql%rowcount);
        dbms_output.put_line('not found');
        dbms_output.put_line(nvl(to_char(l_result), 'null'));
    else 
        dbms_output.put_line('found');
        dbms_output.put_line(nvl(to_char(l_result), 'null'));
    end if;
end;