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



