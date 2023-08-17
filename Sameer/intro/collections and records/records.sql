--Als je een record var hebt met een constant moet je een function maken dat
--het initially populate
create or replace package my_types is
    type my_rec is record (a number, b number);
    function init_my_rec return my_rec;
end my_types;

create or replace package body my_types is
function init_my_rec return my_rec is
    rec my_rec;
    begin
    rec.a:=20;
    rec.b:=40;
    return rec;
    end init_my_rec;
end my_types;

declare
    r constant my_types.my_rec:=my_types.init_my_rec();
begin
    dbms_output.put_line(r.a);
end;


-----Declaring record variables met null of defaults idk
declare
    type test is record(
        a number not null default 20,
        b number default 60
                       );

        myrec test;
begin
    dbms_output.put_line(myrec.b);
end;

declare
    type test is record(
        a number not null default 20,
        b number not null:=90,
        c number default 50
                       );

        myrec test;
begin
    dbms_output.put_line(myrec.c);
end;



--%rowtype inherit geen initial values of not null constraints
drop table t1;
create table t1(
    c1 integer default 0 not null,
    c2 integer default 1 not null
);
/
declare
    t1_row t1%rowtype;
    t1_test t1.c1%type;

begin
    dbms_output.put_line(t1_row.c1);
    dbms_output.put_line(t1_test);
end;

--Je rowtype hoeft niet speciaal like een hele row te zijn, denk maar aan een cursor
declare
    cursor c is
    select FIRST_NAME, LAST_NAME, PHONE_NUMBER
    from employees;
    
    friend c%rowtype;
begin
    friend.first_name:='Sameer';
    friend.last_name:='Kewal';
    friend.phone_number:='115';
    dbms_output.put_line(friend.first_name);
    dbms_output.put_line(friend.last_name);
    dbms_output.put_line(friend.phone_number);
end;

create table plch_departure
(
    destination    varchar2(100),
    departure_time date,
    delay          number(10),
    expected generated always as(departure_time + delay/24/60/60)
);

/*
If you use the %ROWTYPE attribute to define a record variable that represents a full row
of a table that has a virtual column, then you cannot insert that record into the table.
Instead, you must insert the individual record fields into the table, excluding the virtual
column.
*/
--Insert operation disallowed on virtual columns
declare
    dep_rec plch_departure%rowtype;
begin
    dep_rec.destination:='Hollanda';
    dep_rec.departure_time:=sysdate+30;
    dep_rec.delay:=1500;

    insert into plch_departure values dep_rec;
end;


---With invisible column
drop table inivis_test;
create table inivis_test(
    id number,
    name varchar2(20),
    ins_date date invisible default sysdate
);



insert into inivis_test(id, name)values(20, 'sameer');
insert into inivis_test(id, name)values(21, 'sameer2');
select *
    from inivis_test;

alter table inivis_test modify ins_date visible;


create or replace procedure invis_proc is
    my_row inivis_test%rowtype;
begin
  my_row.ins_date:=sysdate+10;
  dbms_output.put_line(my_row.ins_date);
end;


create or replace procedure invis_proc2 is
        cursor c is select * from inivis_test;
        test c%rowtype;
begin
    test.name:='sameer';
    dbms_output.put_line(test.name);
end;


--Record met een field als nested table
declare
    type array is table of varchar(20);
    type test is record(
        bootcampers array,
        startdatum date not null:=sysdate
                       );

    myrec test;
begin
    myrec.bootcampers:=array('sameer', 'trisha', 'shaun', 'damien', 'shavien');
    dbms_output.put_line('de bootcampers zijn: ');

    for i in myrec.bootcampers.first..myrec.bootcampers.last loop
    dbms_output.put_line(myrec.bootcampers(i));
    end loop;
    
    dbms_output.put_line('En gestart op: ');
    dbms_output.put_line(myrec.startdatum);
end;



--Nested table met records erin kan ook maar die syntax is so FUCKING CONFUSING HOLY SHIT
declare
    type myrectype is record(
          eind_datum date,
          startdatum date not null:=sysdate
    );

    my_real_rec myrectype:=myrectype(eind_datum => sysdate, startdatum => sysdate-10);

    type array_type is table of myrectype;
    arr array_type:=array_type(my_real_rec, myrectype(eind_datum => sysdate-100, startdatum => sysdate));


begin
    dbms_output.put_line('works so far');
    dbms_output.put_line(arr(1).startdatum);
    dbms_output.put_line(arr(1).eind_datum);

    dbms_output.put_line('--------------');

    dbms_output.put_line(arr(2).startdatum);
    dbms_output.put_line(arr(2).eind_datum);

end;



----Select into
declare
    type RecordTyp is record(
        last employees.last_name%type,
        id employees.employee_id%type
                            );
    rec1 recordtyp;
begin
    select LAST_NAME, employee_id into rec1
    from employees
    where job_id='AC_ACCOUNT';
    
    dbms_output.put_line(rec1.id);
end;




--Fetch into
declare
    type emprectyp is record
                      (
                          emp_id employees.employee_id%type,
                          salary employees.salary%type
                      );
    cursor cur_salary is
        select employee_id, salary
        from employees;-- where job_id='AC_ACCOUNT';

    emp_var emprectyp;

begin
    open cur_salary;
    loop
        fetch cur_salary into emp_var;
        dbms_output.put_line(emp_var.emp_id);
        exit when cur_salary%notfound;
    end loop;
        close cur_salary;
    end;

----------Return into
declare
    type EmpRec is record(
        last_name employees.last_name%type,
        salary employees.salary%type
                         );
    emp_info emprec;
    old_salary employees.salary%type;

begin
    select salary into old_salary
    from employees where employee_id=100;
    
    update emp_copy
    set salary=salary*1.1
    where employee_id=100
    returning last_name, salary, first_name into emp_info;
    
    dbms_output.put_line('salary of ' || emp_info.last_name || ' was updated from ' ||
                         old_salary||' to ' || emp_info.salary);

    rollback;
end;

--Als je null asigned naar een record dan worden zn fields ook null

declare
    type age_rec is record(
        years integer default 35,
        months integer default 6
                          );

    type name_rec is record(
        first employees.first_name%type default 'John',
        last employees.last_name%type default 'Doe'
                           );

    name name_rec;

    procedure print_name as
    begin
        dbms_output.put_line((nvl(name.first, 'NULL') || ' '));
        dbms_output.put_line(nvl(name.last, 'NULL') || ', ');
    end;
begin
    print_name;
    name:=null;
    print_name;
end;


drop table schedule;
create table schedule
(
    week number,
    mon  varchar2(10),
    tue  varchar2(10),
    wed  varchar2(10),
    thu  varchar2(10),
    fri  varchar2(10),
    sat  varchar2(10),
    sun  varchar2(10)
);
declare
    default_week schedule%rowtype;
    i            number;
begin
    default_week.mon := '0800-1700';
    default_week.tue := '0800-1700';
    default_week.wed := '0800-1700';
    default_week.thu := '0800-1700';
    default_week.fri := '0800-1700';
    default_week.sat := 'Day Off';
    default_week.sun := 'Day Off';
    for i in 1..6
        loop
            default_week.week := i;
            insert into schedule values default_week;
        end loop;
end;


select * from schedule;
/

