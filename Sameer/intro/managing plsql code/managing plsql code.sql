
-- An inquiry directive provides information about the compilation environment.
create or replace procedure test is
begin
     dbms_output.put_line($$plsql_unit);
end;


begin
    test;
end;



-- $$PLSQL_LINE

begin
    dbms_output.put_line($$plsql_line);
end;


begin
    dbms_output.put_line($$plsql_compilation_parameter);
end;



select *
from all_plsql_object_settings;



-- You can assign values to inquiry directives with the PLSQL_CCFLAGS compilation
-- parameter.
-- (alleen booleans of pls_integers allowed)
alter session set plsql_ccflags='TEST:true, SAMEER:21, J:null';


begin
    dbms_output.put_line(sys.diutil.BOOL_TO_INT($$test));
    dbms_output.put_line($$SAMEER);
end;

-- This example uses PLSQL_CCFLAGS to assign a value to the user-defined inquiry
-- directive $$Some_Flag and (though not recommended) to itself. Because later
-- assignments override earlier assignments, the resulting value of $$Some_Flag is 2 and
-- the resulting value of PLSQL_CCFLAGS is the value that it assigns to itself (99), not the
-- value that the ALTER SESSION statement assigns to it ('Some_Flag:1, Some_Flag:2,
-- PLSQL_CCFlags:99')

alter session set plsql_ccflags ='some_flag:1, Some_Flag:20, plsql_ccflags:99';


begin
    dbms_output.put_line($$SOME_FLaG);
end;

begin
    dbms_output.put_line($$plsql_ccflags);
end;


begin
    dbms_output.put_line(dbms_db_version.ver_le_9_1);
end;



create or replace package my_pkg authid definer as
    subtype my_real is
        $ if dbms_db_version.version < 10 $ then
            number; $ else
            binary_double;
            $ end

    my_pi my_real;
    my_e my_real;
end my_pkg;



-- The DBMS_PREPROCESSOR package provides subprograms that retrieve and print the source
-- text of a PL/SQL unit in its post-processed form.
begin
    dbms_preprocessor.PRINT_POST_PROCESSED_SOURCE(
        'PACKAGE',
        'HR',
        'MY_PKG'
        );
end;



create or replace function testfunc return number is
begin
        $if $$test=1 $then
        return 20;
        $else
        return 50;
        $end
end;

begin
    dbms_preprocessor.PRINT_POST_PROCESSED_SOURCE(
        OBJECT_TYPE => 'FUNCTION',
        SCHEMA_NAME => 'HR',
        OBJECT_NAME => 'TESTFUNC');
end;


alter session set plsql_ccflags = 'TEST:1';

begin
    dbms_output.put_line($$TEST);
end;

select testfunc from dual;

begin
        dbms_output.put_line(sys.diutil.BOOL_TO_INT($$some_flag));
end;


begin
    dbms_preprocessor.PRINT_POST_PROCESSED_SOURCE(
        'FUNCTION',
        'HR',
        'TESTFUNC'
        );
end;

alter session set plsql_ccflags ='some_flag:true'
    /


create or replace procedure testProc is
BEGIN
    $if DBMS_DB_VERSION.VER_LE_10_1 $then -- selection directive begins
    $error 'unsupported database release' $end -- error directive
    $else
    DBMS_OUTPUT.PUT_LINE (
    'Release ' || DBMS_DB_VERSION.VERSION || '.' ||
    DBMS_DB_VERSION.RELEASE || ' is supported.'
    );
-- This COMMIT syntax is newly supported in 10.2:
    commit write immediate nowait;
$end
end;

begin
    testproc;
end;

-- The DBMS_PREPROCESSOR package provides subprograms that retrieve and print the source
-- text of a PL/SQL unit in its post-processed form.
--Je kan zien dat het dat eerste stuk van Error nieteens heeft compiled en er gewoon empty space daar is
--Pretty cool
begin
    dbms_preprocessor.print_post_processed_source(
            'Procedure',
            'HR',
            'TESTPROC'
        );
end;


select *
from employees;


CREATE OR REPLACE PACKAGE my_package_spec as
$IF $$DEBUG_FLAG $THEN
    PROCEDURE proc;
    $END
END my_package_spec;





begin
    dbms_preprocessor.PRINT_POST_PROCESSED_SOURCE(
        'PACKAGE',
        'HR',
        'MY_PACKAGE_SPEC');
end;

alter session set plsql_ccflags='DEBUG_FLAG:FALSE';



create or replace package cc_pkg authid definer
$if true $then ACCESSIBLE by (test_pkg) $end
is
    i number:=20;
end cc_pkg;


CREATE OR REPLACE PACKAGE cc_pkg
AUTHID DEFINER
$IF $$XFLAG $THEN ACCESSIBLE BY(p1_pkg) $END
IS
 i NUMBER := 10;
END cc_pkg;



begin
    dbms_preprocessor.PRINT_POST_PROCESSED_SOURCE(
        OBJECT_TYPE => 'PACKAGE',
        SCHEMA_NAME => 'HR',
        OBJECT_NAME => 'CC_PKG')
end;




CREATE OR REPLACE PROCEDURE my_proc (
 $IF $$xxx $THEN i IN PLS_INTEGER $ELSE i IN INTEGER $END
) IS
BEGIN
 NULL;
END my_proc;

begin
    dbms_preprocessor.PRINT_POST_PROCESSED_SOURCE(
        OBJECT_TYPE => 'PROCEDURE',
        SCHEMA_NAME => 'HR',
        OBJECT_NAME => 'MY_PROC');
end;


create or replace view myvw
as select FIRST_NAME||LAST_NAMe as name
from employees;


select *
from myvw;


select *
from user_role_privs;






-- When you grant a database role to a user who is responsible for CBAC grants, you can include the DELEGATE option
-- in the GRANT statement to prevent giving the grantee additional privileges on the roles.
-- The DELEGATE option enables the roles to be granted to program units,
-- but it does not permit the granting of the role to other principals or the administration of the role itself.

grant myroletest to sameer;


create or replace procedure what is
begin
    dbms_output.put_line('test roles');
end;
--Zo dit gaat obv wel
grant myroletest to procedure what;

--En dit gaat niet
grant myroletest to sameer;



--Deze kan beide
grant myadmintest to procedure what;


grant myadmintest to sameer;

select *
from user_role_privs;


--to revoke u do this
revoke myadmintest from procedure what;






---------------Accessible Clause-------------
drop procedure testproc;

create or replace function testfunc return number accessible by(testproc) is
begin
    return 50;
end;


--this obv not gonna work
select
    testfunc from dual;

create or replace procedure testproc is
begin
    dbms_output.put_line(testfunc);
end;


begin
    testproc;
end;

drop package test_pkg;


--Iets in een package accessible to sth outside
create or replace package test_pkg is
function what return number accessible by(yummy);
end test_pkg;


create or replace package body test_pkg is
function what return number accessible by(yummy) is
begin
    return 50;
end what;
end test_pkg;



create or replace procedure yummy is
begin
    dbms_output.put_line(test_pkg.what);
end;

begin
    yummy;
end;



create or replace package test_pkg is function;


--Accessible by met iets in een pkg alleen

create or replace function testfunc return number accessible by(function what, procedure what2) is
begin
    return 20;
end;



create or replace package test_pkg is
function what return number;
end test_pkg;



create or replace package body test_pkg is
function what return number is
    begin
        return testfunc;
    end what;
end test_pkg;



select test_pkg.what from dual;



create or replace function what return number is
begin
    return testfunc;
end;



create or replace procedure what2 is
    l_number number;
begin
    l_number:=testfunc;
end;




-------------Deprecate Pragma

create or replace package test_pkg is
    l_var number:=20;
    pragma deprecate(l_var, 'whqr');
end test_pkg;


--Mag niet in je package body, alleen in die declaration section
create or replace package body test_pkg is
    pragma deprecate(test_pkg);
    l_var number:=30;
end test_pkg;


alter session set plsql_warnings='ENABLE:ALL';

declare
    l_var number;
begin
    l_var:=test_pkg.l_var;
    dbms_output.put_line(l_var);
end;

create or replace package pack1 as
pragma deprecate(pack1, 'pack1 has been deprecated');
procedure foo;
procedure bar;
end pack1;


create or replace package body pack1
as
procedure foo is
begin
    dbms_output.put_line('foo');
end;
procedure bar is
begin
    dbms_output.put_line('bar');
end;
end pack1;

--Dit is hoe je die warning ziet
create or replace procedure test is
begin
    pack1.foo;
end;


begin
    pack1.foo;
end;


alter session set plsql_warnings='ENABLE:ALL';

create or replace package pack7 as
procedure foo;
pragma deprecate(foo, 'pack7.foo deprectated');
end pack7;






--Overloaded pragma deprecate
--depends gewoon op je placement, if i move it under the first proc1 dan warned hij als je die eerste proc1
-- gebruikt
create or replace package pack2
as
procedure proc1(n1 number, n2 number, n3 number);
pragma deprecate(proc1);
procedure proc1(n1 number, n2 number);
end pack2;


create or replace package body pack2
is
    procedure proc1(n1 number, n2 number, n3 number) is
    begin
        dbms_output.put_line(n1 || n2 || n3);
    end proc1;
    procedure proc1(n1 number, n2 number) is
    begin
    dbms_output.put_line(n1 || n2);
    end proc1;
end pack2;


create or replace procedure pack2_test is
begin
    pack2.proc1(10, 20);
end;


create or replace procedure pack2_test is
begin
    pack2.proc1(10, 20, 30);
end;



--je kan ook constant and exceptiosn deprecaten

create or replace package trans_data as
type transrec is record(
    accountType varchar2(30),
    owername varchar2(30),
    balance real
                       );
    min_balance constant real:=10.0;
    pragma deprecate(min_balance, 'Min balance requirement has been removed');
    insufficient_funds exception;
    pragma deprecate(insufficient_funds);
end trans_data;



create or replace package pack11 is
$if dbms_db_version.ver_le_11_1
$then
procedure proc1;
$else
procedure proc1;
pragma deprecate(proc1, 'proc1 has been deprecated');
$end
end;



--je kan een nested procedure niet pragma deprecaten
create or replace procedure testproc is

    
    procedure innerproc is
        pragma deprecate(innerproc);
    begin
        dbms_output.put_line('innerprocedure');
    end;

begin
    dbms_output.put_line('Outer procedure');
end;

--Ook niet op zo een manier
create or replace procedure testproc is


    procedure innerproc is
        --pragma deprecate(innerproc);
    begin
        dbms_output.put_line('innerprocedure');
    end;
    pragma deprecate(innerproc);
begin
    innerproc;
    dbms_output.put_line('Outer procedure');
end;



create or replace procedure whatProc is
begin
    testproc;
end;


begin
    whatproc;
end;






-- Mismatch of the Element Name and the DEPRECATE Pragma
-- Argument
-- This example shows that if the argument for the pragma does not match the name in the
-- declaration, the pragma is ignored and the compiler does not issue a warning.

--met double quotes is het misplaced
create or replace procedure myprocedure is
    pragma deprecate("myprocedure");
begin
    dbms_output.put_line('what');
end;

--En met single quotes heeft ie geen effect
create or replace procedure myprocedure is
    pragma deprecate('myprocedure');
begin
    dbms_output.put_line('what');
end;


--Moet immediately after the declaration of the item to be deprecated appearen
--Anders heeft ie geen effect
create or replace package test_pkg is
procedure proc1;
pragma deprecate(proc1);
procedure proc2;
end test_pkg;


create or replace package body test_pkg is
procedure proc1 is
begin
    dbms_output.put_line('proc1');
end proc1;
procedure proc2 is
begin
    dbms_output.put_line('proc2');
end proc2;
end test_pkg;


create or replace procedure testproc
is
begin
    test_pkg.proc1;
end;


-- When a deprecated entity is referenced in the definition of another deprecated entity then no warning
-- will be issued

--Beide zijn gedeprecate!
create or replace package test_pkg is
procedure proc1;
pragma deprecate(proc1);
procedure proc2;
pragma deprecate(proc2);
end test_pkg;




create or replace package body test_pkg is
procedure proc1 is
begin
    dbms_output.put_line('proc1');
end proc1;
procedure proc2 is
begin
    dbms_output.put_line('proc2');
end proc2;
end test_pkg;


--Als we testproc nu ook deprecated maken, dan zal er geen warning gegenereerd worden
create or replace procedure testproc
is
begin
    test_pkg.proc1;
end;

--Alleen warning voor testproc wordt nu generated, maar niet meer voor test_pkg.proc1
create or replace procedure testproc is
pragma deprecate(testproc);
begin
    test_pkg.proc1;
end;


create or replace procedure uhmproc is
begin
    testproc;
end;


