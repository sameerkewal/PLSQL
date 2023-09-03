--Q 1:

declare
    type test is table of number;
    l_test1 test:=test();
begin
    l_test1.extend(100);
    dbms_output.put_line(l_test1.next(20));
end;



--Q 12:
create package pkg1 accessible by (pkg2) is
    procedure proc1a;
end pkg1;

create package body pkg1 is
    procedure proc1a is
    begin
        dbms_output.put_line('proc1');
    end;
    procedure prc1b is
    begin
        proc1a;
    end;
end pkg1;

create package pkg2 is
    procedure proc2;
    procedure proc3;
end;

create package body pkg2 is
    procedure proc2 is
    begin
        pkg1.proc1a;
    end;
    procedure proc3 is
    begin
        pkg2.proc2;
    end;
end;


create procedure my_proc is
begin
    pkg1.proc1a;
end;


--Q 17:
CREATE TYPE numlist IS TABLE OF NUMBER;
/
create procedure list_sal(dept_id number)
    is
    sql_stmt varchar2(200);
    ret      integer;
    empids   numlist;
    sal      numlist;
begin
    curid := dbms_sql.open_cursor;
    sql_stmt := 'select employee_id, salary from employees where department_id = :al';
    dbms_sql.parse(curid, sql_stmt, dbms_sql.native);
    dbms_sql.bind_variable(curid, 'al', 'dept_id');
    ret := dbms_sql.execute(curid);
    fetch src_cur bulk collect into empids, sal;
    if empids.count > 0 then
        for i in 1.. empids.count
            loop
                dbms_output.put_line(empids(i) || ' '  || sal(i));
            end loop;
    end if;
    close src_cur;
end;


--Q 35:
declare
    type t_rec is record
                  (
                      v_sal       number(8),
                      v_minsal    number(8) default 1000,
                      v_hire_date employees.hire_date%type,
                      v_rec1      employees%rowtype
                  );
    v_myrec t_rec;
begin
    v_myrec.v_sal := v_myrec.v_minsal + 500;
    v_myrec.v_hire_date := sysdate;
    select *
    into v_myrec.v_rec1
    from employee
    where employee_id = 100;
    dbms_output.put_line(v_myrec.v_rec1.last_name ||   || to_char(v_myrec.v_hire_date) ||   ||
                         to_char(v_myrec.v_sal));
end;


--Q 41
drop trigger testtrigger;
create or replace trigger testtrigger before update on emp_copy
begin
    commit;
end;

update emp_copy
set first_name = 'sam'
where employee_id=100;
