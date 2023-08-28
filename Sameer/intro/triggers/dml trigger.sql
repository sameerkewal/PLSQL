--Trigger uses conditional predicates to detect triggering statement

create or replace trigger t
before
    insert or
    update of salary, department_id, first_name
    or delete
    on emp_copy
    begin
        case
            when inserting then
            dbms_output.put_line('inserting');
            
            when updating('salary') then
            dbms_output.put_line('Updating salary');

            when updating('department_id') then
            dbms_output.put_line('updating department_id');
            
            when deleting then
            dbms_output.put_line('Deleting!');
        end case;
    exception
    when others then --case kan ook exception gooien  maar alleen als die kolumn is
        dbms_output.put_line(sqlerrm);  --in die update of
    end;




--Testing out the above trigger
insert into emp_copy (last_name, email, hire_date, job_id)
values ('Kewal', 'skewal', sysdate,'IT_PROG');


--updating but not on salary or sth
update emp_copy set department_id=0.5 where last_name='Kewal';
update emp_copy set department_id=0.5 where last_name='Kewal';
update emp_copy set last_name=0.5 where last_name='Kewal';
update emp_copy set employee_id=999 where last_name='.5';
select *
from emp_copy;

--Make the trigger throw an exception
--Omdat die first_name wel in die update of is maar niet in die case
--So basically gaat wel in die trigger execution, maar kan die
--first name case niet vinden.
update emp_copy set first_name='Sameer'
where last_name='Kewal';



---------Instead of trigger
-- View, dat niet updateable is, omdat the pk of the orders_table, order_id
--not unique is in the result set of the join view.
--Omdat 1 customer meerdere orders kan hebben dus dan gaat het meer dan 1 keer in die view appearen
create or replace view order_info as
select c.customer_id, c.cust_last_name, c.cust_first_name,
       o.order_id, o.order_date, o.order_status
    from customers c, orders o
    where c.customer_id = o.customer_id;

select *
from order_info;

--inserting into the view
insert into order_info
values (500, 'Test', 8000, 2000, sysdate, 1);


select *
from customers
    where customer_id=170;

create or replace trigger order_info_insert
instead of insert on order_info
declare
    duplicate_info exception;
    pragma exception_init (duplicate_info, -00001);
begin
    insert into customers(customer_id,cust_last_name, cust_first_name)
    values(:new.customer_id, :new.cust_last_name, :new.cust_first_name);

    insert into orders (order_id, order_date, customer_id)
    values (:new.order_id, :new.order_date, :new.customer_id);
    exception
    when duplicate_info then
    raise_application_error(NUM => -20107, MSG => 'duplicate customer or order id');
end order_info_insert;

--Works now!
insert into order_info
values (500, 'Test', 8000, 2000, sysdate, 1);

--Is obv ook in customers
select *
from customers
where customer_id=500;


select *
from orders
where order_id=2000;


-----------Compound Trigger------------
/*A compound DML trigger created on a noneditioning view is not really compound, because it
has only one timing point section. The syntax for creating the simplest compound DML trigger
on a noneditioning view is:*/
/*
CREATE trigger FOR dml_event_clause ON view
COMPOUND TRIGGER
INSTEAD OF EACH ROW IS BEGIN
 statement;
END INSTEAD OF EACH ROW;
*/



create or replace trigger mytrigtest
for insert or update or delete on
emp_copy
compound trigger
myvar number:=200;
before statement
    is
    l_before_stmt number:=100;
    begin
    dbms_output.put_line('before statement');
end before statement;

before each row is
    begin
    dbms_output.put_line('before each row');
end before each row;
    
after each row is
begin
    dbms_output.put_line('after each row');
end after each row ;
    
after statement  is
begin
    dbms_output.put_line('After each statement');
end after statement ;

end mytrigtest;

-- Old new and parent cannot appear in the declarative part, the before or after statement section
create or replace trigger mytrigtest2
    for insert or update or delete
    on
        emp_copy
    compound trigger
--     myvar number:=:old.email;

before statement
    is
    l_before_stmt number := 100;
begin
    dbms_output.put_line('before statement');
end before statement;

    before each row is
    begin
        dbms_output.put_line('before each row');
     :new.email:='skewal';
--      :old.email:='skewal';
    end before each row;

    after each row is
    begin
        dbms_output.put_line('after each row');
    end after each row ;

    after statement is
    begin
        dbms_output.put_line('After each statement');
    end after statement ;
    end mytrigtest2;


alter trigger mytrigtest disable;
alter trigger mytrigtest2 disable;

select * from user_triggers;



--when clause in a trigger
create or replace trigger trigtest
before update or delete on emp_copy --Kan obviously ook after zijn
for each row --optional
    when (new.FIRST_NAME!=old.FIRST_NAME)
begin
    dbms_output.put_line('wwwwwwwwwwwwwwwwwwwww');
end;


update emp_copy
set first_name='steven!!'
where employee_id=100;



--when clause mag niet in een instead of trigger
create or replace trigger instoftrigger
instead of insert on order_info
    for each row 
    when (new.order_id=777)
begin
    dbms_output.put_line('yay');
end instoftrigger;


create or replace view emp_vw as
select employee_id, first_name, last_name, email, phone_number, hire_date,  salary, commission_pct, manager_id, department_id, job_title, min_salary, max_salary
from emp_copy emp join hr.jobs j on j.job_id = emp.job_id;

create or replace trigger instoftrigger
instead of delete on emp_vw for each row
begin
    insert into log (user_name) values ('HR');
end;

select * from log;

delete from emp_vw where employee_id=135;





--When mag ook in een compound trigger
-- zolang het op row level is is alles gucci
create or replace trigger whenTrigger
for update on emp_copy
when (old.email=new.email)
compound trigger
    before each row is
        begin
        dbms_output.put_line('when in compound trigger test');
    end before each row ;
end whentrigger;

/

create or replace trigger whenTrigger2
for update or insert or delete on emp_copy
    when(old.first_name=new.first_name)
compound trigger 
    after each row is
    begin
        dbms_output.put_line(:old.first_name);
    end after each row;
end whentrigger2;


update emp_copy
set first_name='steven!!!'
where employee_id=100;

select trigger_name, status
from user_triggers;

delete from emp_copy;
rollback;


select *
from emp_copy;










----------------Correlation names and pseudorecords--------------------

----You can change the default correlation names using the references clause
create or replace trigger references_clause
before update on emp_copy
referencing old as owd  new as nw
for each row
begin
    dbms_output.put_line(:nw.first_name);
    dbms_output.put_line(:owd.first_name);
end;

update emp_copy
set first_name = 'sam'
where employee_id=100;


