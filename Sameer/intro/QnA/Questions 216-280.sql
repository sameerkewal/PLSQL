
--Q 217

begin
    delete from emp_copy
        where employee_id=10000;

    update emp_copy set employee_id = 1000000 where
                                                  employee_id=1000000;
end;

--------Q 220


declare
    past_due exception;
--     pragma exception_init (past_due, -20000);
    acct_num number;
begin
    declare
        past_due exception;
        pragma exception_init (past_due, -20000);
        acct_num    number;
        due_date    date := sysdate-1;
        todays_date date := sysdate;
    begin
    if due_date < todays_date then
        raise past_due;
    end if;
 end;
exception
    when past_due then
        dbms_output.put_line('Handling PAST DUE exception.');
    when others then
        dbms_output.put_line('Could not recognize exception');
        dbms_output.put_line(sqlerrm);
end;


declare
    l_var varchar2(20):='true';
    l_boolean boolean:=false;
begin
    l_var:=l_boolean;
end;



--Q 230
declare
    type genericcurtype is ref cursor;
    weak_cursor_var genericcurtype;

    type emp_cur is ref cursor return employees%rowtype;
    type dep_cur is ref cursor return departments%rowtype;
    cursor1         emp_cur;
    cursor2         dep_cur;
    emp_rec         employees%rowtype;
    dep_rec         departments%rowtype;
begin
    cursor1 := weak_cursor_var;
--     cursor2:=cursor1;
    open cursor1 for select * from employees;
    fetch cursor1 into emp_rec;
    dbms_output.put_line(emp_rec.first_name);
end;




declare
    type employeescur_t is ref cursor return employees%rowtype;
    type teachercur_t is ref cursor;
    cursor1 employeescur_t;
    cursor2 teachercur_t;
    cursor3 sys_refcursor;
    cursor stcur is select * from employees;
begin
    open cursor3 for select * from employees;
    cursor1:=cursor3;

/*    open stcur;
    cursor1:=stcur;*/

    /*open cursor1 for select * from employees;
    stcur:=cursor1;
*//*
    open stcur;
    cursor3:=stcur;*/

    open cursor1 for select * from employees;
    cursor2:=cursor1;
end;


--Q 233
create or replace package pkg as
    type rec_typ is record(price number, inc_pct number);
        procedure calc_price(price_rec in out rec_typ);
end pkg;

create or replace package body pkg as
    procedure calc_price(price_rec in out rec_typ) as
    begin
        price_rec.price:=price_rec.price+(price_rec.price*price_rec.inc_pct)/100;
    end calc_price;
end pkg;

--A
declare
    l_rec pkg.rec_typ;
begin
    l_rec.price:=100;
    l_rec.inc_pct:=50;

    execute immediate 'begin pkg.calc_price(:rec); end;' using in out l_rec;
end;

--B
declare
    l_rec pkg.rec_typ;
begin
    l_rec.price:=100;
    l_rec.inc_pct:=50;

    execute immediate 'begin pkg.calc_price(:rec); end;' using in out l_rec(100, 50);
end;

--D
declare
    type rec_type is record (price number, inc_pct number);
    l_rec rec_type;

    procedure calc_price(price_rec in out rec_type) as
    begin
        price_rec.price := price_rec.price + (price_rec.price * price_rec.inc_pct) / 100;
    end;
begin
    l_rec.price:=100;
    l_rec.inc_pct:=50;

    execute immediate 'begin pkg.calc_price(:rec); end;' using in out l_rec;
end;



--Q 234:

declare
    type va$ is varray(200) of number;
    va va$  := va$();
begin
    va.extend(100);

    dbms_output.put_line('limit: ' || va.limit);
    dbms_output.put_line('count: ' || va.count);
    dbms_output.put_line('va.last: ' || va.last);
    dbms_output.put_line('va.next(199): ' || va.next(199));

   /* if va(100) is null then
        dbms_output.put_line('va(1000) is null');
    end if;*/
end;





--Q 238
declare
    type l_name_type is varray(25) of employees.last_name%type;
    names l_name_type := l_name_type();
begin
    names(1):='sam';
end;



-- Q 247:
declare
    type list_typ is table of number index by pls_integer;
    l_list list_typ;
    l_index number;
begin
    l_list(1):=10;
    l_list(2):=20;
    l_list(3):=30;

    for l_index in l_list.first..l_list.last loop
        dbms_output.put_line(l_list(l_index));
        end loop;
end;






--Q 248:
begin
    dbms_output.put_line(dbms_assert.SQL_OBJECT_NAME('EMPLOYEES', 'DEPARTMENTS'));
end;



create or replace procedure gt_tab_row_count(p_table_name in varchar2) as
    l_sql   varchar2(200);
    l_count number;
begin

l_sql := 'SELECT COUNT(*) FROM ' || DBMS_ASSERT.SQL_OBJECT_NAME (p_table_name);
execute immediate l_sql into l_count;
DBMS_OUTPUT.PUT_LINE('l_count = ' || l_count);
end;



begin
    gt_tab_row_count('employees');
--     gt_tab_row_count('hr.employees');

    gt_tab_row_count('"employeess"');
--     gt_tab_row_count('employees, departments');
end;



-- Q 250:
create or replace procedure list_sal(dept_id number) is
    sql_stmt    varchar2(200);
    ret         integer;
    empids      numlist;
    sal         numlist;
    curid       number;
    src_cur sys_refcursor;
begin
    curid := dbms_sql.open_cursor;
    sql_stmt := 'select employee_id, salary from employees where department_id = :id';
    dbms_sql.parse(curid, sql_stmt, dbms_sql.native);
    dbms_sql.bind_variable(curid, 'id', 'dept_id');
    ret := dbms_sql.execute(curid);
    src_cur := dbms_sql.to_refcursor(curid);
    fetch src_cur bulk collect into empids, sal;
    if empids.count > 0 then
        for i in 1..empids.count
            loop
                dbms_output.put_line(empids(i) || ' ' || sal(i));
            end loop;
    end if;
    close src_cur;
end;



-- q255:
begin
    dbms_output.put_line(dbms_assert.ENQUOTE_NAME('"test"', TRUE));
end;

begin
    dbms_output.put_line(dbms_assert.ENQUOTE_NAME(
        '"this is a "test" message"'));
end;

begin
    dbms_output.put_line(dbms_assert.ENQUOTE_NAME(
        'this is a "test" message'));
end;

begin
    dbms_output.put_line(dbms_assert.ENQUOTE_NAME(
        '"this is a "test" message"'));
end;



-- Q 259:
create or replace trigger testTrigger
before insert on hr.schema
begin
    dbms_output.put_line('yeee');
end;

create or replace trigger testTrigger
after insert on t
begin
    dbms_output.put_line('yeee');
end;
select *
from t;

insert into t
values (2);



--Q 261:
create table orders(
    order_id number(12),
    order_total number(8,2)
);

declare
    v_order_id orders.order_id%type;
    v_order_total constant orders.order_total%type:=41000;
    v_all_order_total v_order_total%type;
begin
    v_order_id:=null;
    dbms_output.put_line('Order total is: ' || v_order_total);
end;



-- Q 262:
drop table emp_copy;

create table emp_copy as select * from employees;

drop table log;
create table log(
    id number generated by default on null as identity,
    user_name varchar2(20)
);

create or replace trigger testTrigger
after delete on emp_copy
declare
    pragma autonomous_transaction;
    l_number number;
begin
    insert into log (user_name) values ('HR');
    commit;
end;


delete from emp_copy
where employee_id=999;


--Q 270:
create or replace view emp_vw as
select employee_id, first_name, last_name, email, phone_number, hire_date,  salary, commission_pct, manager_id, department_id, job_title, min_salary, max_salary
from emp_copy emp join hr.jobs j on j.job_id = emp.job_id;

create or replace trigger instoftrigger
instead of delete on emp_vw for each row
begin
    insert into log (user_name) values ('HR');
end;

select * from log;

delete from emp_vw where employee_id=140;


-- Q 274:
drop table emp_temp;
create table emp_temp
(
    deptno number(2),
    job    varchar2(18)
);

declare
    type numlist is table of number;
    depts numlist := numlist(10, 20, 30);
begin
    insert into emp_temp values (10, 'clerk');
    insert into emp_temp values (20, 'bookkeeper');
    insert into emp_temp values (30, 'analyst');

    forall j in depts.first..depts.last
        update emp_temp
        set job=job ||' (senior)'
        where deptno = depts(j);
/*
exception
    when others then
        dbms_output.put_line('problem in the forall statement');
        commit;
*/
end;

select *
from emp_temp;



--Q 274:
declare
--     v_job_type varchar2 := ' Temp';
    c_tax_rate constant number(2):=8.25;
begin
   dbms_output.put_line(c_tax_rate);
end;
