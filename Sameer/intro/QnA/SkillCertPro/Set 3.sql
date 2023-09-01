--Q 33:
--Je kan je cursor nieteens definen in je execution section

--Wait so wat in die vraag staat geeft helemaal geen error.
--MAar geeft ook niet de gewenste output.
declare
    type r is record(fname employees.last_name%type, lname employees.first_name%type);
    emp_rec r:=r(fname => 'sam', lname => 'kewal');


    cursor c is select FIRST_NAME, LAST_NAME into emp_rec from employees;
begin
    open c;
    fetch c into emp_rec;
    close c;
    dbms_output.put_line(emp_rec.lname);
end;


--test 2
declare
    type r is record(fname employees.last_name%type, lname employees.first_name%type);
    emp_rec r;
begin
    select FIRST_NAME, LAST_NAME into emp_rec
    from employees where employee_id=100;
    
    dbms_output.put_line(emp_rec.fname);
end;



--Q 53:
--PLS-00230: OUT and IN OUT formal parameters may not have default expressions

create or replace procedure proc1(p2 out number default 200) is
begin 
    dbms_output.put_line('test');
end;


declare
    l_value number:=0;
begin
    proc1(l_value);
    dbms_output.put_line(l_value);
end;