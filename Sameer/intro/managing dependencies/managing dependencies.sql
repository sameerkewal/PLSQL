--How to display the dependent and references object types in your db if you are logged in as dba
select *
from dba_dependencies;


--Dit zijn ig types die een dependency kunnen hebben
select distinct type from dba_dependencies
order by type;


--Dit zijn die types die gereferenced worden
select distinct REFERENCED_TYPE
from user_dependencies;


select *
from user_dependencies;



create or replace view sixfigures as
select *
from emp_copy
where salary >= 10000;


select *
from sixfigures;

create or replace view commissioned as
select first_name, last_name, commission_pct
from emp_copy where commission_pct is not null;

--Alseen splqplus formatting command gebruikt zou hebben zoals
-- COLUMN object_name FORMAT A16
--dan zou ie invalid worden


alter table emp_copy modify email varchar2(100);



--Sixfigures is invalid geworden, omdat het depend on the email column
-- which u just modified
select object_name, status
from user_objects
where object_type='VIEW'
order by object_name;

--Als je het queried
select *
from sixfigures;

--Dan wordt ie automatisch weer valid
select object_name, status
from user_objects
where object_type='VIEW'
order by object_name;


--The view ideptree, presorted pretty print view which contains information
--on the object dependency tree


select *
from commissioned;





--voorbeeld van coarse grained invalidation
alter table emp_copy drop column first_name;


-- ORA-00904: "FIRST_NAME": invalid identifier
select *
from user_errors;

drop table emp_copy;

drop view emp_copy;

create  table emp_copy
as select *
from employees;

create or replace view commissioned as
    select first_name, last_name, commission_pct
from emp_copy
    where commission_pct is not null;

select *
from commissioned;

select *
from emp_copy;



alter table emp_copy drop column first_name;


select object_name, status
from user_objects
where object_type='VIEW'
order by object_name;


--Als je nieuwe function zet voor die originele(new_var)
--dan invalidate het die wat je al had
create or replace package test_pkg is
function new_var return varchar2;
function get_var return varchar2;
end test_pkg;


create or replace package body test_pkg is
    function get_var return varchar2 is
    begin
        return 'this is a return value';
    end get_var;
end;


create or replace procedure currentTest is
begin
    dbms_output.put_line(test_pkg.get_var);
end;


begin
    CURRENTTEST;
end;


--dit is nu invalidated
select object_name, status
from user_objects
where object_name='CURRENTTEST';

select object_name, status
from user_objects
where object_name='TEST_PKG';


select object_name, object_type, status
from user_objects
where object_name='TEST_PKG';

--But if u were to add it to the end then nothing that depends on these
--functions is invalidated
create or replace package test_pkg is
    function get_var return varchar2;
    function new_var return varchar2;
    function new_var2 return varchar2;
end test_pkg;


create or replace package body test_pkg is
    function get_var return varchar2 is
    begin
        return 'this is a return value';
    end get_var;
end;





create or replace procedure funcTest is
begin
    dbms_output.put_line(test_pkg.get_var);
end;


begin
    functest;
end;

select object_name, status, object_type
from user_objects
where object_name='FUNCTEST';




-- An object that is not valid when it is referenced must be validated before it can be
-- used. Validation occurs automatically when an object is referenced;
-- it does not require explicit user action.
-- als je die view maakt
drop table emp_copy;

create table emp_copy
as select *
from employees;

create or replace view commissioned
as select *
from emp_copy;


-- en een column ervan dropped
alter table emp_copy
drop column employee_id;

--Dan is ie invalid
select *
from commissioned;


--maar als je die column weer zet
alter table HR.emp_copy
add  employee_id number;



--en weer selecteert van die view dan dan is ie automatically weer valid
select *
from commissioned;



--Maar je moet eerst selecteren van die view voor
--Het weer valid is
select object_name, status, object_type
from user_objects
where object_name='COMMISSIONED';



--Controlling dependency mode
alter session set remote_dependencies_mode='SIGNATURE';




