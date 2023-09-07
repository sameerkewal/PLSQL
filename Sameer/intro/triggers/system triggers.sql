--dit is voor any ddl statement
create or replace trigger drop_trigger
before ddl on schema
begin
    dbms_output.put_line('ddl trigger');
end;



--Well probably belangrijk te weten maar je kan system triggers niet renamen
alter trigger drop_trigger rename to any_ddl_trigger;


--System trigger works!
alter trigger references_clause rename to reference_clause;


create or replace trigger drop_trigger
before drop on schema
begin
    dbms_output.put_line('Drop trigger');
end;




--Trigger works
drop table t1;

create user sameer identified by sameer;


create or replace trigger log_errors
after servererror on database
begin
    if(IS_SERVERERROR(1017)) then
        dbms_output.put_line('uhhh');
        insert into hr.log values ('test' || hr.employees_seq.nextval);
        commit;
    else 
        dbms_output.put_line('succeed');
    end if;
end;
--probeer in te loggen via een andere session with a wrong pw and it works!




--Trigger to log who logs in to the database
create or replace trigger login_log
after logon on database
begin
        insert into hr.log values ('l ' || sys_context('USERENV', 'SESSION_USER'));
        commit;
end;

create user sam identified by sam;
grant create session to sam;

--Instead of schema trigger(wut doesnt seem like it'd work)
create or replace trigger yuh
    instead of create on schema
begin
    execute immediate 'create table t
        (n number, m number)';
end;
drop trigger yuh;

--Nadat de user logged in op schema specifiek
create or replace trigger after_logon_schema
after logon on schema
begin
    insert into log (name) values ('hhhfhfhfh');
    commit;
end;

--trigger that calls an subprogram with tcl statements
create or replace procedure invokeThis
is
    pragma autonomous_transaction;
    l_email employees.email%type;
begin
    update emp_copy set email = 'skewal' where employee_id=100 returning email into l_email;
    dbms_output.put_line('updated email to: ' || l_email);
    commit;
end;


begin
    invokeThis;
end;

create or replace trigger dept_trigger
before update on dept_copy
begin
    invokeThis;
end;


select *
from emp_copy;


update dept_copy
set department_name = 'Admin'
where department_id=10;


---------------Mutating trigger------------------
create or replace trigger mutating_t
before update on emp_copy
for each row
begin
    update emp_copy set employee_id=1000 where first_name='sameer';
end;


update emp_copy set first_name='what' where employee_id=104;





--Nog een mutating table
drop table log;
create table log
(
    emp_id number(6),
    l_name varchar2(25),
    f_name varchar2(20)
);

create or replace trigger log_deletions
after delete on emp_copy
for each row
declare
    n integer;
begin
    insert into log values(:old.employee_id, :old.last_name, :old.first_name);
    select count(*) into n from emp_copy;
    dbms_output.put_line('There are now: ' || n || ' employees.');
end;



delete from emp_copy where employee_id=120;

drop procedure p;
drop table p;

create table p
(
    p1 number
        constraint pk_p_p1 primary key
);
insert into p values (1);
insert into p values (2);
insert into p values (3);
drop table f;

create table f
(
    f1 number
        constraint fk_f_f1 references p
);

insert into f values (1);
insert into f values (2);
insert into f values (3);

create or replace trigger pt
    after update
    on p
    for each row
begin
    update f set f1 = :new.p1 where f1 = :old.p1;
end;


select *
from p;

select *
from f;


drop function f;
drop table f;

commit;
update p set p1=p1+1;

/* If you are creating two or more triggers with the same timing point, and the order in
which they fire is important, then you can control their firing order using the FOLLOWS
and PRECEDES clauses (see "FOLLOWS | PRECEDES")*/
--If u dont specify that dan gaat die order random zijn

-- Use PRECEDES to indicate that the trigger being created must fire before the specified
-- triggers. You can specify PRECEDES only for a reverse crossedition trigger
--Dus dit gaat niet werken
create or replace trigger precedesTrigger
before update on emp_copy
for each row
    precedes hr.followsTrigger
begin
    dbms_output.put_line('this trigger goes first');
end;


create or replace trigger followsTrigger
before update on emp_copy
for each row
    follows hr.precedestrigger
begin
    dbms_output.put_line('this trigger goes second');
end;

select *
from emp_copy;

update emp_copy
set  first_name= 'sameer!'
where first_name='sameer';

select *
from emp_copy;
drop table emp_copy;
create table emp_copy
as select *
   from employees;

--Compound trigger net een follows clauses
create or replace trigger comp_trig
for update or delete on emp_copy
    follows hr.followsTrigger
compound trigger
before each row is
begin
    dbms_output.put_line('Compound trigger 3rd trigger');
end before each row;

    --Makes sense this goes last bc u specified "follows hr.followTrigger"
after statement is
    begin
        dbms_output.put_line('in after statement of compounded trigger');
    end after statement ;

end comp_trig;


create or replace trigger followsTrigger after update on emp_copy
begin
    dbms_output.put_line('updated in followstrigger');
end;

update emp_copy
set first_name = 'sam'
where employee_id=100;



-- If your compound trigger has a BEFORE STATEMENT section,
-- you can use FOLLOWS to make it execute after another BEFORE STATEMENT trigger on the same table.
--In dit geval is dat voor de Before each row
update emp_copy set first_name='sameer'
where employee_id=100;

--Dit kan je doen om alle triggers in 1 keer te disablen
alter table emp_copy disable all triggers;



create or replace trigger ttttt
after startup on database 
when(2=2)
begin
    dbms_output.put_line('test');
end;



create or replace trigger testtrigger
after logon on hr
when 2=2
begin
    dbms_output.put_line('test2');
end;


create or replace function hr.functiontest return number is
begin
return 2;
end;



select * from user_triggers;


