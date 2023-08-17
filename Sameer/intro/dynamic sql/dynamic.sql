
--execute immediate example
create or replace procedure test(test in number) is
begin
    dbms_output.put_line(test);
end;

declare
    l_statement varchar2(4000):='begin test(:x); end;';
begin
    execute immediate l_statement using 4;
end;


declare
    v_employee_id number:=100;
    v_new_salary number:=40;

    v_sql varchar2(100);
begin
    v_sql:= 'update emp_copy set salary = salary* 1.1 where employee_id=:1 returning salary into :2';

    execute immediate v_sql using v_employee_id returning into v_new_salary;
     DBMS_OUTPUT.PUT_LINE('Updated salary: ' || v_new_salary);
end;


--Met een select dat 1 value returned ofzo
declare
    v_firstname employees.first_name%type;
    v_sql varchar2(200):='select first_name from employees where employee_id=100';
begin
    execute immediate v_sql into v_firstname;
    dbms_output.put_line(v_firstname);
end;






----------DBMS_SQL.RETURN_RESULT
create or replace procedure p authid definer as
    c1 sys_refcursor;
    c2 sys_refcursor;
begin
    open c1 for
        select first_name, last_name
        from employees
        where employee_id > 176;
    dbms_sql.return_result(c1, false);

    -- Now p cannot access the result.
    /*open c2 for
        select city, state_province
        from locations
        where country_id = 'AU';
    dbms_sql.return_result(c2, false);*/
    -- Now p cannot access the result.
END;
/
BEGIN
 p;
END;
/
create or replace type vc_array is table of varchar2(200);
create or replace type numlist is table of number;

create or replace procedure do_query_1(
    placeholder vc_array,
    bindvars vc_array,
    sql_stmt varchar2
) is
    type curtype is ref cursor;
    src_cur   curtype;
    curid     number;
    bindnames vc_array;
    empnos    numlist;
    depts     numlist;
    ret       number;
    isopen    boolean;
begin
    curid := dbms_sql.open_cursor;

    dbms_sql.parse(curid, sql_stmt, dbms_sql.native);

    bindnames := placeholder;

    for i in 1..bindnames.count
        loop
            dbms_sql.bind_variable(curid, bindnames(i), bindvars(i));
        end loop;

    ret:=dbms_sql.EXECUTE(curid);

    src_cur:=dbms_sql.TO_REFCURSOR(curid);

    fetch src_cur bulk collect into empnos, depts;
end;


