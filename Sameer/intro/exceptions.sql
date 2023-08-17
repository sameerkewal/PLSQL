declare
    invalid_id exception;
    negative_id exception;
    l_test number:= 0;
begin
    if l_test = 0
        then
        raise invalid_id;
    end if;
    exception
    when invalid_id then
    dbms_output.PUT_LINE('invalid id bruh');
end;


/*
EXCEPTION_INIT is a compile-time command or pragma used to associate a name
with an internal error code. EXCEPTION_INIT instructs the compiler to associate an
identifier, declared as an EXCEPTION, with a specific error number. Once you have
made that association, you can then raise that exception by name and write an explicit
WHEN handler that traps the error.*/

--COmment out die exception part
--and then try it uncommented
declare
    invalid_month exception;
    pragma exception_init (invalid_month, -1843);
    random_date date;
begin
    dbms_output.PUT_LINE('yes');
    random_date := to_date('20-20-2002');
exception
when
    invalid_month then
    dbms_output.PUT_LINE('Invalid month spotted!');
end;


--Catching the 2292 exception using pragma
-- without pragma first

declare
    child_records exception;
    pragma exception_init (child_records,-2292);
begin
    delete from departments where department_id=40;
exception
when child_records then
    dbms_output.PUT_LINE('delete child records first!');
end;

declare
begin
    raise_application_error(-20000, 'Custom error msg');
end;


--when others block
--other handler moet verplicht als laatste
declare
    invalid_id exception;
    negative_id exception;
    l_test number:= 0;
begin
    if l_test = 0
        then
        raise negative_id;
    end if;
    exception
    when invalid_id then
    dbms_output.PUT_LINE('invalid id bruh');
    when others then
    dbms_output.PUT_LINE('other errors');
end;




declare
invalid_id exception;
id number:=20;
begin
    if id = 20
        then raise invalid_id;
    end if;
exception
    when invalid_id then
    test123();
end;
/



create or replace procedure test123
as
begin
    dbms_output.PUT_LINE('is gratis');
end;
/
declare
    v_test number;
begin
    v_test:=sysdate-to_date('20-20-2020', 'dd-mm-yyyy');
exception
when others then
    dbms_output.PUT_LINE(sqlerrm);
end;


declare
    v_test number;
begin
    v_test:=sysdate-to_date('20-20-2020', 'dd-mm-yyyy');
exception
when others then
    dbms_output.PUT_LINE(dbms_utility.FORMAT_ERROR_STACK());
end;

select employee_id, ",first_name, ", salary "salaris van de maand"
from employees;


--Voorbeeld van een stack trace
create or replace procedure proc1 is
begin
    dbms_output.put_line('running proc1');
    raise no_data_found;
end;
/
create or replace procedure proc2 is
    l_str varchar2(30) := 'calling proc1';
begin
    dbms_output.put_line(l_str);
    proc1;
end;
/


create or replace procedure proc3 is
begin
    dbms_output.put_line('calling proc2');
    proc2;
exception
    when others
        then
            dbms_output.put_line('Error stack at top level:');
            dbms_output.put_line(dbms_utility.format_error_backtrace);
end;


begin
        proc3();
end;


begin
    sqlerrm(2992);
end;

/*Combining Multiple Exceptions in a Single Handler
You can, within a single WHEN clause, combine multiple exceptions together with an
OR operator, just as you would combine multiple Boolean expressions:
WHEN invalid_company_id OR negative_balance
THEN
You can also combine application and system exception names in a single handler:
WHEN balance_too_low OR ZERO_DIVIDE OR DBMS_LDAP.INVALID_SESSION
THEN
You cannot, however, use the AND operator because only one exception can be raised
at a time.
*/

declare
    invalid_id exception;
    invalid_char exception;

    l_id number:=0;
    l_character varchar2(20):='test';
begin
    dbms_output.PUT_LINE('test');
    raise invalid_id;
exception
when
    invalid_id or invalid_char then
    dbms_output.PUT_LINE('je mag alleen een or hebben bij je when van je exception block');
    dbms_output.PUT_LINE('omdat maar 1 exception at a time geraised kan worden');
end;


--Exceptions zoeken naar een exception handler in the block they were defined
--Vinden ze het niet daar, dan zoeken ze naar een exception handler in the enclosing block
--Also dan kennnen ze die naam van die exception niet meer right.
declare
    v_test number:=2;
begin
    <<inner_block>>
    declare
        v_error exception;
    begin
        raise v_error;
    end inner_block;
    exception
    when others then
    dbms_output.PUT_LINE('caught in outer block');
end;


--Zo kan die outerste block toch weten welke error is geraised. Not by name maar wel bij error code(user defined)
declare
    v_test number:=2;
    inner_exception exception;
begin
    <<inner_block>>
    declare
        truncate_error exception;
        pragma exception_init(truncate_error, -20099);
    begin
      raise truncate_error;
    end inner_block;
    exception
    when others then
        dbms_output.PUT_LINE(sqlerrm);
        dbms_output.PUT_LINE('caught in outer block');
end;


--Na het catchen van die error gaat hij control resumen in the parent block
declare
    v_test number:=2;
    inner_exception exception;
begin
    <<inner_block>>
    declare
        truncate_error exception;
        pragma exception_init(truncate_error, -20099);
    begin
      raise truncate_error;
      dbms_output.PUT_LINE('resuming control');
    exception
        when truncate_error
        then dbms_output.PUT_LINE('ueue');
    end inner_block;
    dbms_output.PUT_LINE('resuming control in outer block');
    exception
    when others then
        dbms_output.PUT_LINE(sqlerrm);
        dbms_output.PUT_LINE('caught in outer block');
end;

--Make a procedure then throws an error and then call it
--Dan kan je die error code niet zien in outer block
create or replace procedure errortest is
l_test number:=20;
l_error exception;
pragma exception_init (l_error, -20099);
begin
    if l_test = 20
        then
        raise l_error;
    end if;
/*exception
    when l_error then
    dbms_output.PUT_LINE('procedure stuff: ' || sqlerrm());*/
end;


begin
    errortest;
exception
    when others
        then
            dbms_output.put_line(sqlerrm);
end;

declare
    thisisfinnabeaverylongstringbruv number:=20;
begin
    dbms_output.PUT_LINE(length('thisisfinnabeaverylongstringbruv'));
end;


declare
   emp_salary number not null:=20;
    emp_salary2 emp_salary%type:=40;
    begin
    dbms_output.PUT_LINE('test');
end;


