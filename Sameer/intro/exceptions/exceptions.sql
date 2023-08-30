--Some data dictionary stuff
select plsql_warnings
from SYS.all_plsql_object_settings
where owner in('HR');






-- If multiple statements use the same exception handler, and you want to know which
-- statement failed, you can use locator variables
--😭😭😭 wtf die locator variabel is not sth built in its just sth you add
create or replace procedure loc_var authid definer is
    stmt_no positive;
    name_   varchar2(100);
begin
    stmt_no := 1;
    select table_name
    into name_
    from user_tables
    where table_name like 'ABC%';

    stmt_no := 2;
    select table_name
    into name_
    from user_tables
    where table_name like 'XYZ%';
exception
    when no_data_found then
        dbms_output.put_line('Table name not found in query ' || stmt_no);
end;


begin
    loc_var;
end;

--Internally defined exception, als je dit niet doet moet je het catchen met een others block(onderin uitgebeeld)
declare
    l_comm number;
    integrity_constraint_violated exception;
    pragma exception_init (integrity_constraint_violated, -2292);
begin
    delete from departments;
exception
when integrity_constraint_violated then
    dbms_output.put_line('You have violated a law');
end;

declare
    l_comm number;
begin
    delete from departments;
exception
when others then
    dbms_output.put_line('You have violated a law');
end;




-- Predefined exceptions
create or replace package emp_data_data authid definer as
type cv_type is ref cursor;

procedure open_cv(
    cv in out cv_type,
    discrim in number
);
end emp_data_data;


create or replace package body emp_data_data as
procedure open_cv(
    cv in out cv_type,
    discrim in number
) is begin
    if discrim = 1 then
        open cv for SELECT * FROM EMPLOYEES ORDER BY employee_id;
    elsif discrim = 2 then
        OPEN cv FOR
 SELECT * FROM DEPARTMENTS ORDER BY department_id;
    end if;
end open_cv;
end emp_data_data;


declare
    emp_rec  employees%rowtype;
    dept_rec departments%rowtype;
    cv       emp_data_data.cv_type;
begin
    emp_data_data.open_cv(cv, 1); -- Open cv for EMPLOYEES fetch.
    fetch cv into dept_rec; -- Fetch from DEPARTMENTS.
    dbms_output.put(dept_rec.department_id);
    dbms_output.put_line(' ' || dept_rec.location_id);
exception
when rowtype_mismatch then
begin
    dbms_output.put_line('Row type mismatch, fetching employees data....');
    fetch cv into emp_rec; --fetch it into the proper rowtype variable
    dbms_output.put_line(emp_rec.department_id);
    dbms_output.put_line(' ' || emp_rec.last_name);
end;
end;



-- If you redeclare a predefined exception, your local declaration overrides the global
-- declaration in package STANDARD. Exception handlers written for the globally declared
-- exception become unable to handle it—unless you qualify its name with the package
-- name STANDARD

DROP TABLE t;
CREATE TABLE t (c NUMBER);


declare
    default_number number := 0;
begin
    insert into t values (to_number('100.00', '9G999'));
exception
    when invalid_number then
        dbms_output.put_line('Substituting default value for invalid number.');
        insert into t values (default_number);
end;

-- The following block redeclares the predefined exception INVALID_NUMBER. When the INSERT
-- statement implicitly raises the predefined exception INVALID_NUMBER, the exception handler
-- does not handle it

declare
    default_number number:= 0;
    i number:=5;
    invalid_number exception; --redeclare predefined exception
begin
    INSERT INTO t VALUES(TO_NUMBER('100.00', '9G999'));
exception
    when invalid_number then
    dbms_output.put_line('Substituting default value for invalid number.');
    INSERT INTO t VALUES(default_number);
end;

-- The exception handler in the preceding block handles the predefined exception
-- INVALID_NUMBER if you qualify the exception name in the exception handler
declare
    default_number number:= 0;
    i number:=5;
    invalid_number exception; --redeclare predefined exception
begin
    INSERT INTO t VALUES(TO_NUMBER('100.00', '9G999'));
exception
    when standard.invalid_number then
    dbms_output.put_line('Substituting default value for invalid number.');
    INSERT INTO t VALUES(default_number);
end;




--Raise statement:
create procedure account_status(
    due_date date,
    today date
) authid definer is
    past_due exception;
begin
    if due_date<today then
        raise past_due;
    end if;
exception
    when past_due then
    dbms_output.put_line('Account past due');
end;

BEGIN
 account_status (TO_DATE('01-JUL-2010', 'DD-MON-YYYY'),
 TO_DATE('09-JUL-2010', 'DD-MON-YYYY'));
END;



-- Although the runtime system raises internally defined exceptions implicitly, you can
-- raise them explicitly using the raise statement as long as they have names.

DROP TABLE t;
CREATE TABLE t (c NUMBER);

create or replace procedure p(n number)authid definer is
default_number number:=0;
begin
    if n<0 then
        raise invalid_number;
    else
        insert into t values (to_number('100.00',  '9G999')); -- raise implicitly
    end if;
exception
    when invalid_number then
    dbms_output.put_line('Substituting default value for invalid number.');
    insert into t values (default_number);
end;

--explicitly raised
begin
    p(-1);
end;

--implicitly raised
begin
    p(1000);
end;


--In dit vb begint je exception in je inner block en end ie up in je outer block
declare
    salary_too_high exception;
    current_salary   number := 20000;
    max_salary       number := 10000;
    erroneous_salary number ;
begin
    begin
        if current_salary>max_salary then
            raise salary_too_high;
        end if;
    exception
        when salary_too_high then
        erroneous_salary:=current_salary;
        DBMS_OUTPUT.PUT_LINE('Salary ' || erroneous_salary ||' is out of range.');
        DBMS_OUTPUT.PUT_LINE ('Maximum salary is ' || max_salary || '.');
        raise; --exception name is optional. This propogates it to the outer block
    end;
    exception
        when salary_too_high then
        current_salary:=max_salary;
        dbms_output.PUT_LINE('Revising salary from ' || erroneous_salary ||
 ' to ' || current_salary || '.');
end;


-- You can invoke the RAISE_APPLICATION_ERROR procedure (defined in the
-- DBMS_STANDARD package) only from a stored subprogram or method. Typically, you
-- invoke this procedure to raise a user-defined exception and return its error code and
-- error message to the invoker.

--I mean je kan het technically invoken but how are you gonna handle it yk cuz wanneer je handelt
--kan je alleen handelen op basis van namen!
begin
    raise_application_error(-20000, 'trest');
end;

--Omdat ze dezelfde error code hebben dan kan je die exception catchen met sal_too_high
declare
    sal_too_high exception;
    pragma exception_init (sal_too_high, -20000);
begin
    raise_application_error(-20000, 'msg');
exception
    when sal_too_high then
    dbms_output.put_line('yep');
end;

--Raising User-Defined Exception with RAISE_APPLICATION_ERROR
--Je raised die application error hier en je handelt het in je anonymous block
drop procedure account_status;
create or replace procedure account_status(
    due_date date,
    today date
) authid definer
is begin
    if due_date<today then
        raise_application_error(-20000, 'Account past due');
    end if;
end;

declare
    past_due exception;
    pragma exception_init (past_due,  -20000); --assign error code to exception
begin
    account_status (TO_DATE('01-JUL-2010', 'DD-MON-YYYY'),
 TO_DATE('09-JUL-2010', 'DD-MON-YYYY')); -- invoke procedure
exception
    when past_due then --handle exception
        dbms_output.put_line(to_char(sqlerrm(-20000)));
end;

--Nog een test net zoals bovenstaande voorbeeld
--Dus hier heb je je exception kunnen propagaten naar de outer block met behulp van die
--error code en het nog steeds kunnen catchen door middel van die naam
--pretty cool tbh
declare
    l_error exception;
    pragma exception_init (l_error, -20001);
begin
    declare
        l_number number := 20;
    begin
        if l_number = 20 then
            raise_application_error(-20001, 'Yippeee');
        end if;
    end;
exception
    when l_error then
    dbms_output.put_line(sqlerrm);
end;

-- An exception raised in a declaration propagates immediately to the enclosing block (or
-- to the invoker or host environment if there is no enclosing block). Therefore, the
-- exception handler must be in an enclosing or invoking block, not in the same block as
-- the declaration.
declare
     credit_limit CONSTANT NUMBER(3) := 5000; -- Maximum value is 999
begin
    null;
exception
    when value_error then
    dbms_output.put_line('Exception raised in declaration');
end;


--Om te fixen zou je zoiets kunnen doen:
begin
    declare
        credit_limit CONSTANT NUMBER(3) := 5000; -- Maximum value is 999
    begin
        null;
    end;
exception
    when value_error then
    dbms_output.put_line('Exception raised in inners block declaration section');
end;


-- An exception raised in an exception handler propagates immediately to the enclosing block
-- (or to the invoker or host environment if there is no enclosing block). Therefore, the exception
-- handler must be in an enclosing or invoking block.
create procedure print_reciprocal(n number) authid definer is
begin
    dbms_output.put_line(1 / n); -- handled
exception
    when zero_divide then
        dbms_output.put_line('Error:');
        dbms_output.put_line(1 / n || ' is undefined'); -- not handled
end;
/
begin -- invoking block
    print_reciprocal(0);
end;


--Om het te fixen
declare
begin
    print_reciprocal(0);
exception
    when zero_divide then
    dbms_output.put_line('1/0 is undefined');
end;

create or replace procedure print_reciprocal (n NUMBER) AUTHID DEFINER IS
begin
    begin -- => anon block in je procedure dat die error gooit
        dbms_output.put_line(1/n);
    exception
        when zero_divide then
        dbms_output.put_line('Error in inner block');
        dbms_output.put_line(1/n || ' is undefined.');
    end;
exception
    when ZERO_DIVIDE then -- => exception handler van je procedure zelf which handles error thrown
    dbms_output.put_line('Error in outer block');   --in the exception section of the inner block
    dbms_output.put_line('1/0 is undefined');
end;


begin
    print_reciprocal(0);
end;


-- If a stored subprogram exits with an unhandled exception, PL/SQL does not roll back
-- database changes made by the subprogram.
create or replace procedure test_rollback is
begin
    delete from emp_copy where employee_id=100;
   raise no_data_found;
end;

select * from emp_copy;

begin
    test_rollback;
end;

-- You can retrieve the error code with the PL/SQL function SQLCODE,
create or replace procedure what_proc is
begin
   raise no_data_found;
exception
    when NO_DATA_FOUND then
    dbms_output.put_line(sqlcode);
end;


begin
    what_proc;
end;


-- You can retrieve the error message with either:
-- – The PL/SQL function SQLERRM, described in "SQLERRM Function"
-- This function returns a maximum of 512 bytes, which is the maximum length of an
-- Oracle Database error message (including the error code, nested messages, and
-- message inserts such as table and column names)
begin
   raise no_data_found;
exception
    when NO_DATA_FOUND then
    dbms_output.put_line(sqlerrm);
end;

-- The package function DBMS_UTILITY.FORMAT_ERROR_STACK, described in Oracle
-- Database PL/SQL Packages and Types Reference
-- This function returns the full error stack, up to 2000 bytes.
-- Oracle recommends using DBMS_UTILITY.FORMAT_ERROR_STACK, except when using the
-- FORALL statement with its SAVE EXCEPTIONS clause, as in Example 12-13.
begin
   raise no_data_found;
exception
    when NO_DATA_FOUND then
    dbms_output.put_line(dbms_utility.FORMAT_ERROR_STACK());
end;


--Example 11-25 Exception Handler Runs and Execution Continues
DROP TABLE employees_temp;
CREATE TABLE employees_temp AS
 SELECT employee_id, salary, commission_pct
 FROM employees;

--Omdat die statement waar er een exception kan optreden is in een inner block
--dan gaat na die error the exection terug naar de outer block which in this case
--Dan gewoon nog een statement doet
declare
    sal_calc number(8, 2);
begin
    insert into employees_temp (employee_id, salary, commission_pct) values (301, 2500, 0);

    begin
        select (salary / employees_temp.commission_pct)
        into sal_calc
        from employees_temp
        where employee_id = 301;
    exception
        when zero_divide then
            dbms_output.put_line('Substituting 2500 for undefined number.');
            sal_calc := 2500;
    end;
    insert into employees_temp values (302, sal_calc / 100, .1);
    dbms_output.put_line('Enclosing block: Row inserted.');
exception
    when zero_divide then
        dbms_output.put_line('Enclosing block: Division by zero.');
end;