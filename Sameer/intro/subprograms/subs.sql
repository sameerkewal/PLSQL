

create or replace procedure test is
    procedure test2(testman in varchar2) is
        begin
            dbms_output.put_line('can u invoke this?');
        end;
begin
    dbms_output.put_line('Main procedure');
    test2('shit');
end;


begin
    dbms_output.put_line(test.test2);
end;


----Return statement
create or replace function myFunction(original in number) return number
is
    ret_value number;
    test number:=20;
begin
    if test = 20 then
    ret_value:=original*original;
    return ret_value;
    end if;
end;


begin
    dbms_output.put_line(myFunction(20));
end;



--In an anonymous block, the RETURN statement exits its own block and all enclosing
-- blocks. The RETURN statement cannot specify an expression.
begin
    begin
        dbms_output.put_line('Inside inner block.');
        return;
        dbms_output.put_line('Unreachable statement');
    end;
    dbms_output.put_line('Insider outer block also unreachable');
end;




-- If nested subprograms in the same PL/SQL block invoke each other, then one requires a
-- forward declaration, because a subprogram must be declared before it can be invoked.
declare
    procedure proc1(number1 number);

    --Omdat je proc1 hierin called dan moet het al declared zijn
    procedure proc2(number2 number) is
        begin
            proc1(number2);
        end;

    procedure proc1(number1 number)is --hier is waar je die body actually defined
        begin
            proc2(number1);
        end;
begin
    null;
end;




--Nocopy Aliasing from Global Variable as Actual Parameter
--The explanation is that if the compiler ignores the nocopy hint, the final value of the
--global variable lexicon will be aardwolf. This is bc the assignment to aardwolf in the
--main block is not affected by the nocopy hint and the procedure makes a copy of the
--parameters value, resulting in aardwolf being retained
declare
    type definition is record
                       (
                           word    varchar2(20),
                           meaning varchar2(200)
                       );
    type dictionary is varray(2000) of definition;

    lexicon dictionary := dictionary();
    procedure add_entry(
        word_list in out nocopy dictionary --formal nocopy parameter
    )
        is
    begin
        word_list(1).word := 'aardvark'; --Dus dit gaat ig gewoon een copy maken
    end;
begin
    lexicon.extend;
    lexicon(1).word := 'Aardwolf';
    add_entry(lexicon);
    dbms_output.put_line(lexicon(1).word);
end;



-----Default values
create or replace procedure test(p_test number, p_test2 number)
is begin
    dbms_output.put_line(p_test);
end;


begin
    test(10);
end;

--
-- In Example 8-25, the function balance tries to invoke the enclosing procedure swap, using
-- appropriate actual parameters. However, balance contains two nested procedures named
-- swap, and neither has parameters of the same type as the enclosing procedure swap.
-- Therefore, the invocation causes compilation error PLS-00306.
-- die enclosing block is balance en geen swap
declare
    procedure swap(
        n1 number,
        n2 number
    )
        is
        num1 number;
        num2 number;
        function balance(bal number)
            return number
            is
            x number := 10;
            procedure swap(
                d1 date,
                d2 date
            ) is
            begin
                null;
            end;
            procedure swap(
                b1 boolean,
                b2 boolean
            ) is
            begin
                null;
            end;
        begin -- balance
            swap(num1, num2);
            return x;
        end balance;
    begin -- enclosing procedure swap
        null;
    end swap;
begin -- anonymous block
    null;
end; -- anonymous block
/


declare
    l_test number:=70;
procedure s(p in varchar2) is
begin
    dbms_output.put_line(p);
end;
PROCEDURE s(p OUT VARCHAR2) IS
begin
    p:=20;
    dbms_output.put_line(s(p));
end;

begin
    s(l_test);
end;


declare
    l_test number:=70;
procedure s(pin in varchar2) is
begin
    dbms_output.put_line(p);
end;
PROCEDURE s(p OUT VARCHAR2) IS
begin
    p:=20;
    dbms_output.put_line(s(p));
end;

begin
    s(l_test);
end;


---------Recursive function bc why not
create or replace function factorial(
    n number
)return number is
begin
    if n = 1 then
        return n;
    else
    return n*factorial(n-1);
    end if;
end;

begin
    for i in 1..5 loop
        dbms_output.put_line(i || '!= ' || factorial(i));
        end loop;
end;

select *
from user_procedures;


create or replace package test_pkg is
procedure test(p1 number, p2 number);
procedure test(p2 number, p1 number);
end test_pkg;

create or replace package body test_pkg is
    procedure test(p1 number, p2 number) is
    begin
        dbms_output.put_line(p1 || ' ' || p2);
        dbms_output.put_line('First procedure');
    end test;

    procedure test(p2 number, p1 number) is
    begin
        dbms_output.put_line(p1 || ' ' || p2);
        dbms_output.put_line('second procedure');
    end;
end test_pkg;



begin
    test_pkg.test(30 , 50);
end;