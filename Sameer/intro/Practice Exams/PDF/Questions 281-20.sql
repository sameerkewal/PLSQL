--Q 287:
declare
    sal_too_high exception;
    pragma exception_init (sal_too_high, -20001);
begin
--     raise no_data_found;
    raise sal_too_high;
    raise_application_error(-20001, 'test');
end;






--Q 290
--No bulk collect into with a record variable
declare
    type r is record(fname employees.first_name%type, lname employees.last_name%type);
    emp_rec r;
begin
    select FIRST_NAME into emp_rec from employees
    where employee_id=110;
end;

create or replace procedure proc1 is
    type rec_type is table of number index by pls_integer;
    l_var rec_type;


begin
    l_var(10):= 100;
    l_var(20):= 200;
    select * into l_var2 from table (l_var);
end;

CREATE OR REPLACE TYPE numbers_type IS
 TABLE OF INTEGER;

--You can iterate over a collection maar die collection moet niet locally declared zijn.
-- Het moet op schema level, tenzij het een associative array is denk ik
create or replace procedure proc1 is

numbers1 numbers_type := numbers_type(1,2,3,4,5);

CURSOR c IS
 SELECT a.COLUMN_VALUE
 FROM TABLE(numbers1) a;

l_var number;

begin
    open c;
    fetch c into l_var;
    fetch c into l_var;
    dbms_output.put_line(l_var);
    close c;
end;

--Idk if possible to just loop over normal associative array
declare
    type t is table of pls_integer index by pls_integer;
    l_var t;
    l_var2 pls_integer;
    c1 sys_refcursor;

begin
    l_var(10):=100;
    l_var(20):=200;
    open  c1  for select a.column_value from table(l_var) a;

--     open c;
--     fetch c into l_var2;
--     close c;
end;

begin
    proc1;
end;


--But looping over an associative array with records is defo possible
create or replace package type_pkg is
    type rec is record(f1 number, f2 varchar2(30));
    type mytab is table of rec index by pls_integer;
end type_pkg;


declare
    l_var type_pkg.mytab;
    l_rec type_pkg.rec;

    l_f1 number;
    l_f2 varchar2(30);

    c1 sys_refcursor;
begin
    l_var(10):=type_pkg.rec(f2 => '100', f1=>1000);
    l_var(20):=type_pkg.rec(f2 => '200', f1=>2000);

    open c1 for select * from table(l_var);
    fetch c1 into l_rec;
    dbms_output.put_line(l_rec.f2);
end;




create or replace package pkg authid definer as
    type rec is record (f1 number, f2 varchar2(30));
    type mytab is table of rec index by pls_integer;
end;
declare
    v1 pkg.mytab; -- collection of records
    v2 pkg.rec;
    c1 sys_refcursor;
begin
    v1(1).f1 := 1;
    v1(1).f2 := 'one';
    open c1 for select * from table (v1);
    fetch c1 into v2;
    close c1;
    dbms_output.put_line('Values in record are ' || v2.f1 || ' and ' || v2.f2);
end;


create or replace package pkg is
    type rec_typ is record(pdt_id integer, pdt_name varchar2(30));
    type tab_typ is table of rec_typ index by pls_integer;
    x tab_typ;
end pkg;




create or replace function p4(y pkg.tab_typ) return pkg.tab_typ is
begin
   EXECUTE IMMEDIATE 'SELECT pdt_id, pdt_name FROM TABLE (:b)' BULK COLLECT INTO pkg.x USING y;
    return pkg.x;
end;

declare
    l_var pkg.tab_typ;
    l_copy pkg.tab_typ;
begin
    l_var(10):=pkg.rec_typ(pdt_id => 10, pdt_name => 'sameer');

    dbms_output.put_line(p4(l_var)(1).pdt_name);

end;


create or replace procedure p5(y pkg.tab_typ)is
    l_var pkg.rec_typ;
    l_var2 pkg.rec_typ;
begin
    execute immediate 'select pdt_name from table(:b)' bulk collect into pkg.x using y;
end;

declare
l_var pkg.tab_typ;
l_copy pkg.tab_typ;
begin
    l_var(10):=pkg.rec_typ(pdt_id => 10, pdt_name => 'sameer');
    p5(l_var);
end;


create or replace procedure p5(y pkg.rec_typ) is
y_copy pkg.rec_typ;
begin
    execute immediate 'select pdt_id, pdt_name from table(:b)' into y_copy using pkg.x;
    
    dbms_output.put_line(y_copy.pdt_name);
end;

declare
 y pkg.rec_typ;
begin
    pkg.x(10):=pkg.rec_typ(pdt_id => 100, pdt_name => 'sameer');
--     pkg.x(20):=pkg.rec_typ(pdt_id => 200, pdt_name => 'jas');
    p5(y);

    dbms_output.put_line(pkg.x.count);
end;


--Q 295:
select *
    from user_objects
        where object_name='P1';

select *
    from user_procedures
        where object_name='API';

select *
    from user_dependencies
        where name='API';

create or replace package pkg_test is
procedure proc1;
procedure proc2;
end pkg_test;


create or replace package body pkg_test is
    procedure proc1 is
    begin
        dbms_output.put_line('wha');
    end;

    procedure proc2 is
        begin
            null;
        end;
end pkg_test;

select *
    from user_dependencies
        where name='PKG_TEST';


--Q 297:
declare
    type tab_type is table of number;
    my_tab tab_type;
begin
    my_tab(1):=1;
end;

declare
    type tab_type is table of number;
    my_tab tab_type:=tab_type(2);
begin
    my_tab(1):=55;

    dbms_output.put_line(my_tab.count);
end;

declare
    type tab_type is table of number;
    my_tab tab_type;
begin
    my_tab.extend(2);
end;


declare
    type tab_type is table of number;
    my_tab tab_type;
begin
    my_tab:=tab_type();
    my_tab(1):=55;
end;

declare
    type tab_type is table of number;
    my_tab tab_type := tab_type (2, NULL, 50);
begin
    my_tab.extend(3, 2);
    for i in my_tab.first..my_tab.last loop
        dbms_output.put_line(nvl(to_char(my_tab(i)), 'null'));
        end loop;
end;


--Question 301

--C:
declare
    type emp_info is record(emp_id number(3), expr_summary clob);
    type emp_typ is table of emp_info;

    l_emp emp_typ;
    l_rec emp_info;
begin
    l_rec.emp_id:=1;
    l_rec.expr_summary:=empty_clob();

    l_emp:=emp_typ(l_rec);

    dbms_output.put_line(l_emp(1).expr_summary);

    if l_emp(1).expr_summary is null then
        dbms_output.put_line('Summary is null');
    end if;
end;

--D
declare
    type emp_info is record(emp_id number(3), expr_summary clob);
    type emp_typ is table of emp_info;

    l_emp emp_typ;
    l_rec emp_info;
begin
    l_rec.emp_id:=1;
   
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_emp.exists(1)));

    if not l_emp.exists(1) then
        dbms_output.put_line('Summary is null');
    end if;
end;






create or replace package pkg as
type rec is record(f1 number, f2 varchar2(20));

type mytab is table of rec index by pls_integer;
end;

create or replace package pkg as
type rec is record(f1 number, f2 varchar2(30));
type mytab is table of rec index by pls_integer;
end;

declare
    v1 pkg.mytab;
    v2 ;
    c1 sys_refcursor;




begin
    for i in 100..200 loop
        select EMPLOYEE_ID, LAST_NAME into v1(i)
        from employees
        where employee_id=i;
        end loop;


    open c1 for select * from table(v1);
    loop
        fetch c1 into v3;
        exit when c1%notfound;
        dbms_output.put_line('Employee ID: ' || v3.employee_id || ', Last Name: ' || v3.last_name);
    end loop;
end;


--Q 302:
declare
    type emp_info is record(empid number(3), expr_summary clob);
    type emp_typ is table of emp_info;
    l_emp emp_typ;
    l_rec emp_info;
begin
    l_emp:=emp_typ();
    l_emp.extend;

    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_emp.exists(1)));
    
    if not l_emp.exists(1) then
        dbms_output.put_line('summary is null');
    end if;
    
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_emp.exists(1)));
    
end;


--Q 304:
create or replace package pkg is
    type rec is record(f1 number, f2 varchar2(20));
    type mytab is table of rec index by pls_integer;
end;

declare
    v1 pkg.mytab;
    v2 pkg.rec;
    c1 sys_refcursor;

begin
    for i in 100..200 loop
        select EMPLOYEE_ID, LAST_NAME into v1(i)
        from employees where employee_id = i;
        end loop;
    open c1 for select * from table(v1);
    fetch c1 into v2;
    close c1;
end;



--Q 308



alter PROCEDURE proc1 compile plscope_settings='IDENTIFIERS:ALL';



--Q 310
CREATE OR REPLACE TYPE num_varray_t AS VARRAY (20) OF NUMBER;


CREATE TABLE tab_use_va_col( ID NUMBER, NUMBERS num_varray_t);



--Q 314
declare
    type nt is table of number;

    a nt not null:=nt(10, 20, 30);
    b a%type:=nt(20, 30, 40);
begin
    null;
end;


--Q 318
declare
    type rec is record(a number, b varchar2(20));
  emp_rec emp_details_view%rowtype;
  uhm rec%rowtype;
begin
    null;
end;


--Q 319
declare
    type t is table of pls_integer index by pls_integer;
    l_var t;    
begin
    l_var(10):=100;
    l_var(20):=200;
    
    dbms_output.put_line(l_var(30));
end;

declare
    type test is table of number;
    l_test1 test:=test(10,20,39);
 
begin
--     l_test1.extend;
    dbms_output.put_line(l_test1(3.5));
end;


declare
    type test is varray(20) of number;
    l_test1 test:=test(10, 20 , 30);
begin
    dbms_output.put_line(l_test1(21));
end;

--Q 320
begin
    dbms_output.put_line(dbms_assert.ENQUOTE_LITERAL('test'));
end;



--Q 322:

create or replace procedure procTest is
begin
    dbms_output.put_line(1+1+10);
end;

create or replace trigger triggerTest after update or delete on emp_copy
begin
    PROCTEST();
end;

delete from emp_copy
where employee_id=101;

select *
from emp_copy;





--q1:
--optie C
--Nee dit is geen implicit cursor still an explicit cursor

declare

    cursor cursor3 is select * from employees;
begin
    for i in cursor3 loop
        dbms_output.put_line(i.first_name);
        end loop;
end;

--er bestaat wel een implicit cursor for loop tho
begin
    for item in (select * from employees) loop
        dbms_output.put_line(item.first_name);
        end loop;
end;



--Q 20:

