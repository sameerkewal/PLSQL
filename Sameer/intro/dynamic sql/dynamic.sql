
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



--met een function dat fifty zal returnen
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


--We kunnen dus ook een function maken dat een value neemt en
--dan zouden we die using in clause kunnen gebruiken
drop function returnNumber;
create or replace procedure returnNumber(p1 out number, p2 out number)
is
begin
    p1 := 20;
    p2 := 99;
end;

declare
    dyn_stmt varchar2(4000);
    l_ret    number;
    l_in     number;
begin
    dyn_stmt := 'begin returnNumber(:x, :z); end;';
    execute immediate dyn_stmt using out l_ret, l_in;
end;


declare
    l1 number;
    l2 number;
begin
    returnNumber(l1, l2);
    dbms_output.put_line(l1 || ' ' || l2);
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


