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











    s




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