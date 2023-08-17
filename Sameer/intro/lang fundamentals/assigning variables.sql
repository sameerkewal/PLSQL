/*After declaring a variable, you can assign a value to it in these ways:
• Use the assignment statement to assign it the value of an expression.
• Use the SELECT INTO or FETCH statement to assign it a value from a table.
• Pass it to a subprogram as an OUT or IN OUT parameter, and then assign the value inside
the subprogram.*/


--select into:
<<test>>
declare
    l_into_test number;
begin
    select EMPLOYEE_ID into l_into_test
        from EMPLOYEES
            where FIRST_NAME='Steven' and LAST_NAME='King';
    DBMS_OUTPUT.PUT_LINE('voorbeeld van into clause: ' || l_into_test);
end test;
/

--fetch into
/*
In PL/SQL, you can use the fetch statement to retrieve rows of data from the result set of a multi-row query.
You need to declare and open an explicit cursor or use a cursor variable to associate the query with
the fetch statement. You also need to specify the variables or fields that will store the data from
the columns selected by the query.
For example, to fetch the first name and salary of an employee, you can use:
*/
declare
    cursor emp_cur is select FIRST_NAME, LAST_NAME
                      from EMPLOYEES;
    emp_rec emp_cur%rowtype;
begin
    open emp_cur;
    loop
        fetch emp_cur into emp_rec;
        DBMS_OUTPUT.PUT_LINE(
                    'The employee his full name is ' || emp_rec.FIRST_NAME || ' ' || emp_rec.LAST_NAME
            );
        exit when emp_cur%notfound;
    end loop;
    close emp_cur;
end;





--Passing to a subprogram as an out or in parameter
declare
    emp_salary EMPLOYEES.salary%type;
    procedure adjust_salary(
        emp number,
        sal in out number,
        adjustment number
    ) is
    begin
        sal := sal + adjustment;
    end;
begin
    select salary
    into emp_salary
    from EMPLOYEES
    where EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE('Before procedure: ' || emp_salary);
    adjust_salary(100, emp_salary, 1000);
    DBMS_OUTPUT.PUT_LINE('After procedure: ' || emp_salary);
end;



create or replace procedure print_boolean(
    b_name varchar2,
    b_value boolean
) authid definer is
begin
    if b_value is null then
        dbms_output.put_line(b_name || ' = NULL');
    elsif b_value = true then
        dbms_output.put_line(b_name || ' = TRUE');
    else
        dbms_output.put_line(b_name || ' = FALSE');
    end if;
end;
/


declare
    l_true boolean := true;
    l_false boolean := false;
    l_null boolean:= null;
begin
    dbms_output.PUT_LINE(sys.diutil.BOOL_TO_INT(not l_true));
    dbms_output.PUT_LINE(sys.diutil.BOOL_TO_INT(l_false));
    dbms_output.PUT_LINE(sys.diutil.BOOL_TO_INT(l_null));
end;


create or replace procedure print_not_x(
    x boolean
) is
    begin
        if x then
            dbms_output.PUT_LINE('test');
        end if;
    --dbms_output.put_line(sys.diutil.BOOL_TO_INT(x));
    end print_not_x;

declare
    l_test1 boolean := null;
    l_test2 boolean := null;
begin
    if l_test2=l_test1 then
        dbms_output.PUT_LINE('equal');
    end if;
end;


DECLARE
bonus NUMBER(8,2);
BEGIN
 SELECT salary * 0.10 INTO bonus
 FROM employees
 WHERE employee_id = 100;
 DBMS_OUTPUT.PUT_LINE('bonus = ' || TO_CHAR(bonus));
END;


/


--IN Operator in Expressions
--Je kan definitely ook een collection hierbij gebruiken, I just don't know how
declare
    procedure test(test1 varchar2, test2 varchar2)
        is
        l_cursor      sys_refcursor;
        l_employee_id number;
    begin
        open l_cursor for test2;
        loop
            fetch l_cursor into l_employee_id;
            dbms_output.put_line(l_employee_id);
            if (l_employee_id in (test1)) then
                dbms_output.put_line('found it');
            end if;
            exit when l_cursor%notfound;
        end loop;
        close l_cursor;
    end;
begin
    test('100', 'select employee_id from employees');
end;



create or replace procedure print_boolean(
    b_name varchar2,
    b_value boolean
) authid definer is
begin
    if b_value is null then
        dbms_output.put_line(b_name || ' = NULL');
    elsif b_value = true then
        dbms_output.put_line(b_name || ' = TRUE');

    else
        dbms_output.put_line(b_name || ' = FALSE');
    end if;
end;
/

DECLARE PROCEDURE print_not_x (
x BOOLEAN
) IS
BEGIN
print_boolean ('x', x);
 print_boolean ('NOT x', NOT x);
END print_not_x;

BEGIN
print_not_x (TRUE);
print_not_x (FALSE);
print_not_x (NULL);
END;
/


-------------Case:
-- This CASE statement has an explicit ELSE clause; however, the ELSE is optional. When
-- you do not explicitly specify an ELSE clause of your own, PL/SQL implicitly uses the
-- following:
-- ELSE
--  RAISE CASE_NOT_FOUND;
declare
    l_test number := 19;
begin
    case
        when l_test>20 then
        dbms_output.PUT_LINE('yo');
    end case;
end;


--Andere vorm van case, maar ook hier zal er een error geraised worden
--Als het aan geen van die dingetjes voldoet
--Daarvoor is die exception block ofc
declare
    l_test number:=21;
begin
    case l_test
        when 20 then
        dbms_output.PUT_LINE('ukkk');
    end case;
exception
    when others then
    dbms_output.PUT_LINE('Case statement komt niet voor!!');
end;

--Andere optie is gewoon om een else block te hebben
declare
    l_test number:=21;
begin
    case l_test
        when 20 then
        dbms_output.PUT_LINE('ukkk');
        else
        dbms_output.PUT_LINE('not 20!!');
    end case;
exception
    when others then
    dbms_output.PUT_LINE('Case statement komt niet voor!!');
end;


--nested case statement
declare
    l_test number;
begin
    case when l_test>10 then
        case when l_test>15 then
            dbms_output.PUT_LINE('bigger than 15');
        when l_test between 19 and 20 then
            dbms_output.PUT_LINE('Output between 19 and 20');
        else
            dbms_output.PUT_LINE('unknown');
        end case;
    else
        dbms_output.PUT_LINE('Unknown outer heeheehaw');
    end case;
end;


create or replace procedure give_bonus(emp_id in number, bonus_amt number) is
begin
    dbms_output.PUT_LINE(emp_id);
    dbms_output.PUT_LINE(bonus_amt);
end;
/

--Hier en als je directly een value assigned dan gaat ie null nemen als hij niets kan vinden in die case ervoor
declare
    salary      number := 0;
    employee_id number := 36325;
    procedure give_bonus(emp_id in number, bonus_amt number) is
    begin
        dbms_output.put_line(emp_id);
        dbms_output.put_line('bonus = ' || bonus_amt);
    end give_bonus;
begin
    give_bonus(employee_id, case
                                when salary >= 10000 and salary <= 20000 then 1500
                                when salary > 20000 and salary <= 4000 then 1000
                                when salary > 40000 then 500
        end);
end;

/
--Ook hier wordt het gewoon null
declare
l_test number:= 100;
l_result number := 0;
begin
    l_result := case when l_test = 20 then 100
                     when l_test = 40 then 200
                end;
    dbms_output.PUT_LINE('result is ' || l_result);
    if l_result is null then
        dbms_output.PUT_LINE('dat shit is null');
    end if;
end;


create or replace procedure chartest(length in number) is
    l_char varchar2(length);
begin
    dbms_output.PUT_LINE(l_char);
end;



create or replace package test_pkg is
    debug constant boolean := true;
    trace constant boolean := false;

    procedure what;
        end test_pkg;

    create or replace package body test_pkg is

    procedure what is
    begin
        dbms_output.PUT_LINE(sys.diutil.BOOL_TO_INT(test_pkg.debug));
    end what;

    end test_pkg;


begin
    test_pkg.what();
end;


