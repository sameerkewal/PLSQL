--Q1:
drop user sameer;

create user sameer identified by sameer;
grant create session to sameer;
grant unlimited tablespace to sameer;
grant create any procedure to sameer;


grant execute any procedure to sameer;


--Andrew does need additional privileges(the execute any procedure to be specific)


--Q 9:
alter table emp_copy enable all triggers;

--Q 29:
select *
from user_errors;

--Q 34:
--Je hebt wel access to new and old, maar je mag new niet veranderen
--En old is ofc altijd null wanneer je insert;
--  ORA-04084: cannot change NEW values for this trigger type

drop view emp_vw;

create or replace view emp_vw
as select *
from emp_copy;

create or replace trigger emp_trig
    instead of update
    on emp_vw
    for each row
declare
    l_value number;
begin
    l_value:=:old.employee_id;

    if l_value is null then
        dbms_output.put_line('shit is null');
    end if;
--     :new.employee_id:=2000;


    dbms_output.put_line(:old.EMPLOYEE_ID);
--     :new.employee_id:=200;
    insert into log(user_name)
    values (:new.employee_id);
end;

insert into emp_vw
values (999, 'IT_PROG', 'Programmer', 0, 0);

update emp_vw set EMPLOYEE_ID = 9999 where DEPARTMENT_ID=100;

select *
from log;

truncate table log;


--Q 36:
select *
from user_triggers;


--Q 43: kan je ook andere soort triggers op een view maken
-- ORA-25001: cannot create this trigger type on this type of view
create or replace trigger whattrigger
before update on emp_vw
begin
    dbms_output.put_line('hjeeh');
end;