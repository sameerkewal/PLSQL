create or replace procedure lower_salary(emp_id number, amount number) as
    pragma autonomous_transaction;
begin
    update emp_copy
    set salary = salary - amount
    where employee_id = emp_id;
    commit;
end lower_salary;

commit;

--En nu in een block
declare
    pragma autonomous_transaction;
    emp_id number:=200;
    amount number:=200;
begin
  /*  declare
        pragma autonomous_transaction;
    begin
        update emp_copy set salary=salary*1.09;
    end;*/
    update emp_copy set salary = salary+100;
     commit;
end;




--
-- When you enter the executable section of an autonomous routine, the main transaction
-- suspends. When you exit the routine, the main transaction resumes.
-- If you try to exit an active autonomous transaction without committing or rolling back, the
-- database raises an exception. If the exception is unhandled, or if the transaction ends
-- because of some other unhandled exception, then the transaction rolls back.
create or replace procedure lower_salary2(emp_id number, amount number) as
    pragma autonomous_transaction;
begin
    update emp_copy
    set salary = salary - amount
    where employee_id = emp_id;
--     commit;
end lower_salary2;


declare

begin
    lower_salary2(100, 2000);
end;


select salary
from emp_copy
where employee_id=100;

update emp_copy set salary=1000
where employee_id=100;


delete from emp_copy;
commit;
rollback;

