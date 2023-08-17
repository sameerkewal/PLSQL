declare
    type empcurtype is ref cursor return employees%rowtype;
    type genericcurtype is ref cursor;

    cursor1 empcurtype; --strong cursor variable
    cursor2 genericcurtype; --weak cursor variable
    my_cursor sys_refcursor; --weak cursor variable

    type deptcurtyp is ref cursor return departments%rowtype; --strong type
    dept_cv deptcurtyp;

begin
    null;
end;

--EmpRecType is a user defined record type
declare
    type EmpRecType is record(
        employee_id number,
        last_name varchar2(25),
        salary number(8, 2)
                             );
    type EmpCurTyp is ref cursor return emprectype;
    emp_cv empcurtyp;
begin

end;



declare
    cv sys_refcursor; --weak cursor variable
    v_lastname employees.last_name%type;
    v_jobid employees.job_id%type;

    query_2 varchar2(200):= 'select * ' ||
                            'from employees ' ||
                            'where employee_id>0 ' ||
                            'order by job_id';

    v_employees employees%rowtype;

begin
    open cv for
        select LAST_NAME, JOB_ID from employees
        where job_id='IT_PROG';
    loop
        fetch cv into v_lastname, v_jobid;
        exit when cv%notfound;
        dbms_output.put_line( RPAD(v_lastname, 25, ' ') || v_jobid );
    end loop;


    dbms_output.put_line('--------------');

    open cv for query_2;

    loop
        fetch cv into v_employees;
        exit when cv%notfound;
        dbms_output.put_line(RPAD(v_employees.last_name, 25, ' ') ||
        v_employees.job_id);
    end loop;
    close cv;
end;


--fetching from cursor variable into a collection
--
declare
    type empcurtype is ref cursor; --weak cursor
    type namelist is table of employees.last_name%type;
    type sallist is table of employees.salary%type;

    emp_cv empcurtype;
    names namelist;
    sals sallist;
begin
    open emp_cv for
        select LAST_NAME, SALARY
            from emp_copy
                where job_id='IT_PROG' order by salary desc;
    fetch emp_cv bulk collect into names, sals;
    close emp_cv;

    for i in names.first..names.last loop
       DBMS_OUTPUT.PUT_LINE
         ('Name = ' || names(i) || ', salary = ' || sals(i));
        end loop;
end;

select user_name, sql_text
from v$open_cursor
where user_name='HR';


declare
    type empcurtype is ref cursor; --weak cursor
    type namelist is table of employees.last_name%type;
    type sallist is table of employees.salary%type;
    emp_cv empcurtype;
    emp_cv2 empcurtype;
    names namelist;
    sals sallist;

begin
    open emp_cv for
        select LAST_NAME, SALARY
            from emp_copy
                where job_id='IT_PROG' order by salary desc;
    fetch emp_cv bulk collect into names, sals;
--     close emp_cv;

    emp_cv2:=emp_cv;


    for i in names.first..names.last loop
       DBMS_OUTPUT.PUT_LINE
         ('Name = ' || names(i) || ', salary = ' || sals(i));
        end loop;
end;

------Variable in cursor query als string using bind variables
declare
    sal employees.salary%type;
    sal_multiple employees.salary%type;
    factor integer:=2;
    cv sys_refcursor;


    query varchar2(200):='select salary, salary*:factor from employees';

begin
    open cv for
        query using factor;
    loop
        fetch cv into sal, sal_multiple;
        exit when cv%notfound;
        dbms_output.put_line('factor: ' || factor);
        dbms_output.put_line('sal: ' || sal);
        DBMS_OUTPUT.PUT_LINE('sal_multiple = ' || sal_multiple);
    end loop;
end;





------------PAssing cursor variables as parameters

create or replace package emp_data as
    type empcurtype is ref cursor return employees%rowtype;
    emp_rec employees%rowtype;
    procedure open_emp_cv(emp_cv in out empcurtype);
end emp_data;


create or replace package body emp_data as
    procedure open_emp_cv(emp_cv in out empcurtype) is
    begin
        open emp_cv for select * from employees;
    end open_emp_cv;
end emp_data;

declare
    emp_cv emp_data.empcurtype;
    emp_rec employees%rowtype;
begin
    emp_data.open_emp_cv(emp_cv);
    loop
        fetch emp_cv into emp_rec;
        exit when emp_cv%notfound;
        dbms_output.put_line(emp_rec.last_name);
    end loop;
end;



/*Opening Cursor Variable for Chosen Query (Different Return Types)
In this example,the stored procedure opens its cursor variable parameter for a chosen query.
The queries have the different return types.*/
CREATE or replace package admin_data as
 type gencurtyp is ref cursor;
  procedure open_cv (generic_cv in out gencurtyp, choice int);
end admin_data;
/
create or replace package body admin_data as
    procedure open_cv(generic_cv in out gencurtyp, choice int) is
    begin
        if choice = 1 then
            open generic_cv for select * from employees;
        elsif choice = 2 then
            open generic_cv for select * from departments;
        elsif choice = 3 then
            open generic_cv for select * from jobs;
        end if;
    end;
end admin_data;



declare
    type genericcurtype is ref cursor;
    generic_cv genericcurtype;
    emp_rec employees%rowtype;
begin
    admin_data.OPEN_CV(generic_cv, 1); --als je iets anders passed
    loop                                                --dan moet je prepped zijn
        exit when generic_cv%notfound;                 --met een jobs%rowtype
        fetch generic_cv into emp_rec;
        dbms_output.put_line(emp_rec.first_name);
    end loop;
end;
/

--cursor expression

/*This example declares and defines an explicit cursor for a query that includes a cursor
expression. For each department in the departments table, the nested cursor returns
the last name of each employee in that department (which it retrieves from the
employees table).*/
declare
    type emp_cur_typ is ref cursor;
    emp_cur   emp_cur_typ;
    dept_name departments.department_name%type;
    emp_name  employees.last_name%type;
    cursor c1 is
        select department_name,
               cursor (select e.last_name
                       from employees e
                       where e.department_id = d.department_id
                       order by e.last_name) employees
        from departments d;
--         where department_name like 'A%'
--         order by department_name;
begin
    open c1;
    loop
        -- Process each row of query result set
        fetch c1 into dept_name, emp_cur;
        exit when c1%notfound;
        dbms_output.put_line('Department: ' || dept_name);
        loop
            -- Process each row of subquery result set
            fetch emp_cur into emp_name;
            exit when emp_cur%notfound;
            dbms_output.put_line('-- Employee: ' || emp_name);
        end loop;
    end loop;
    close c1;
end;


--------------For update cursor
--Rows worden gelocked wanneer je opened
--Rows are unlocked when you commit or rollback
--After the rows are unlocked, you cannot fetch from the FOR UPDATE cursor,
declare
    cursor c1 is select *
    from emp_copy for update;
    emp_rec employees%rowtype;
begin
    open c1;
    loop
        fetch c1 into emp_rec; --fails on second iteration, omdat die lock is released
        exit when c1%notfound;  --je zou die cursor dan opnieuw moeten openmaken
        dbms_output.put_line(emp_rec.last_name);
        update emp_copy set salary=salary*0.9;
        commit;
    end loop;
end;

--PL/SQL provides the WHERE CURRENT OF clause for both UPDATE and DELETE statements
-- inside a cursor in order to allow you to easily make changes to the most recently fetched
-- row of data
--voor current of ben je verplicht for update te gebruiken
DECLARE
   CURSOR c_emp IS SELECT employee_id, salary FROM emp_copy FOR UPDATE;
   v_raise NUMBER := 100;
BEGIN
   FOR r_emp IN c_emp LOOP
      UPDATE emp_copy SET salary = salary + v_raise WHERE CURRENT OF c_emp;
   END LOOP;
END;

--Simulating current of clause with rowid pseudocolumn
declare
    cursor c1 is
    select LAST_NAME, JOB_ID, rowid
        from emp_copy;

    my_lastname employees.last_name%type;
    my_jobid employees.job_id%type;
    my_rowid urowid;
begin
    open c1;
    loop
        fetch c1 into my_lastname, my_jobid, my_rowid;
        exit when c1%notfound;

        update emp_copy
        set salary = salary * 0.9
        where rowid=my_rowid;
        commit;
    end loop;
    close c1;
end;






