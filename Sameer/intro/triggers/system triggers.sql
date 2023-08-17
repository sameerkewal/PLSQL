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



create table test(
    id number
);


select *
from employees;