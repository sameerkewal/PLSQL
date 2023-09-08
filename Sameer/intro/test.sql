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



declare
    type ntb1 is table of varchar2(20);
    v1 ntb1 := ntb1(‘hello’, ‘world’, ‘test’);
    type ntb2 is table of ntb1 index by pls_integer;
    v3 ntb2;
begin
    v3(31) := ntb1(4, 5, 6);
    v3(32) := v1;
    v3(33) := ntb1(2, 5, 1);
    v3(31) := ntb1(1, 1);
    v3.delete;
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


declare
    type name_list_type is table of employees.first_name%type;
    names name_list_type;
begin
    if names.count is null then
        dbms_output.put_line('what');
    end if;

    if cardinality(names) is null then
        dbms_output.put_line('test');
    end if;
end;


select *
from user_procedures;

select *
from all_arguments;


declare
    x number:= 5;
    y number:= null;
begin
    if x!=y then
        dbms_output.put_line('x!=y');
    elsif x = y then
        dbms_output.put_line('x = y');
    else
        dbms_output.put_line('Cant tell if and y are equal or not');
    end if;
end;


select *
from emp_copy;


create or replace trigger max_salary_limit
    before insert or update of salary on emp_copy
    for each row
    when(new.salary>0)
    begin
       if updating then
           dbms_output.put_line(:old.salary);
           :new.salary:=:old.salary;
       end if;
    end;



update emp_copy
set salary = 2000
where first_name='Steven' and last_name='King';


select first_name, last_name, salary
from emp_copy;



create or replace function returnFifty return number is
    begin
        return 50;
    end;

select returnFifty from dual;


declare
    dyn_stmt varchar2(100);
    l_ret number:=0;
begin
    dyn_stmt:='begin :test := returnFifty; end;';
    execute immediate dyn_stmt using out l_ret;
    dbms_output.put_line('the return value is: ' ||  l_ret);
end;



create or replace package pkg1 is
    pragma serially_reusable;
    num number:=0;
    procedure init_pkg_state(n number);
    procedure print_pkg_state;
end pkg1;


create or replace package body pkg1 is
    pragma serially_reusable;
    procedure init_pkg_state(n number) is
    begin
        pkg1.num:=n;
        dbms_output.put_line('Num: ' || pkg1.num);
    end;

    procedure print_pkg_state is
    begin
        dbms_output.put_line('Num: ' || pkg1.num);
    end;
end pkg1;


begin
    pkg1.INIT_PKG_STATE(10);
    pkg1.print_pkg_state;
end;

begin
    pkg1.print_pkg_state;
end;


create or replace package test_pkg is
    num number:=0;
    procedure init_pkg_state(n number);
    procedure print_pkg_state;
end test_pkg;


create or replace package body test_pkg is
    procedure init_pkg_state(n number) is
    begin
        pkg1.num:=n;
        dbms_output.put_line('Num: ' || pkg1.num);
    end;

    procedure print_pkg_state is
    begin
        dbms_output.put_line('Num: ' || pkg1.num);
    end;
end test_pkg;



begin
    test_pkg.INIT_PKG_STATE(10);
end;


begin
    test_pkg.print_pkg_state;
end;



declare
    a naturaln:=20;
begin
    dbms_output.put_line(a);
end;

declare
    type varchar_type1 is varray(3) of varchar2(15);
    type varchar_type2 is varray(3) of varchar2(15);
    type varchar_type3 is varray(3) of varchar2(15);
    type nested_typ is table of varchar_type3;

--     n_table1 nested_typ:=varchar_type3('AB1');

    list_a varchar_type1:=varchar_type1('Seattle', 'Tokyo', 'Paris');
    list_b varchar_type1;
    list_c varchar_type2;

begin
    list_b:=list_a;
--     list_c:=list_a;

    if cardinality(list_a) is null then
        dbms_output.put_line('what the hell boy');
    end if;

end;



declare
    a natural:=0;
    b positive:=1;
begin
    dbms_output.put_line(a);
end;



create or replace package test_pkg is
function a(p number, p2 number) return number;
function a(p number, p2 number, p3 number) return number;
end test_pkg;

select object_name, procedure_name, overload
from user_procedures
where procedure_name = 'A';


select *
from user_arguments
where object_name = 'A';


select *
from user_source;


select *
from user_dependencies;


create table test_table(
    id number,
    name varchar2(20) invisible
);

insert into  test_table
values(1, 'sam');
alter table test_table modify name visible;

create or replace procedure uh is
    cursor c is select * from test_table;
begin
    for i in c loop
        dbms_output.put_line(i.id || i.name);
        end loop;
exception
    when others then
    dbms_output.put_line('what');
end;


begin
    uh;
exception
    when others then
    dbms_output.put_line('ya');
end;


declare
    type list_typ is table of number;
    type index_by is table of number index by pls_integer;

    l_list list_typ:= list_typ();
    mymap index_by;
begin
    mymap(10):=21;

    if l_list.limit is null then
        dbms_output.put_line('teehee');
    end if;

    if mymap.limit is null then
        dbms_output.put_line('teehee2');
    end if;
end;


declare
    type aa_type is table of integer index by pls_integer;
    aa aa_type; -- associative array

begin
    aa(1) := 3;
    aa(2) := 6;
    aa(3) := 9;
    aa(4) := 12;

    dbms_output.put('aa.COUNT = ');
    dbms_output.put_line(nvl(to_char(aa.count), 'NULL'));
    dbms_output.put('aa.LIMIT = ');
    dbms_output.put_line(nvl(to_char(aa.limit), 'NULL'));
end;




create or replace procedure
    format_call_stack_12c is
begin
    dbms_output.put_line('LexDepth Dynamic Depth Name');
    dbms_output.put_line('------------------ ------------------ -------------------');
    for the_depth in /*reverse*/ 1..utl_call_stack.DYNAMIC_DEPTH loop
        dbms_output.put_line(lpad(utl_call_stack.LEXICAL_DEPTH(the_depth), 10)||
                             rpad(the_depth, 15)||
                             utl_call_stack.CONCATENATE_SUBPROGRAM(
                                 utl_call_stack.SUBPROGRAM(the_depth)
                                 ));
        end loop;
end;



create or replace package test_pkg is
    procedure do_stuff;
end;


create or replace package body test_pkg is
    procedure do_stuff is
        procedure np1 is
            procedure np2 is
                procedure np3 is
                begin
                    FORMAT_CALL_STACK_12C;
                end np3;
            begin
                np3;
            end np2;
        begin
            np2;
        end np1;
    begin
        np1;
    end do_stuff;
end test_pkg;


begin
    test_pkg.do_stuff;
end;



select returnFifty() from dual;



create or replace trigger drop_trigger
before drop on hr.schema
begin
    raise_application_error(-20000, 'cannot drop');
end;

create or replace package test_pkg is
function getF return number;
procedure setF(n number);
end test_pkg;


create or replace package body test_pkg is
value number:=20;
function getF return number is
begin
    return value;
end getF;

procedure setF(n number) is
begin
    value:= n;
end setF;
end test_pkg;


select test_pkg.getF from dual;

begin
    test_pkg.setF(500);
end;







declare
    v_wage number not null:=1000;
--     v_total_wage v_wage%type;

    work_complete constant boolean:=true;
    all_work_complete work_complete%type;

begin
    all_work_complete:=false;

    if all_work_complete = true then
        dbms_output.put_line('true');
    else
        dbms_output.put_line('yeeh');
    end if;
end;





create table emp_copy
as select *
from employees;



/*View Exhibit and examine the structure of the EMP and dept tables. Examine the trigger code that is defined on the dept table to enforce the update and delete restrict
referential actions on the primary key of the dept table.*/
create or replace trigger what before delete or update of employee_id on emp_copy
begin
    dbms_output.put_line(:old.EMPLOYEE_ID);
end;



--Q 233:
create or replace type tet is table of number;

create or replace package pkg is
    type rec_typ is record(price number, inc_pct number);
    procedure calc_price(price_rec in out tet);
end pkg;


create or replace package body pkg is
    procedure calc_price(price_rec in out tet) as
    begin
        dbms_output.put_line('what');
        price_rec:=tet(10, 20, 30, 40);
    end calc_price;
end pkg;


declare
    l_result tet;
begin
    execute immediate 'begin pkg.calc_price(:x); end;' using in out l_result;
    dbms_output.put_line(l_result.count);
end;



--Q 247:

declare
    type test is table of number index by pls_integer;

    l_var test;
begin
    l_var(10):=100;
    l_var(20):=200;
    l_var(30):=300;
    l_var(40):=400;
    
    dbms_output.put_line(l_var(10));
    
--     for indx in l_var.first..l_var.last loop
--         dbms_output.put_line(l_var(indx));
--         end loop;
end;


declare
    type list_typ is table of number index by pls_integer;
    l_list list_typ;
    l_index number;
begin
    select SALARY bulk collect into l_list from employees;

    for l_index in l_list.first..l_list.last loop
        if(l_list(l_index)<10000) then
            l_list(l_index -1):=l_list(l_index);
            l_list.delete(l_index);
        end if;
    end loop;

    for i in l_list.first..l_list.last loop
        dbms_output.put_line(l_list(i));
        end loop;
end;



create or replace function testfuncc return number deterministic is

    function f return number deterministic is
        begin
            return 50;
        end;
begin
    return f;
end;


begin
    dbms_output.put_line(testfuncc);
end;


declare
    function f return number deterministic is
    begin
        return 50;
    end;
begin
    dbms_output.put_line(f);
end;


-----
create or replace trigger t
    instead of create on schema
begin
    dbms_output.put_line('test');
end;

truncate table log;
drop table log;

create table log1(
    id number
);


select *
from log1;


select *
from log;


declare
    a$$ number:=20;
    ab##d number:=69;
begin
    dbms_output.put_line(a$$);
    dbms_output.put_line(ab##d);
end;




alter session set plsql_warnings='DISABLE:ALL';
alter session set plsql_warnings='ENABLE:INFORMATIONAL';
alter session set plsql_warnings='ENABLE:PERFORMANCE';
alter session set plsql_warnings='ENABLE:SEVERE';


create or replace procedure proc1 is
    l_result number;
    begin
        l_result:=5/0;

    exception
        when others then
        dbms_output.put_line(sqlerrm);
    end;

delete from departments;


--ORA-21000: error number argument to raise_application_error of -2292 is out of range
create or replace procedure proc1 is
    fk_err exception;
    pragma exception_init (fk_err, -2292);

begin
    raise_application_error(-2292, 'error');
exception
    when fk_err then
    dbms_output.put_line('error');
end;

begin
    proc1;
end;




create or replace package pkg is
    x number := 20;
    function f return number deterministic;
end pkg;


--PLS-00371: at most one declaration for 'X' is permitted
create or replace package body pkg is
    x number:=50;
    function f return number is 
    begin
       return x;
    end;
end pkg;


begin
    dbms_output.put_line(pkg.x); 
end;

-- If the body of an instantiated, stateful package is recompiled (either explicitly, with
-- the "ALTER PACKAGE Statement", or implicitly), the next invocation of a
-- subprogram in the package causes Oracle Database to discard the existing
-- package state and raise the exception ORA-04068

create or replace package pkg is
x number:=21;
function f return number;
end pkg;


create or replace package body pkg is
function f return number is
    begin
        return 71;
    end;
end pkg;


begin
    dbms_output.put_line(pkg.x);
end;

alter package  pkg compile;

begin
    pkg.x:=50;
end;

create or replace package pkg2 is
function f return number;
end pkg2;

create or replace package body pkg2 is
function f return number is
    l_sal number(10);
    begin
        select SALARY into l_sal from emp_copy
            where EMPLOYEE_ID=100;
        return l_sal;
    end f;
end;

begin
    dbms_output.put_line(pkg2.f);
end;

alter table emp_copy drop column SALARY;
ALter table emp_copy add salary number(20);

select *
from user_objects
where object_name='PKG2';



create or replace package pkg is
    n number := 5;
end pkg;
/
create or replace package sr_pkg is
    pragma serially_reusable;
    n number := 5;
end sr_pkg;
/
begin
    pkg.n := 10;
    sr_pkg.n := 10;
end;
/
begin
    sr_pkg.n:=20;
    dbms_output.put_line('pkg.n: ' || pkg.n);
    dbms_output.put_line('sr_pkg.n: ' || sr_pkg.n);
end;


declare
    number_of_days_between_march_and_april number;
    printer_name# number;
    leap$year number;
    v_fname number;
 
begin
    dbms_output.put_line(length('number_of_days_between_march_and_april'));
end;

/

declare
    l_var varchar2(200);
begin
        l_var:= htp.DIRLISTOPEN();
--     dbms_output.put_line(htp.DIRLISTOPEN());
end;


declare
    v_price number:=1000;
    v_pdt_name varchar2(15);
begin
    select LAST_NAME into v_pdt_name
    from employees
        where salary=26400
        and first_name='steven';



    dbms_output.put_line(sql%rowcount);
end;

alter session set plsql_warnings='ENABLE:ALL';


create or replace procedure proc1 is
    cursor c(sal in out number) is select *
                                   from employees
                                   where salary > sal;
    emp_rec c%rowtype;
    l_var   number := 0;
begin
    open c(l_var);
    loop
        exit when c%notfound;
        fetch c into emp_rec;
        dbms_output.put_line(emp_rec.first_name);
    end loop;
end;


alter table log1 modify id number(2);

select *
from log1;


truncate table log1;


begin
    insert into log1 values(employees_seq.nextval);
    insert into log1 values(employees_seq.nextval);
    insert into log1 values(employees_seq.nextval);
    insert into log1 values(employees_seq.nextval);
    insert into log1 values(employees_seq.nextval);
    insert into log1 values(employees_seq.nextval);
    insert into log1 values(employees_seq.nextval);
    insert into log1 values(employees_seq.nextval);
    insert into log1 values(employees_seq.nextval);
    insert into log1 values(200);
--     raise zero_divide;
exception
    when others then
    dbms_output.put_line(sqlerrm);
end;


select *
from log1;

begin
    insert into log1 (id) values (employees_seq.nextval);
    insert into log1 (id, name) values (employees_seq.nextval);
end;



declare
    function f return number is
        pragma autonomous_transaction;
    begin
        return 20;
    end;
begin
    null;
end;



create or replace function f return number is
    pragma autonomous_transaction;
    begin
        declare
            pragma autonomous_transaction;
        begin
               null;
--             commit;
        end;
        return 20;
    end;



begin
    dbms_output.put_line(f);
end;


create or replace function f return number is 
    function rs return number is
        pragma autonomous_transaction;
        
        function rs2 return number is 
            pragma autonomous_transaction;
        begin
            return 21;
        end;
    begin
        return 69;
    end;
begin
    null;
    return 32;
end;




begin
    dbms_output.put_line(f);
end;



create or replace package pkg2 accessible by(package pkg1.test)
is
function f return number;
end pkg2;

create or replace package body pkg2 is
    function f return number is
    begin
        return 200;
    end;
end;


create or replace package pkg1
is
    procedure test;
end pkg1;


create or replace package body pkg1 is
    procedure test is
        begin
            dbms_output.put_line('in pkg1 in test');
            dbms_output.put_line(pkg2.f);
        end;
end pkg1;

begin
    dbms_output.put_line(pkg2.f);
end;

begin
    pkg1.test;
end;




create or replace function test1(shit in number) return number is
begin
    return shit*4.5;
end;

create or replace procedure proc1(p1 number default test1(1000))
is
begin
    dbms_output.put_line(p1);
end;

begin
    proc1;
end;

drop function testfunc;
create or replace function testfunc(p1 in number) return number
is 
    begin
        return 2*p1;
    end;

create or replace procedure proc1(testfunc(p2)in number) is
begin
    dbms_output.put_line(p2*20);
end;
    
begin
    dbms_output.put_line(testfunc(20));
end;



create or replace procedure proc1 accessible by (procedure proc_in_pkg)
is
begin
    dbms_output.put_line('proc1');
end;


create or replace package pkg is
procedure proc_in_pkg;
end pkg;

create or replace package body pkg is
procedure proc_in_pkg is
    begin
        proc1;
    end;
end pkg;



create or replace trigger testtrigger
    after ddl
    on schema
begin
    dbms_output.put_line('trigger');
end;



truncate table emp_copy;


drop table test_table;
create table test_table(
    id number(2)
);

insert into test_table (id)
values (22.22);

insert into test_table (id)
values (222);


select *
    from test_table;



declare
    a number(2):=22.22;

begin
    null;
end;


drop trigger testtrigger;


create or replace trigger testtrigger
before truncate on hr.schema 
begin
    dbms_output.put_line('truncate');
end;



truncate table emp_copy;



begin
    execute immediate ' begin
                            update emp_copy set first_name=:x;
                            dbms_output.put_line(sql%rowcount);
                            commit;
                        end;'
        using 'test123';
    dbms_output.put_line(sql%rowcount);
end;


begin
    update emp_copy set salary = 10;
    dbms_output.put_line(sql%rowcount);
end;


create table emp_copy
as select *
from employees;


select *
from emp_copy;


create or replace procedure proc1(p1 in number, p2 out number) is
    begin
        dbms_output.put_line('test');
    end;

create or replace package pkg1 is
function f return number;
end pkg1;


create or replace package body pkg1 is
function f return number is
begin
    return 21;
end f;

function helper return number is
begin
    return 69;
end helper;
end pkg1;



select *
from emp_copy;


drop table emp_copy;
create table emp_copy
as select *
    from employees;

declare
    type numlist is table of number;
    depts numlist := numlist(10, 20, 30);

    type enum_t is table of employees.employee_id%type;
    e_ids enum_t;

    type dept_t is table of employees.department_id%type;
    d_ids dept_t;

begin

    for j in depts.first..depts.last loop
        delete from emp_copy where department_id=depts(j)
        returning EMPLOYEE_ID bulk collect into e_ids;
        end loop;
    
    dbms_output.put_line(e_ids.count);
    
    
    for i in e_ids.first..e_ids.last loop
        dbms_output.put_line(e_ids(i));
        end loop;
end;



select EMPLOYEE_ID from employees
where department_id=30;


select *
from user_plsql_object_settings;



select *
from user_identifiers;