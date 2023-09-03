-- Q 15:
declare
    type ntb1 is table of varchar2(20);
    v1 ntb1 := ntb1('hello', 'world', 'test');
    type ntb2 is table of ntb1 index by pls_integer;
    v3 ntb2;
begin
    v3(31) := ntb1(4, 5, 6);
    v3(32) := v1;
    v3(33) := ntb1(2, 5, 1);
    v3(31) := ntb1(1, 1);
    v3.delete;
end;

--Q 16:
declare
    type varchar_type1 is varray(3) of varchar2(15);
    type varchar_type2 is varray(3) of varchar2(15);
    type varchar_type3 is varray(3) of varchar2(15);
    type nested_typ is table of varchar_type3;

--     n_table1 nested_typ    := varchar_type3('AB1', 'AB2', 'AB3');
    n_table1 nested_typ    := nested_typ(varchar_type3('AB1', 'AB2', 'AB3'));
    list_a   varchar_type1 := varchar_type1('Seattle', 'Tokyo', 'Paris');
    list_b   varchar_type1;
    list_c   varchar_type2;
begin
    list_b := list_a;
--     list_c := list_a;
end;


--
create function emp_count(p_depr_id number) return number is
    l_ctr number;
begin
    select count(*) into l_ctr from dept where dept_id = p_dept_id;
    return l_ctr;
end emp_count;
/
grant execute on branch1.emp_count to branch2;
create view emp_counts_vw as
select dept_id, emp_count(dept_id) no_row_emps
from dept
group by dept_id;
grant select on emp_counts_vw to branch2;



declare
    type dept_list_typ is table of dept.dept_id%type;
    l_dept  dept_list_typ;
    e_count number;
begin
    if l_dept.count is null then
        select no_of_emps into e_count from branch1.mp_counts_vw where dept_id = 1;
        dbms_output.put_line('Dept ID: 1' || ' No of Emps: ' || e_count);
    end if;
end;


--Q 41:
create or replace procedure check_price(p_prod_id number)
    is
    v_price product.prod_list_price%type;
begin
    select prod_list_price
    into v_price
    from product
    where prod_id = p_prod_id;
    if v_price not between 20 and 30 then
        raise_application_error(-20100, 'price not in range');
    end if;
end;


create or replace trigger check_price_trg
    before insert or update of prod_id, prod_list_price
    on product
    for each row
    when (:new.prod_id > nvl(:old.prod_id, 0) or
          :new.prod_list_price > nvl(:old.prod_list_price, 0) )
begin
    check_price(:new.prod_id);
end;


--Q 44:
create or replace procedure wording
    is
    type definition is record
                       (
                           word    varchar2(20),
                           meaning varchar2(200)
                       );
    lexicon definition;
    procedure add_entry(word_list in out definition)
        is
    begin
        word_list.word := 'aardvark';
        lexicon.word := 'aardwolf';
    end add_entry;
begin
    add_entry(lexicon);
    dbms_output.put_line(word_list.word);
    dbms_output.put_line(lexicon.word);
end wording;


create or replace trigger dept_restrict
    before delete or update of deptno
    on dept
declare
    dummy integer;
    employees_present exception;
    employees_not_present exception;
    cursor dummy_cursor (dn number) is
        select deptno
        from emp
        where deptno = dn;
begin
    open dummy_curosr(:old.deptno);
    fetch dummy_cursor into dummy;
    if dummy_cursor%found then
        raise employees_present;
    else
        raise employees_not_present;
    end if;
    close dummy_cursor;
exception
    when employees_present then
        close dummy_cursor;
        raise_application_error(-20001, employees present in ||  department  || to_char(:old.deptno));
    when employees_not_present then
        close dummy_cursor;
end;


create or replace package pkg_test is
function getValue return number;
procedure setNumber(p number);
end pkg_test;


create or replace package body pkg_test is
f number:=39;
function getValue return number is
    begin
return f;
end getValue;

procedure setNumber(p number) is
    begin
        f:=p;
    end setNumber;
end pkg_test;





begin
    pkg_test.setNumber(200);
    dbms_output.put_line(pkg_test.getValue);
end;


begin
    dbms_output.put_line(pkg_test.getValue);
end;



--Q 8
--als je het doet met IR dan werkt ie wel en als je die role grant to the unit
--itself dan gaat ie ook

--Q 13:
create or replace function whatfunc return number is
    function innerfunc return number result_cache is
        begin
            return 69;
        end;
begin
    return innerfunc;
end;


begin
    dbms_output.put_line(whatfunc);
end;


--Q 17:
In previous versions of the database, calling invoker rights functions within a
view made the functions run in the context of the view owner,
essentially breaking the invoker rights functionality.

The main thing to note about the use of invoker rights in a view is it does not
affect the way the basic view works. It only affects how invoker rights functions
called within the view work.


declare
    type l is table of number;
begin
    null;
end;


/
--Q 18:


CREATE or replace PACKAGE pkg AS
fivethousand PLS_INTEGER := 5000;
END;
/
DECLARE
a pls_integer := pkg.fivethousand;
c number;
BEGIN
c := totalEmp(a);
dbms_output.put_line(c);
END;

create or replace function totalEmp(salary in binary_float)
return number is
    total number:=0;
    begin
        return total;
    end;


create or replace function totalEmp(salary in binary_float)
return number is
    total number:=0;
    begin
        return salary;
    end;


--Q 62:
declare
    type empcurtype is ref cursor return employees%rowtype;
    empcur empcurtype;
begin
    open empcur for select *
    from employees;
end;






create table ww(
    id number,
    name varchar2(20)
)

create or replace view ww_vw as
select *
from ww;

alter table ww add name3 varchar2(50);

declare
    x number;
begin
    select count(*)
    into x
    from user_tab_cols
        where table_name='WW';
    dbms_output.put_line(x);
end;
