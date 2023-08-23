create or replace package error_pkg is
    e_fk_err exception;
    e_seq_nbr_err exception;
    pragma exception_init (e_fk_err, -2292);
    pragma exception_init (e_seq_nbr_err, -2277);
end error_pkg;

--Gebruik maken van standardized packages met exception declarations erin
declare
begin
    if true then
        raise error_pkg.e_fk_err;
    end if;
exception
    when error_pkg.e_fk_err then
    dbms_output.put_line(sqlerrm);
end;


-- Stored PL/SQL units that can be created or altered with the following statements can use the optional
-- AUTHID clause to specify either DEFINER (the default, for backwards compatibility) or CURRENT_USER
-- (the preferred usage
-- CREATE FUNCTION
-- CREATE PACKAGE
-- CREATE PROCEDURE
-- CREATE TYPE
-- ALTER TYPE


-- Autonomous Transaction in nested block mag niet(mag wel gewoon in outer block)
declare
    l_number number;
begin
    declare
        pragma autonomous_transaction;
    begin
        dbms_output.put_line('what');
    end;
    dbms_output.put_line('test');
end;


declare
    pragma autonomous_transaction;
    l_number number;
begin
    declare
       l_number2 number;
    begin
        dbms_output.put_line('what');
    end;
    dbms_output.put_line('test');
end;


create or replace procedure attest
    is
    pragma autonomous_transaction;
    procedure nestedattest is
        pragma autonomous_transaction;
    begin
        dbms_output.put_line('test');
    end;
begin
    dbms_output.put_line('what');
end attest;


-- If you try to exit an active autonomous transaction without committing or rolling back, the
-- database raises an exception. If exception unhandled or transaction ends due to other unhandled
-- exception, then the transaction rolls back.

create or replace procedure AtTest
is
pragma autonomous_transaction;
begin
    insert into log
    values (20);
end;

-- active autonomous transaction detected and rolled bac
begin
    dbms_output.put_line('what');
    AtTest;
end;









---------------No copy
declare
    type definition is record
                       (
                           word    varchar2(20),
                           meaning varchar2(200)
                       );
    type dictionary is varray(2000) of definition;
    lexicon dictionary := dictionary(); -- global variable
    procedure add_entry(
        word_list in out nocopy dictionary -- formal NOCOPY parameter
    ) is
    begin
        word_list(1).word := 'aardvark';
    end;
begin

    lexicon.extend;
    lexicon(1).word := 'aardwolf';
    add_entry(lexicon); -- global variable is actual parameter
    dbms_output.put_line(lexicon(1).word);
end;

--Als het nocopy obeyed dan wordt die value aardvark.
--If not dan blijft het aardwolf
--De reden hiervoor is dat als hij het obeyed beide lexicons verwijzen naar dezelfde memory locatiom
--En zo change in de ene plek zal reflecteren op de andere plek
--Als het niet naar dezelfde memory location verwijst, dus als het nocopy niet obeyed dan
--zal ie de value van die global variableg gewoon uitprinten, want dat is in scope
--En dat is aardwolf














-----------------Parallel enable-----------

-- The function must not use session state, such as package variables, because those variables
-- are not necessarily shared among the parallel execution servers.
-- Maar gaat niet erroren ofzo lmao
create or replace package pkg_test is
l_number number:=69;
end pkg_test;


create or replace function testfunc return number parallel_enable
is
    l_number2 number:=pkg_test.l_number;
begin
    return 20;
end;


select testfunc from dual;


-- Use the optional PARTITION argument BY clause only with a function that has a REF CURSOR
-- data type. This clause lets you define the partitioning of the inputs to the function from
-- the REF CURSOR argument. Partitioning the inputs to the function affects the way the query is
-- parallelized when the function is used as a table function in the FROM clause of the query.

create or replace function testfunc return sys_refcursor parallel_enable
is
    v_cursor sys_refcursor;
begin
    open v_cursor for select * from employees;
    return v_cursor;
end;


-- You cannot specify parallel_enable_clause for a nested function
drop function testfunc;

create or replace testfunc return number is
    function what return sys_refcursor parallel_enable is
    begin
    return 20;
    end;
begin
    return 50;
end;











------------Deterministic clause