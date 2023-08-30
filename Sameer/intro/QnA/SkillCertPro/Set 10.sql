--Q 10:
DECLARE
    Line 2: v_number1 INTEGER := &sv_number1
    Line 3: v_number2 INTEGER := &sv_number2
    Line 4: v_result NUMBER
    Line 5: BEGIN
    Line 6: v_result = v_number1 / v_number2
    Line 7: DBMS_OUTPUT.PUT_LINE (
‘v_result:
‘| | v_result)
    Line 8: END
/
--Q 10:
declare
    v1 number;
    v2 number;

    result number;
begin
    result:=v1/v2;
end;

drop trigger testtrigger;

--Q 11:
create or replace trigger testtrigger
after logon on schema
    when (1=1)
begin
    insert into log(user_name) values ('what');
end;

select *
from log;
truncate table log;



/
--q 24:
create or replace package pkg1 is
    pragma serially_reusable;
    num number := 0;
    procedure init_pkg_state(n number);
    procedure print_pkg_state;
end pkg1;

create or replace package body pkg1 is
    pragma serially_reusable;
    procedure init_pkg_state(n number) IS
    BEGIN
    pkg1.num := n;
    dbms_output.put_line('Num: ' || pkg1.num);
    end;

    procedure print_pkg_State IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Num: ' || pkg1.num);
    end;
end pkg1;
/
set SERVEROUTPUT ON

/


begin
    pkg1.init_pkg_state(5);
    pkg1.print_pkg_state;
end;
/

begin
    pkg1.print_pkg_state;
end;

/

DECLARE
    emp_name employee.last_name%type;
    emp_job employee.job_id%type;
    cursor c1 IS SELECT last_name, job_id
             from employees WHERE job_id like '%CLERK%' and manager_id > 120;
BEGIN
    FOR emp_name, emp_job in c1 LOOP
        DBMS_OUTPUT.PUT_LINE('name = ' || emp_name || ', job = ' ||emp_job);
end loop;
end;


--Q 43:

declare
    a number;
    procedure squarenum(x in out number) is
        begin
            x := x * x;
        end;
begin
    a := 5;
    squarenum(a);
    dbms_output.put_line(a);
end;




DBA:CREATE DIRECTORY my_dir AS ‘/temp/my_files*;GRANT WRITE ON DIRECTORY my_dir to SCOTT;Examine the procedure code:CREATE OR REPLACE PROCEDURE sal_status(p_dir IN VARCHAR2, p_filename IN VARCHAR2) ISf_file UTL_FILE.FILE_TYPE;CURSOR cur_emp ISSELECT last_name, salaryFROM employees ORDER BY salary;BEGINf_file := UTL_FILE.FOPEN(p_dir, p_filename, ‘W‘);UTL_FILE.PUT_LINE(f_file, ‘REPORT: GENERATED ON ‘ || SYSDATE);FOR emp_rec IN cur_emp_LOOPUTL_FILE.PUT_LINE(f_file, ‘ EMPLOYEE: ‘ ||emp_rec.last_name || ‘ earns: ‘ || emp_rec.salary);END LOOP;UTL_FILE.FCLOSE(f_file);EXCEPTIONWHEN UTL_FILE.INVALID_FILEHANDLE THENRAISE_APPLICATION_ERROR(-20001, ‘Invalid File.‘);WHEN UTL_FILE.WRITE_ERROR THENRAISE APPLICATION_ERROR(-20002, ‘Unable to write to file.‘);END;You issue the following command:SQL_EXEC sal_status (‘my_dir‘, ‘empreport.txt‘)





--Test
declare
    test number:=returnFifty();
begin
    dbms_output.put_line(test);
end;


-- Q 7:

--Showing that host variables only work within anonymous blocks and not within procedures or functions
-- You can’t create a procedure with a bind variable in it because stored procedures are
-- server-side objects and bind variables only exist on the client side.
-- However in anonymous plsql block using host variable is allowed.
variable test number;
define test = 100;

print test;

begin
    dbms_output.put_line(:sht);

    if :test is null then
        dbms_output.put_line('what');
    end if;
end;

/
create or replace procedure testProc is
dbms_output.put_line(:test);
    if :test is null then
        dbms_output.put_line('what');
    end if;
end;
/

create or replace function testfunc  return number is
dbms_output.put_line(:test);
    if :test is null then
        dbms_output.put_line('what');
    return 20;
    end if;
end;



--Q 32
alter table emp_copy disable all triggers;
drop trigger testtrigger;

create or replace trigger testtrigger before update or delete on emp_copy
begin
    dbms_output.put_line(:new.email);
end;


--Q 33:
declare
    sal_too_high exception;
    pragma exception_init (sal_too_high, -20001);
begin
    raise_application_error(-20001, 'Invalid salary');
exception
    when sal_too_high then
    dbms_output.put_line(sqlerrm);
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm(-20001));
end;


create or replace trigger testtrigger
before update of salary, first_name on emp_copy
for each row
begin
    dbms_output.put_line('triggered');
end;

update emp_copy
set first_name = 9000
where employee_id=111;

--Q 49
grant select on testtrigger to sam;



--Q 53
declare
    cursor c is select * from employees
    where employee_id>9999;
    
    emp_rec c%rowtype;
    
begin
    open c;
    loop
    exit when c%notfound;
    fetch c into emp_rec;
    dbms_output.put_line(emp_rec.email);
    end loop;
end;


--Q 54
declare
    sal_too_high exception;
    sal_too_high exception;
    
--     pragma exception_init (sal_too_high, -20000);
--     pragma exception_init (sal_too_high, -20001);
begin
    null;
--     raise sal_too_high;
    exception
        when sal_too_high then
        dbms_output.put_line(sqlcode);
end;


--Q 56:
declare
    a number(3) := 100;
    b number(3) := 200;
begin
    if (a = 100) then
        if (b <> 200) then
            dbms_output.put_line(b);
            end if;
        end if;
    dbms_output.put_line(a);
end;


-- q 57:
declare
    a number;
    b number;
    c number;
    procedure findmin(x in number, y in number, z out number) IS
        BEGIN if x < y then
                z := x;
            else
                z := y;
            end if;
end;
begin
    a := 2;
    b := 5;
    findmin(a, b, c); dbms_output.put_line(c);
end;


-- Q 64
--Je due date in inner block is local to that block
-- Je outer block kent alleen zn eigen past due exception
DECLARE
    past_due exception;
    acct_num number;
BEGIN
    DECLARE
        past_due exception;
        acct_num number;
        due_date date := to_date('20-11-2002', 'dd-mm-yyyy');
        todays_date date := sysdate;
        BEGIN
    IF due_date < todays_date THEN
        RAISE past_due;
    end if;
    end;
EXCEPTION
WHEN past_due THEN
    DBMS_OUTPUT.PUT_LINE('Handling PAST_DUE exception.');
when others THEN
    DBMS_OUTPUT.PUT_LINE('Could not recognize exception.');
end;