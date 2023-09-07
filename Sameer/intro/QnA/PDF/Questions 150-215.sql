--Q 162:

declare

    l_result1 number:=40;
    l_result2 number:=40;

begin
    execute immediate 'declare l_number number:=20; begin
    :x := l_number;
    :y := l_number+40;
    dbms_output.put_line(:z);
    null; end;' using out l_result1, out l_result2, in 69;
    
    
    dbms_output.put_line(l_result1 || ' ' || l_result2);
end;


--Q 166:
declare
    pragma inline(adds, 'yes');
    function adds(a number, b number) return number is
--         pragma inline(adds, 'yes');
    begin
        return a +b;
    end;
begin
    dbms_output.put_line(adds(2, 5));
end;



--Q 173:

declare
    function f return number result_cache is
    begin
        return 20;
    end;
begin
    null;
end;



create or replace function testfunc return number result_cache is
    function f return number result_cache is
        begin
            return 21;
        end;
begin
       return 50;
end;



--Q 178:
create or replace package pkg as
    fivethousand pls_integer:=5000;
end pkg;


create or replace function totalemp(sal in binary_float) return number
is 
    total number:=0;
begin
    return sal;
end;


declare
    a pls_integer:=pkg.fivethousand;
    c number;
begin
    c:=TOTALEMP(a);
    dbms_output.put_line(c);
end;

declare
    type emp_info is record (emp_id number(3), expr_summary clob);
    type emp_typ is table of emp_info;
    l_emp emp_typ;
    l_rec emp_info;
begin
    l_rec.emp_id := 1;
    l_rec.expr_summary := empty_clob;
    l_emp := emp_typ(l_rec);
    if l_emp(1).expr_summary is not null
        then
        dbms_output.put_line('summary is null'); end if;
end;
/