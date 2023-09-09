--Q 4:


create or replace type nt is table of number;
/
create or replace type tay is varray(20) of number;

/
 variable test number;
 variable test2 refcursor;
 variable test3 char;
 variable test4 tay;
 variable test5 varray(20);
 variable test5 nested table;
 variable test6 nt;


--Die varray is een collection type so it wont go
--Ig dat het alleen werkt met scalar variables(wtf is een refcursor anw? gewoon een reference naar een memory address?)


--Q 9:

--The scope of an exception block is global for the block and local for its sub blocks seems true

--The sub block can refer to the global exception only when the exception name is qualified with the blocklabel (block_label.exception_name).
--Onwaar only is keyword hier. Sub blocks zoeken eerst in hun local block naar dat ding en als het niet daar bestaat
--zoeken ze in die enclosing block ervoor

--Kijk hier handle je een exception van je outer block in je inner block and no use of block labels
declare
    sal_too_high exception;
begin
    declare
        
     
    begin
        raise sal_too_high;
    exception
        when sal_too_high then
        dbms_output.put_line('handled in inner block');
    end;
end;


--C is waar
--D is ook waar




--Q 20:
--Variables zijn identifiers



--Q 15:
declare
    cursor c is select *
    from employees where last_name='Kingggg';
    emp_rec employees%rowtype;
begin
    open c;
    fetch c into emp_rec;
    dbms_output.put_line(emp_rec.first_name);
    close c;
end;


--Q 21:
begin
    insert into log (user_name) values ('HR');
    insert into log (user_name) values ('OE');
    insert into log (user_name) values ('TEST1');
    insert into log (user_name) values ('SAMEER');
    raise_application_error(NUM => -20000, MSG => 'whut');
exception
    when others then
    dbms_output.put_line('caufgr');
end;


commit;
select *
from log;
rollback;

truncate table log;


--Q 23:
declare
    type d is table of departments.department_id%type;

    nt d:=d(30, 40, );
begin

end;



--Q 28:
-- I mean D is technically true.
--Maar als je cursor variables gebruikt dan wat HUH
--Okay maar een cursor variable is weer wat anders dan een explicit cursor

declare
    type emprectyp is record
                      (
                          employee_id number,
                          last_name   varchar2(25),
                          salary      number(8, 2)
                      );

    type curtype is ref cursor return emprectyp;
    emp_cv curtype;


begin
        open emp_cv for select EMPLOYEE_ID, LAST_NAME, SALARY
            from employees;




end;
drop table emp_temp;
create table emp_temp(
    fname varchar2(100),
    lname varchar2(100)
);

--Q 29:

--Dus A gaat niet, B gaat obv niet en neither gaat D(cuz als A niet gaat hoe zou D werken)
--Dus uh C the only one that works

declare
    type emp_copy_rec_type is record
                              (
                                  fname emp_temp.fname%type,
                                  lname emp_temp.lname%type
                              );

    emp_rec emp_copy_rec_type := emp_copy_rec_type(fname => 'sam', lname => 'what');

    l_fname varchar2(100);

begin
    insert into emp_temp values ('sam', 'dhhdhd') returning fname, lname into emp_rec;
--     insert into emp_temp (fname, lname) values (emp_rec);
--     insert into emp_temp values (emp_rec);
    commit; -- Don't forget to commit the transaction
exception
    when others then
        rollback; -- Rollback in case of error
        raise;
end;
/

--Q 46:

--Bij A is het juist altijd false
--Bij B...DDL? voldoet also aan die vraag dan since ze vragen voor not true
--Bij C is het true
--D also true


--Q 64:
declare
    low number; high number;
begin
    low := 4; high := 4;
    for i in low..high
        loop
            dbms_output.put_line(i);
        end loop;
end;
