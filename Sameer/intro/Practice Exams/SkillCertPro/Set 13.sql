-- Q 13(niet kennen)
begin
    dbms_output.put_line(dbms_describe.DESCRIBE_PROCEDURE('testproc'));
end;

begin
    dbms_metadata.inconsistent_args
end;

-- Q 14
declare
    type t is table of employees.last_name%type;

    l_arr t:=t();

begin
    select LAST_NAME bulk collect into l_arr
        from employees;
    dbms_output.put_line(sql%rowcount );
end;


--Q 18:
-- D is waar staat in documentatie
--Je kan wel geen not null constraint zetten op je formal parameter
-- The scope of the cursor parameters is Local to the cursor
declare
    l number not null:=20;

    cursor c (l_employee_id number default 100) is select last_name
    from employees
    where employee_id>l_employee_id;

    emp_rec c%rowtype;
begin
    open c;
    fetch c into emp_rec;
    dbms_output.put_line(emp_rec.last_name);
    close c;
end;


--Q 21:
--Bij B is het selection directive

--Q 26:

begin
    dbms_output.
end;
    
    
/

--Q 28
--Er mist een then na je elsif
    declare
        a number(3) := 100;
    begin
        if (a = 50) then
            dbms_output.put_line('value of a is 10' );
        elsif (a = 75)
            dbms_output.put_line(' value of a is 20');
        else
            dbms_output.put_line('none of the values is matching');
    end if;
    dbms_output.put_line('exact value of a is: '|| a );
end;


--Q 29
--A is technically true, although I have no idea why'd you even do that
declare
    l_var number:= null;
begin
    case l_var
        when null
        then
        null;
        
        else
        dbms_output.put_line('No match found');
        end case ;
end;

/

--Q 33:
--Kan je 2 varrays ook vergelijken(nested tables kunnen wel)
--Answer is no absolutely not
declare
    type t is varray(20) of number;

    l_arr1 t:=t(10, 20);
    l_arr2 t:=t(10, 20);

    type nt is table of number;

    l_arr3 nt:=nt(30, 40);
    l_arr4 nt:=nt(30, 40);

begin
    if l_arr1 = l_arr2 then
        dbms_output.put_line('test');
    end if;
    
--     if l_arr3=l_arr4 then
--         dbms_output.put_line('what');
--     end if;

end;


--Submultiset
declare
    type t is varray(20) of number;

    l_arr1 t:=t(10, 20);
    l_arr2 t:=t(10, 20);

    type nt is table of number;

    l_arr3 nt:=nt(30, 40);
    l_arr4 nt:=nt(30, 40);
    l_arr5 nt:=nt(30, 40, 40);
    l_arr6 nt:=nt();
    l_arr7 nt;

    l_result boolean;

begin/*
    if l_arr1 = l_arr2 then
        dbms_output.put_line('test');
    end if;*/
    
--     dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr3 submultiset of l_arr4));
--     dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr4 submultiset of l_arr3));
--     dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr4 submultiset of l_arr5));
--     dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr6 submultiset of l_arr5));
--     dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr5 submultiset of l_arr6));
--        dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr7 submultiset of l_arr6));
       dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr6 submultiset of l_arr7));
       dbms_output.put_line(sys.diutil.BOOL_TO_INT(not l_arr6 submultiset of l_arr7));

        l_result:=l_arr7 submultiset of l_arr6;

        if l_result is null then
            dbms_output.put_line('result is null');
        end if;
end;

--Member of
declare
    type t is varray(20) of number;

    l_arr1 t:=t(10, 20);
    l_arr2 t:=t(10, 20);

    type nt is table of number;

    l_arr3 nt:=nt(30, 40);
    l_arr4 nt:=nt(30, 40);

begin
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(30 member of l_arr3));
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(30 not member of l_arr3));
end;

--Is empty
--Just like multiset and member of this one also only works on nested tables
declare
    type t is varray(20) of number;

    l_arr1 t:=t(10, 20);
    l_arr2 t:=t(10, 20);

    type nt is table of number;

    type ac is table of number index by pls_integer;

    l_arr3 nt:=nt(30, 40);
    l_arr4 nt:=nt(30, 40);
    l_arr5 nt:=nt();
    l_arr6 nt;
    l_result boolean;



begin
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr3 is empty));
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr5 is empty));
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr6 is empty));

    l_result:=l_arr6 is empty;
    if l_result is null then
        dbms_output.put_line('result is null');
    end if;

end;


--Is a set
declare
    l_result boolean;
    type ac is table of number index by pls_integer;
    arr ac;

    type t is varray(20) of number;

    l_arr1 t:=t(10, 20);
    l_arr2 t:=t(10, 20);

    type nt is table of number;

    l_arr3 nt:=nt(30, 40);
    l_arr4 nt:=nt(30, 40);
    l_arr5 nt:=nt();
    l_arr6 nt;


begin
    arr(10):=100;
--     dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr1 is a set));
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr3 is a set));
--     dbms_output.put_line(sys.diutil.BOOL_TO_INT(arr is a set));
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr5 is a set));
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_arr6 is a set));

    
    l_result:=l_arr6 is a set;
    
    if l_result is null then
        dbms_output.put_line('l_arr6 is a null');
    end if;


end;

declare
    type r is record(a number, b varchar2(20));
    rec_var r;
begin
--     dbms_output.put_line(rec_var is empty);
    dbms_output.put_line(rec_var is set);
end;



-- Q48
declare
    type r is record(a number, b varchar2(20));
    l r%type;
begin
    null;
end;



begin
    dbms_output.put_line($$plsql_compilation_parameter);
end;


--Q 54:
--Geen DDL statement toch, alleen DML statements
--En bij C, die ISOPEN cursor attribute is juist altijd false for SQL implicit cursors, omdat ze automatisch
--dicht gaan na die statement yk


--Q 55:

--user status doesnt even exist
select *
from user_status;

--en die invalid status wordt echt niet beschreven als je describe command gebruikt



--Q 56
--https://www.oracle.com/technical-resources/articles/database/sql-11g-plsql.html
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/plsql-optimization-and-tuning.html#GUID-C01C53DD-0C0C-4D17-B03A-D00CC183A4EF


--With PL/SQL native compilation, the PL/SQL statements in a PL/SQL unit are compiled into native code and
-- stored in the catalog.
-- The native code need not be interpreted at run time, so it runs faster.
--Dus compilation duurt juist langer met native compilation dan met interpreted mode



--Q 57:
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/plsql-collections-and-records.html#GUID-AC5CEFCB-87AA-41FD-AE16-FFE66606E6B1





---Deterministic test
create or replace function testFunc(emp_id number) return varchar2 deterministic
is
    l_name employees.last_name%type;
begin
    select LAST_NAME into l_name from emp_copy
        where employee_id=emp_id;

    return l_name;
end;


update emp_copy set last_name = 'kewal'
where employee_id=102;

select testfunc(102) from dual;


select EMPLOYEE_ID
from emp_copy;



