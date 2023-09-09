-- Q 22
declare
    sal_too_high exception;
    pragma exception_init (sal_too_high, -20000);
begin
    raise sal_too_high;
exception
    when sal_too_high then
    dbms_output.put_line(sql);
end;



--Q 37:

create or replace function testfunc return number as
begin
    return 39;
end;


create or replace function testfunc return number is
begin
    return 20;
end;


select testfunc from dual;



--Q 47:
declare
    a number(3) := 100;
begin
    if (a = 50) then
        dbms_output.put_line('value of a is 10' );
        elsif(a = 75) then
            dbms_output.put_line( 'value of a is 20');
    else
    dbms_output.put_line('none of the values is matching');
    end if;
    dbms_output.put_line(‘exact value of a is: ‘|| a );
end;

--  Q 48
-- SELF_IS_NULL exception is raised when a member method is invoked on an object type,
-- but its instance has not been initialized, this exception is raised.

--Q 63:

CREATE OR REPLACE TYPE list_of_names_t IS VARRAY (3) OF VARCHAR2(10);


declare
    names list_of_names_t:=list_of_names_t(10, 20, 30);
begin
    dbms_output.put_line(names.limit);
    names.extend;
    null;
end;

alter type list_of_names_t modify limit 40;
