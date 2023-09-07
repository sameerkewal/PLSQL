--Q 1:
declare
    type emprectyp is record
                      (
                          emp_name varchar2(30),
                          salary   number(8, 2)
                      );
    function highest_salary return emprectype is
        emp_info emprectyp;
        cursor cur_emp_cursor is
            select ename, sal
            from emp
            where sal = (select max(sal) from emp);
    begin
        for emp_info in cur_emp_cursor
            loop
                return emp_info;
            end loop;
    end highest_salary;
begin
    dbms_output.put_line('emp: ' || highest_salary().emp_name || ' earns the highest salary of ' ||
                         highest_salary().salary);
end;


--Q 2:
create package pkg is
    type rec_typ is record (pdt_id integer, pdt_name varchar2(25));
    type tab_typ is table of rec_typ index by pls_integer;
    x tab_typ;
end pkg;
/
create function f(x pkg.tab_typ) return varchar2 is
    r varchar2(100);
begin
    for i in 1.. x.count
        loop
            r := r || '' || x(i).pdt_id || x(i).pdt_name;
        end loop;
    return r;
end f;


--Q 5:
-- Deterministic isn't shared across sessions
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/RESULT_CACHE_MAX_RESULT.html#GUID-C7E6D932-B35C-4E37-826A-14906921B71B
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/RESULT_CACHE_MAX_SIZE.html#GUID-2D9F6563-C890-43BC-8EC0-1C372402F3A5


--Q 6:
create or replace package yearly_list is
    type list1 is table of varchar2(20) index by pls_integer;
    function init_list1 return list1;
end yearly_list;

create or replace package body yearly_list is
    function init_list1 return list1 is
        create_list list1;
    begin
        create_list(1) := 'jan';
        create_list(3) := 'feb';
        create_list(6) := 'mar';
        create_list(8) := 'apr';
        return create_list;
    end init_list1;
end yearly_list;
Examine this code:
declare
    v_yrl    yearly_list.create_list();
    location number := 1;
begin
    while location is not null
        loop
            dbms_output.put_line(v_yrl(location));
            location := v_yrl.next;
        end loop;
end;
/


--Q 12:
create procedure my_new_proc authid current_user as
    pragma autonomous_transaction;
begin
    execute immediate 'grant dba to ora1';
    commit;
exception
    when others then null;
end;
/
create function return_date(param1 in number) return date authid current_user as
begin
    my_new_proc;
    return sysdate + param1;
end;


--Q 14:
declare
    type test is table of number;
    l_test1 test:=test();
begin
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_test1.exists(1)));
end;

--Q 15:
create or replace package pkg as
    type tab_typ is table of varchar2(10) index by varchar2(100);
    function tab_end(p_tab in tab_typ) return tab_typ;
end pkg;
/
create or replace package body pkg as
    function tab_end(p_tab in tab_typ) return tab_typ is
    begin
        return p_tab.last;
    end tab_end;
end pgk;
/
declare
    l_stmt   varchar2(100);
    l_list   pgk_tab_typ;
    l_result varchar2(10);
begin
    l_list(1) := 'monday';
    l_list(2) := 'tuesday';
    l_stmt := 'select pkg.tab_end(:l_list) into :l_result from dual';
    execute immediate l_stmt into l_result using l_list;
end;



CREATE or replace package pkg as
type tab_typ is table of varchar2(10) index by PLS_INTEGER;
function tab_end (p_tab in tab_typ) return varchar2;
end pkg;
/

create or replace package body pkg as
    function tab_end(p_tab in tab_typ) return varchar2 is
    begin
        return p_tab.last;
    end;
end pkg;
/

declare
    l_stmt   varchar2(100);
    l_list   pkg.tab_typ;
    l_result varchar2(10);
begin
    l_list(1) := 'Mon';
    l_list(2) := 'Tue';
    l_stmt := 'SELECT pkg.tab_end(:l_list) into :i_result from dual';
    execute immediate l_stmt into l_result using l_list;
    dbms_output.put_line(l_result);
end;


--Q 16:
CREATE PACKAGE pkg AS
TYPE tab_typ IS TABLE OF VARCHAR2(10) INDEX BY VARCHAR2;
FUNCTION tab_end(p_tab IN tab_typ) RETURN tab_typ;
END pkg;
/
CREATE PACKAGE BODY pkg AS
FUNCTION tab_end(p_tab IN tab_typ) RETURN tab_typ IS
BEGIN
RETURN p_tab.LAST;
END;
END pgk;
/
DECLARE
l_stmt VARCHAR2(100);
l_list pgk_tab_typ;
l_result VARCHAR2(10);
BEGIN
l_list(1) := MONDAY;
l_list(2) := TUESDAY;
l_stmt := SELECT pkg.tab_end(:l_list) INTO :l_result FROM dual;
EXECUTE IMMEDIATE l_stmt INTO l_result USING l_list;
END;


--Q 16:
create package pkg authid current_user as
    type rec is record (f1 number, f2 varchar2(20));
    type mytab is table of rec index by pls_integer;
end;
/
declare
    v1 pkg.mytab;
    v2 pkg.mytab;
    c1 sys_refcursor;
begin
    for i in 100..200
        loop
            select employee_id, last_name
            into v1(i)
            from employees
            where employee_id = i;
        end loop;
    open c1 for select * from table (v1);
    fetch c1 into v2;
    close c1;
end;


--Q 17:
declare
    v_cur      number;
    v_ret      number;
    v_ref_cur  sys_refcursor;
    type prod_tab is table of products.prod_id%type;
    v_prod_tab prod_tab;
begin
    v_cur := dbms_sql.open_cursor;
    dbms_sql.parse(v_cur, 'select prod_id from products', dbms_sql.native);
    v_ret := dbms_sql.execute(v_cur);
    fetch v_ref_cur bulk collect into v_prod_tab;
    dbms_output.put_line('no of products is : ' || v_prod_tab.COUNTS);
    close v_ref_cur;
end;



--Q 19:

declare
    type dept_cur is ref cursor return departments%rowtype;
    cv1         dept_cur;
    v_dept_name departments.department_name%type;
begin
    open cv1 for select * from departments where department_id = 10;
    fetch cv1.department_name into v_dept_name;
    dbms_output.put_line(v_dept_name);
    close cv1;
end;