--Q 3
declare
    num number;
    fn number;
    function fx(x number) return number is
    f number;
begin
    if x = 0 then
        f := 1;
    else f := x * fx(x - 1);
    end if;
    return f;
end;
begin
    num := 5;
    fn := fx(num);
    dbms_output.put_line(fn);
end;

/

function fx(x in number, y in number) return number
IS
z number;
begin
    if x > 2 * y
    then
        z := x;
    else z := 2 * y;
    end if;
    return z;
end;
begin
    a := 23;
    b := 47;
    c := fx(a, b);
    dbms_output.put_line(c);
end;




--Q 20:
declare
    grade char(1) := 'b';
begin
    case
        when grade = 'a' then dbms_output.put_line('excellent');
        when grade = 'b' then dbms_output.put_line('very good');
        when grade = 'c' then dbms_output.put_line('well done');
        when grade = 'd' then dbms_output.put_line('you passed');
        when grade = 'f' then dbms_output.put_line('better try again');
        else dbms_output.put_line('no such grade');
        end case;
end;

/
--Q 21:
declare
    v_sal number;
BEGIN
    SELECT sal into v_sal from emp where empno = 130;
    insert into emp(empno, ename, sal)
    values (185, 'jones', v_sal + 1000);
end;



--Q 22:
create or replace trigger drop_trigger
    before drop on hr.SCHEMA
    BEGIN
        RAISE_APPLICATION_ERROR (-20000, 'Cannot drop object');
end;
drop trigger drop_trigger;
drop table emp_copy;


--Q 23:
drop trigger testtrigger;
--mogelijk om ook een trigger te maken voor als iemand onlogt op database of op schema level
create or replace trigger testtrigger
after logon on database
begin
    insert into hr.log (user_name) values ('SAMEER');
end;

truncate table hr.log;
SELECT *
FROM hr.LOG;

--Ook voor als iemand oflogt op database of op schema level
create or replace trigger testtrigger before logoff on hr.schema
begin
    insert into hr.log(user_name)values ('whwhhw');
end;

drop trigger testtrigger;
--Op database level
create or replace trigger testtrigger before logoff on database
begin
    insert into hr.log(user_name)values ('whwhhw');
end;

--Q 25:
-- cannot perform a DDL, commit or rollback inside a query or DML
create or replace function testFunc return varchar2
is
    l_var varchar2(20);
begin
        select FIRST_NAME into l_var from employees
            where employee_id=100;
        commit;
       return l_var;
end;


select testfunc from dual;


-- Q 27
declare
    x number := 1;
begin
    loop
        dbms_output.put_line(x);
        x := x + 1;
        if x > 10 then
            exit;
        end if;
        dbms_output.put_line(‘after exit x is: ‘ || x);
    end;


    declare
          dbms_output.chararr;

        num_ number;
    begin
         dbms_output.enable;
         dbms_output.put_line('Hello!');
         dbms_output.put_line('Hope you are doing well!');
         num_ := 2;
         dbms_output.GET_LINE(num_);
         for i in 1..num_ loop
                 dbms_output.put_line((i));
        end loop;
         end;
end loop;/
/

--Q 33
declare
    x number;
begin
    x := 5;
    x := 10;
    dbms_output.put_line(-x);
    dbms_output.put_line(+x);
    x := -10;
    dbms_output.put_line(-x);
    dbms_output.put_line(+x);
end;


--Q 35
DECLARE x number := 4;
begin
    loop
        dbms_output.put_line(x);
        x := x + 1;
        exit when x > 5;
    end loop;
    dbms_output.put_line(x);
end;


declare
    a number(2) := 21;
    b number(2) := 10;
begin
    if (a <= b) then
        dbms_output.put_line(a);
    end if;
    if (b >= a) then
        dbms_output.put_line(a);
    end if;
    if (a <> b) then
        dbms_output.put_line(b);
    end if;
end;

/
declare
    c_id := 1;
    c_name customers.name%type;
    c_addr customers.address%type;
begin
    select name, address into c_name, c_addr from customers where id = c_id;
end;


--Q 49:
create or replace function totalcustomers is
    total number (2) := 0;
begin
    select count(*) into total from customers; return total;
end;



begin
    raise_application_error(-20000, 'fuck');
end;