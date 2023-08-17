declare
l_test varchar2(200 char);
l_test2 string(200):='sameer';
    begin
    l_test:='sad';
    dbms_output.PUT_LINE(l_test2);
end;






--Rowid
--The U in UROWID stands for universal,
--and a UROWID variable can contain any type of ROWID from any type of table.
declare
employee_rowid urowid;
employee_salary number;
begin
    select rowid, salary into employee_rowid, employee_salary
    from employees
    where last_name='Gee' and first_name='Ki';
end;

/
select *
from employees
where last_name like 'G%';


/*The main use of ROWIDs is in repeating access to a given database row. This use is
particularly beneficial when accessing the row is costly or frequent. Recall the example
from the previous section in which I retrieved the salary for a specific employee. What
if I later want to modify that salary? One solution would be to issue an UPDATE state‐
ment with the same WHERE clause as the one I used in my original SELECT:*/

/*
To retrieve a rowid into a UROWID variable, or to convert the value of a UROWID variable to a
rowid, use an assignment statement; conversion is implicit.
*/


declare
l_char varchar2(2000);
begin
    select rowid into l_char from employees
        where employee_id=100;
    dbms_output.PUT_LINE(l_char);
end;
/




create or replace function testproc(test1 boolean)
    return number
    is
begin
    dbms_output.PUT_LINE(sys.diutil.BOOL_TO_INT(test1));
    return sys.diutil.BOOL_TO_INT(test1);
end;
/

declare
    l_test boolean:=true;
    l_result number;
    begin
    select testproc(false) into l_result
    from dual;
    dbms_output.PUT_LINE(l_result);
end;

--Je mag een boolean wel zo gebruiken
select testproc(true)
from dual;


--Showing how ranges work
declare
    subtype digit is pls_integer range 0..9;
    subtype double_digit is pls_integer range 10..99;
    subtype under_100 is pls_integer range 0..99;

    d digit:=4;
    dd double_digit:=10;
    u under_100;
    begin
    u := d; --4 is tussen 0 en 99
    u:=dd --10 is tussen 0 en 99
    dd:=d; --4 is niet tussen 0 en 99 vandaar dit failed
    dbms_output.PUT_LINE(dd);
end;

=
