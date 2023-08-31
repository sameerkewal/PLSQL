--Q 1:
declare

    cursor c is select LAST_NAME, SALARY from employees;
    type ac is table of c%rowtype index by string(1000);
    ass_arr ac;
begin
    select LAST_NAME, SALARY bulk collect into ass_arr
    from employees;


end;
-- PLS-00657: Implementation restriction: bulk SQL with associative arrays with VARCHAR2 key is not supported.
--Reference voor 1:
--  https://docs.oracle.com/cd/B13789_01/appdev.101/b10807/13_elems020.htm#:~:text=You%20can%20use%20the%20BULK,in%20client%2Dside%20programs).


--Bij 6 bij B is het juist omgekeerd iirc

--Q 14:
create or replace procedure proc1 is
begin
    dbms_output.put_line('testting');
end;

drop trigger testtrigger;
create or replace trigger testtrigger
before update on emp_copy
begin
    proc1;
end;

update emp_copy set employee_id=9999 where employee_id=105;


alter table emp_copy disable all triggers;

-- https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/plsql-triggers.html#GUID-39111AAC-597E-4661-82A6-F3BE621F75BB




--Q 15:
create or replace package comm_package IS
    g_comm number := 10;
    procedure reset_comm(p_comm in number);
end comm_package;


EXECUTE comm_package.g_comm := 15;


--Q 16:
--They are fired only whenever the owner of the object ussues the ddl statement
--Onwaar want je kan het ook op database niveau aanmaken. Time to ruin this shit
create or replace trigger drop_trigger
before drop on database
begin
    loop
        dbms_output.put_line('lmfao');
    end loop;
end;
drop trigger drop_trigger;



--Q 27:
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/CREATE-TRIGGER-statement.html#GUID-AF9E33F1-64D1-4382-A6A4-EC33C36F237B


--Bij 31 is het bij A juist omgekeerd


--Q 33:
-- llegal EXIT/CONTINUE statement; it must appear inside a loop
begin
    if true then
        continue;
    end if;
    dbms_output.put_line('wjat');
end;

--Q 35:
create table log_trig_table
(
    user_id  varchar2(30),
    log_date timestamp,
    action   varchar2(40)
);


create or replace trigger logoff_trig________ ___________ ___________
    BEGIN
    INSERT into log_trig_table(user_id, log_date, action) values (user, sysdate, 'logging off');
    end;



    --Q 38:
CREATE or replace package manage_emp IS
    v_empno number;
    procedure del_emp (p_empno number);
end manage_emp;

create or replace package body manage_emp IS
    PROCEDURe del_emp (p_empno number) IS
        BEGIN
            DELETE from emp where empno = p_empno;
        end del_emp;
end manage_emp;


cREATE or replace package emp_det IS
    PROCEDURE emp_chk (p_empno number);
end emp_det;
create or replace package body emp_det IS
    PROCEDURE emp_chk (p_empno number);
end emp_det;
;
create or replace package body emp_det IS
    PROCEDURE emp_chk (p_empno number) IS
        BEGIN
            manage_emp.del_emp(p_empno);
    end emp_chk;
end emp_det;


--Q 40:
begin
    proc2;
end;


--Q 46:
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/plsql-source-text-wrapping.html#GUID-AB6FFBAD-DE20-4197-A885-AF81F3766FA2


--Q 50:
/*
if the optimization level (set by plsql_optimize_level) is less than 2:
• the compiler generates interpreted code, regardless of plsql_code_type.
• If you specify NATIVE, the compiler warns you that NATIVE was ignored.
*/

--dus met andere woorden om native te gebruiken moet je plsql_optimize level 2 of meer zijn.


-- https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/plsql-optimization-and-tuning.html#GUID-F87C76F7-5044-4A8F-AD73-2A946EFFB31D



--Q 55:
--antwoord was inderdaad A en D
select *
from user_objects;


select *
from user_dependencies;


--Q 57:
create or replace package player_pack is
    v_max_team_salary number(12, 2);
    procedure add_player(v_id in number, v_last_name varchar 2, v_saiary number) ;
end player_pack;




