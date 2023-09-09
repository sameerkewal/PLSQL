--Q 1:
--is A because one record at a time



--Q 4:
CREATE OR REPLACE PROCEDURE Login_Pro (Name VARCHAR2) AS
BEGIN
        INSERT INTO Audit_Records (User_Name)VALUES (Name);
END Login_Pro;



create or replace trigger logon_trig
    after logon
    on DATABASE
    CALL Login_Pro (ORA_LOGIN_USER)
;


--Q 9:
create table emp_temp
(
    deptno number(2),
    job    varchar2(18)
);
DECLARE
    TYPE numlist is table of number;
    depts numlist := numlist(10,20,30);
BEGIN
    INSERT into emp_temp values(10,'Clerk');
    insert into emp_temp values (20, 'bookkeeper');
    insert into emp_temp values (30, 'analyst');
    forall j in depts.FIRST..depts.LAST 
        UPDATE emp_temp set job = job || ' (Senior)'where deptno = depts(j);
EXCEPTION
WHEN others THEN
    DBMS_OUTPUT.PUT_LINE('Problem in the forall statement');
commit;
end;


--Q 10:
--An exception raised inside a declaration immediately propogates to the outer block

declare


begin
    declare
        l_number number:= 'what';

    begin
        null;
    exception
        when others then
        dbms_output.put_line('error caught in inner block!');
    end;
exception
    when others then
    dbms_output.put_line('error caught in outer block!');
end;


--Q 11:
create or replace package pkg_test is
procedure proc1;
end pkg_test;

create or replace package body pkg_test is
procedure proc1 is
begin
    dbms_output.put_line('wat');
end proc1;
end;

-- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/DROP-PROCEDURE.html#GUID-D7F2B5AD-DEEE-466B-B6D3-B765EB897DCB
-- Use the DROP PROCEDURE statement to remove a standalone stored procedure from the database.
-- Do not use this statement to remove a procedure that is part of a package.
-- Instead, either drop the entire package using the DROP PACKAGE statement,
-- or redefine the package without the procedure using the CREATE PACKAGE statement with the OR REPLACE clause.



drop procedure pkg_test.proc1;

begin
    pkg_test.proc1;
end;



-- Q 13:
--Self is null:
-- When a member method is invoked on an object type, but its instance has not been initialized, this exception is raised.

--Program error:
begin
    raise program_error;
end;

--Q 16:
create or replace function dflt return number is
    cnt number := 0;
begin
    cnt := cnt + 1;
    return 45;
end dflt;


create or replace procedure p(i in number default dflt()) is
begin
    dbms_output.put_line(i);
end p;
declare
    cnt number := dflt();
begin
    for j in 1..3
        loop
            p(j);
        end loop;
    dbms_output.put_line('cnt:'||cnt);
    p();
    dbms_output.put_line('cnt:'||cnt);
end;


--Q 25:
--Out of range seems to not even exist
declare
begin
    raise out_of_range;
end;

create table test(
    name varchar2(3)
);

--Q 51:
create table test(
    Sequence NUMBER,
    User_Name VARCHAR2 (25),
    Login_Time DATE ,
    Job VARCHAR2 (25),
    Emp_ID NUMBER
)

CREATE or replace procedure Login_Pro (name varchar2) as
begin
    insert into audit_records (user_name) values (name);
end login_pro;


create or replace trigger logon_trig
    after logon
    on database
call login_pro(ora_login_user);



--Bij Q 60 is je keyword all dependencies between objects.
-- ALL_DEPENDENCIES describes dependencies between procedures, packages, functions, package bodies, and triggers accessible
-- to the current user, including dependencies on views created without any database links.
-- This view does not display the SCHEMAID column.

-- DBA_DEPENDENCIES describes all dependencies between objects in the database.
-- This view does not display the SCHEMAID column.

--Dus gaat om "accessible to the current user"