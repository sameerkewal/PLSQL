define x= "the answer is 42";

variable x varchar2(10)
begin
    :x := 'Hello';
end;
/
print :x

--Define are always character strings expanded by sqlplus and declared variables are used as
-- true bind variables in sql and sqlplus
select :x, '&x' from dual;


--Deze table kan je queryen om je hele source code te zien van procedure, function of trigger
select *
from user_source;

--When you first create a plsql program no one, but u and dba can execute it. To give another user the authority to execute your program issue a grant

grant execute on testfunc to sameer;

revoke execute on testfunc from sameer;

/*If you grant a privilege to an individual like Scott, and to a role of which that user is a
member (say, all_mis), and also grant it to PUBLIC, the database remembers all three
grants until they are revoked. Any one of the grants is sufficient to permit the individual
to run the program, so if you ever decide you don’t want Scott to run it, you must revoke
the privilege from Scott, and revoke it from PUBLIC, and finally revoke it from the
all_mis role (or revoke that role from Scott).*/



--Voorbeeld van een anonynomous block
declare
    l_right_now varchar2(8);
begin
    l_right_now := sysdate;
    dbms_output.put_line(sysdate);
    dbms_output.put_line(length(sysdate));
    exception
        when value_error
        then
        dbms_output.PUT_LINE('l_right_now is too small');
    end;
/


--voorbeeld van een nested anonymous block waarbij het aantal maanden in gegeven jaar berekent
--yes is veel code for sth simple maar is een voorbeeld
--Nested blocks worden enclosed block, child block or subblock genoemd
--Outer plsql block may be called the enclosing block or the parent block
-- Month total which is declared in the inner block is dan niet beschikbaar in je outer block
--maar year_total declared in je outer block is dan wel beschikbaar
create or replace procedure calc_totals
is
    year_total number;
begin
    year_total:= 2;
    declare
        month_total number := 0;
    begin
        month_total := year_total * 12;
        dbms_output.PUT_LINE(month_total);
    end set_month_total;
end;


--nested block 2 kan year_total ook accessen
create or replace procedure calc_totals2
    is
    year_total number;
begin
    year_total := 2;
    <<nested_block1>>
        declare
        month_total number := 0;
    begin
        month_total := year_total * 12;
        dbms_output.put_line(month_total);
        <<nested_block2>>
            declare
            test_s number := 12;
        begin
            dbms_output.put_line(year_total);
        end;
    end;
end calc_totals2;
/

--Within an embedded SQL statement, the Oracle database always attempts to resolve
-- unqualified identifier references first as columns in one of the specified tables. If it
--cannot find a match, it then tries to resolve the reference as an in-scope PL/SQL variable.


create or replace procedure proceduretest
    is
    l_test number := 20;
begin
    dbms_output.put_line(l_test);
end;
/

--In PL/SQL, local variables declared in a procedure are only accessible within the body of that procedure.
-- They are not visible or accessible outside the procedure's scope
begin
    dbms_output.PUT_LINE(proceduretest.l_test);
end;

-- I can also qualify the name of an identifier with the module in which it is defined:
--zoals volgt:
--By default gaat het nemen van wat local is so if u have the same name and want it to take the one that is defined
-- in the outer block dan moet je het wel prefixen(also als je je anonymous blocks named dan kan je het ook daarmee prefixen)

create or replace procedure calc_totals
is
salary number := 40;
begin
    <<nested_block1>>
    declare
     salary number:= 20;
    begin
         dbms_output.PUT_LINE(nested_block1.salary);
        <<nested_block2>>
        declare
         --salary number := 60;
        begin
        dbms_output.PUT_LINE(salary);--Het probeert gewoon de dichtsbijzijnde like value ig te pakken,
        end;                            --Als het niet locally te vinden is dan kan je het buiten scope vinden
    end;                                --Like als je die salary hier outcomment dan gaat hij 20 zetten die van nested_block1
end;


begin
    calc_totals();
end;




--Al heb je een procedure in een procedure, vanuit buiten kan je nog steeds niet die binnenste procedure callen
create or replace procedure calc_totals
    is
    subtotal number := 0;
    procedure compute_running_total
        is
    begin
        subtotal := subtotal + 20 * 50;
        dbms_output.PUT_LINE('subtotal is: ' || subtotal);
    end;
begin
    calc_totals.compute_running_total();
    dbms_output.put_line('test');
end;


begin
    calc_totals();
end;
/


create or replace procedure calc_total
is
begin
    dbms_output.put_line('test');
end;
/



declare
    v_age constant number:= 20;
    test constant integer := 20;
    l_test constant number := 20;
begin
    dbms_output.PUT_LINE(l_test);
end;


declare
    str char(1) := '';
begin
    dbms_output.PUT_LINE('The line of the char is ' || length(str));
    if str is null then
        dbms_output.put_line('yes');
    end if;
end;

<<test>>
declare
    str char(1) := '';
begin
    <<what>> -- je kan ook identifiers randomly midden ergens hebben
    dbms_output.PUT_LINE('The line of the char is ' || length(str));
    if str is null then
        dbms_output.put_line('yes');
    end if;
end test;


--If else/if elseif/ block stuff
--Else block gaat basically alleen triggeren als salary gelijk is aan 40000 of null is
declare
    salary number := :test;
begin
    if salary>40000 then
        dbms_output.PUT_LINE('wtf');
    elsif salary < 40000 then
        dbms_output.PUT_LINE('else if block');
    else
        dbms_output.PUT_LINE('else block');
    end if;
end;
/


--Je kan booleans ook gewoon assignen door middle van een statement like this
declare
    l_result boolean;
begin
    l_result := 2=3;
    if l_result then
        dbms_output.PUT_LINE('2 groter dan 1 inderdaad');
    else
        dbms_output.PUT_LINE('not true');
    end if;
end;













-----------------Go To statements-----------------
-- This means that a GOTO in the execution section may not go to a label in the exception section,
-- and a GOTO in the exception section may not go to a label in the execution section.
declare
begin
    declare
        l_test number:= 20;
    begin
        goto log;
    end;
    <<log>>
    dbms_output.PUT_LINE('gotohere');
end;


--Dit mag niet omdat elke if statement zijn eigen block is
declare
begin
    declare
        l_test number:= 20;
    begin
         if l_test = 20 then
             goto log;
         end if;
         if l_test is null then
    <<log>>
    dbms_output.PUT_LINE('gotohere');
    end if;
    end;
end;

--Another example
declare
    l_test number := 20;
begin
    goto test;
    if l_test = 20 then
        <<test>>
        dbms_output.PUT_LINE('yp');
    end if;
end;

