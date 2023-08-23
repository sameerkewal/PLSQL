drop table HR.emp_copy;
create table emp_copy as
select *
from employees;

--The way dat je het 1 voor 1 doet
declare
    type numlist is varray(20) of number;
    depts numlist:=numlist(101, 102, 103);
begin
    for i in depts.first..depts.last loop
        delete from emp_copy
            where employee_id=depts(i);
        dbms_output.put_line(sql%rowcount);
        end loop;
end;



--En nu in een more optimized way using the forall statement
declare
    type numlist is varray(20) of number;
    depts numlist:=numlist(104, 105, 106);
begin
    forall i in depts.first..depts.last
    delete from emp_copy where employee_id=depts(i);
end;





-- a FOR LOOP statement can contain multiple DML statements, while a FORALL statement can
-- contain only one.
--Weird error but ok
declare
    type numlist is varray(20) of number;
    depts numlist:=numlist(107, 108, 109);
begin
    forall i in depts.first..depts.last
    update emp_copy set first_name='Sameer' where employee_id=depts(i);
    delete from emp_copy where employee_id=depts(i);
end;

DROP TABLE employees_temp;
create table employees_temp as
select *
from employees;
declare
    type numlist is varray(10) of number;
    depts numlist := numlist(5, 10, 20, 30, 50, 55, 57, 60, 70, 75);
begin
    forall j in 4..7
        delete from employees_temp where department_id = depts(j);
end;


select DEPARTMENT_ID
from employees_temp
order by DEPARTMENT_ID;


DROP TABLE employees_temp;
create table employees_temp as
select *
from employees;
declare
    type numlist is varray(10) of number;
    depts numlist := numlist(5, 10, 20, 30, 50, 55, 57, 60, 70, 75);
begin
    forall j in 4..7
       delete from emp_copy where DEPARTMENT_ID = depts(j);
end;



--difference between values of and indices of.
declare
    type temp_type is table of number;
    weekly_temp_array temp_type:= temp_type(20, 30, 40, 70);
begin
    forall i in indices of weekly_temp_array
        insert into log (id) values (weekly_temp_array(i));
end;

declare
    type temp_type is table of number;
    weekly_temp_array temp_type:= temp_type(20, 30, 40, 70);
begin
    forall i in values of weekly_temp_array
        insert into log (id) values (i);
end;




drop table log;
create table log(
    id number
);

select *
from log;


drop table valid_orders;
create table valid_orders
(
    cust_name varchar2(32),
    amount    number(10, 2)
);
drop table big_orders;
create table big_orders as
select *
from valid_orders
where 1 = 0;
drop table rejected_orders;
create table rejected_orders as
select *
from valid_orders
where 1 = 0;
declare
    subtype cust_name is valid_orders.cust_name%type;
    type cust_typ is table of cust_name;
    cust_tab              cust_typ; -- Collection of customer names
    subtype order_amount is valid_orders.amount%type;

    type amount_typ is table of number;
    amount_tab            amount_typ; -- Collection of order amounts
    type index_pointer_t is table of pls_integer;
    /* Collections for pointers to elements of cust_tab collection
    (to represent two subsets of cust_tab): */
    big_order_tab         index_pointer_t := index_pointer_t();
    rejected_order_tab    index_pointer_t := index_pointer_t();
    procedure populate_data_collections is
    begin
        cust_tab := cust_typ(
                'Company1', 'Company2', 'Company3', 'Company4', 'Company5'
            );
        amount_tab := amount_typ(5000.01, 0, 150.25, 4000.00, null);
    end;
begin
    populate_data_collections;
    dbms_output.put_line('--- Original order data ---');
    for i in 1..cust_tab.last
        loop
            dbms_output.put_line(
                    'Customer #' || i || ', ' || cust_tab(i) || ': $' || amount_tab(i)
                );
        end loop;
    -- Delete invalid orders:
    for i in 1..cust_tab.last
        loop
            if amount_tab(i) is null or amount_tab(i) = 0 then
                cust_tab.delete(i);
                amount_tab.delete(i);
            end if;
        end loop;
    -- cust_tab is now a sparse collection.
    dbms_output.put_line('--- Order data with invalid orders deleted ---');
    for i in 1..cust_tab.last
        loop
            if cust_tab.exists(i) then
                dbms_output.put_line(
                        'Customer #' || i || ', ' || cust_tab(i) || ': $' || amount_tab(i)
                    );
            end if;
        end loop;
    -- Using sparse collection, populate valid_orders table:
    forall i in indices of cust_tab
        insert into valid_orders (cust_name, amount)
        values (cust_tab(i), amount_tab(i));
    populate_data_collections;
    -- Restore original order data
    -- cust_tab is a dense collection again.
    /* Populate collections of pointers to elements of cust_tab collection
    (which represent two subsets of cust_tab): */
    for i in cust_tab.first .. cust_tab.last
        loop
            if amount_tab(i) is null or amount_tab(i) = 0 then
                rejected_order_tab.extend;
                rejected_order_tab(rejected_order_tab.last) := i;
            end if;
            if amount_tab(i) > 2000 then
                big_order_tab.extend;
                big_order_tab(big_order_tab.last) := i;
            end if;
        end loop;
    /* Using each subset in a different FORALL statement,
    populate rejected_orders and big_orders tables: */
    forall i in values of rejected_order_tab
        insert into rejected_orders (cust_name, amount)
        values (cust_tab(i), amount_tab(i));
    forall i in values of big_order_tab
        insert into big_orders (cust_name, amount)
        values (cust_tab(i), amount_tab(i));
end;

--AHA dit is hoe values of werkt
DECLARE
    TYPE num_collection IS TABLE OF pls_integer index by pls_integer;
    names_ages num_collection;
BEGIN
    names_ages(10):=21;
    names_ages(20):=23;
    FORALL n IN VALUES OF names_ages
        delete from emp_copy where DEPARTMENT_ID=names_ages(n);
END;
/



--Handling the forall exceptions immediately
DROP TABLE emp_temp;
create table emp_temp
(
    deptno number(2),
    job    varchar2(18)
);


create or replace procedure p authid definer as
    type numlist is table of number;
    depts         numlist := numlist(10, 20, 30);
    error_message varchar2(100);
begin
    -- Populate table:
    insert into emp_temp (deptno, job) values (10, 'Clerk');
    insert into emp_temp (deptno, job) values (20, 'Bookkeeper');
    insert into emp_temp (deptno, job) values (30, 'Analyst');
    commit;
    forall j in depts.first..depts.last
        update emp_temp
        set job = job || ' (Senior)'
        where deptno = depts(j);
exception
    when others then
        error_message := sqlerrm;
        dbms_output.put_line(error_message);
        commit;
        raise;
end;

begin
    p;
end;

select *
from emp_temp;

create table bad_job
as select JOB_ID
from jobs
    where 1=2;

select *
from bad_job;

create or replace procedure p authid definer is
    type numlist is table of number;
    depts         numlist := numlist(10, 20, 30);
    error_message varchar2(100);
    bad_stmt_no   pls_integer;
    bad_deptno    emp_temp.deptno%type;
    bad_job       emp_temp.job%type;

    dml_errors exception; --associate the built in error with this name
    pragma exception_init (dml_errors, -24381);
begin
     INSERT INTO emp_temp (deptno, job) VALUES (10, 'Clerk');
     INSERT INTO emp_temp (deptno, job) VALUES (20, 'Bookkeeper');
     INSERT INTO emp_temp (deptno, job) VALUES (30, 'Analyst');
     COMMIT;

     forall j in depts.first..depts.last save exceptions
    UPDATE emp_temp SET job = job || ' (Senior)'
    WHERE deptno = depts(j);
exception
    when dml_errors then
    for i in 1..sql%bulk_exceptions.count loop
        error_message:=sqlerrm(sql%bulk_exceptions(i).error_code);
        dbms_output.put_line(error_message);
        
        bad_stmt_no:= sql%bulk_exceptions(i).error_index;
        dbms_output.put_line('Bad statement #: ' || bad_stmt_no);
        
        bad_deptno:=depts(bad_stmt_no);
        dbms_output.put_line('Bad department #: ' || bad_deptno);
        sELECT job INTO bad_job FROM emp_temp WHERE deptno = bad_deptno;

        dbms_output.put_line('Bad job: ' || bad_job);
        end loop;

    commit;
end;


begin
    p;
end;


-- Getting Number of Rows Affected by FORALL Statement
delete from log;
select *
from log;

declare
    type temp_type is table of number;
    weekly_temp_array temp_type:= temp_type(20, 30, 40, 70);
begin
    forall i in weekly_temp_array.first .. weekly_temp_array.last
        insert into log (id) values (weekly_temp_array(i));
    
   dbms_output.put_line(sql%bulk_rowcount(3));
end;

SQL%BULK_ROWCOUNT


drop table emp_temp;
create table emp_temp as
select *
from employees;
--Ook dit behaved als een associative array
declare
    type numlist is table of number;
    depts numlist := numlist(30, 50, 60);
begin
    forall j in depts.first..depts.last
        delete from emp_temp where department_id = depts(j);

    dbms_output.put_line(sql%bulk_rowcount(2));
    
for i in depts.first..depts.last loop
    DBMS_OUTPUT.PUT_LINE (
                'Statement #' || i || ' deleted ' ||
                sql%bulk_rowcount(i) || ' rows.'
        );
    end loop;
    dbms_output.put_line('Total rows deleted: ' || sql%rowcount);
end;


DROP TABLE emp_by_dept;
CREATE TABLE emp_by_dept AS
 SELECT employee_id, department_id
 FROM employees
 WHERE 1 = 0;


declare
    type dept_tab is table of departments.department_id%type;
    deptnums dept_tab;
begin
    select DEPARTMENT_ID bulk collect into deptnums from departments;
    
    
    forall i in 1..deptnums.count
        insert into emp_by_dept (employee_id, department_id)
        select employee_id, department_id
        from employees
        where department_id=deptnums(i)
        order by department_id, employee_id;
    
    for i in 1..deptnums.count loop
        --Count how many rows were inserted for each department
        
        dbms_output.put_line('Dept ' || deptnums(i) ||': inserted ' ||
                             sql%bulk_rowcount(i) || ' records');
        end loop;
     DBMS_OUTPUT.PUT_LINE('Total records inserted: ' || SQL%ROWCOUNT);
end;











---------------------Bulk collect-------------

declare
    type numTab is table of employees.employee_id%type;
    type nameTab is table of employees.last_name%type;

    enums numtab;
    names nameTab;

    procedure print_first_n(n positive) is
        begin
            if enums.count = 0 then
                dbms_output.put_line('Collections are empty');
            else 
                dbms_output.put_line('First ' || n || ' employees.');

        for i in 1..n loop
            dbms_output.put_line(' Employee # ' || enums(i) || ': ' || names(i));
            end loop;
            end if;
        end;
begin
    select employee_id, last_name
        bulk collect into enums, names
    from employees order by employee_id;

    print_first_n(3);
    print_first_n(6);
end;


--Je kan ook bulk selection into nested table of records
declare
    cursor c1 is
    select FIRST_NAME, LAST_NAME, HIRE_DATE
        from employees;

    type nameset is table of c1%rowtype;

    stock_managers nameset:=nameset();
begin
    stock_managers.extend;
    stock_managers(stock_managers.last).last_name:='Sameer';
    stock_managers(stock_managers.last).first_name:='sam';
    stock_managers(stock_managers.last).hire_date:=sysdate;


    for i in stock_managers.first..stock_managers.last loop
        dbms_output.put_line(stock_managers(i).first_name);
        end loop;
end;



declare
    cursor c1 is
        select first_name, last_name, hire_date
        from employees;

    type nameset is table of c1%rowtype;
    stock_managers nameset := nameset();
begin
    select first_name,
           last_name,
           hire_date bulk collect
    into stock_managers
    from employees
    where job_id = 'ST_MAN'
    order by hire_date;

    for i in stock_managers.first .. stock_managers.last
        loop
            dbms_output.put_line(
                        stock_managers(i).hire_date || ' ' ||
                        stock_managers(i).last_name || ', ' ||
                        stock_managers(i).first_name
                );
        end loop;
end;


create or replace type numbers_type is table of integer;


--Bulk collect met een fetch into a nested table w records
declare
    cursor c is select *
        from employees;

    type emp_rec_type is table of c%rowtype;
    emp_rec emp_rec_type;

begin
    open c;
    fetch c bulk collect into emp_rec;
    close c;

    --Dus emp_rec_type is een array met records erin
    for i in emp_rec.first..emp_rec.last loop
        dbms_output.put_line(emp_rec(i).first_name);
        end loop;
end;


--Okay maar wat als we like 2 specifieke variables hebben(moeten wel collections zijn obviously)
declare
    type namelist is table of emp_copy.last_name%type;
    type numlist is table of emp_copy.salary%type;

    cursor c1 is select LAST_NAME, SALARY
        from emp_copy
        order by last_name;

    nameslist namelist;
    sals numlist;

   /* type recList is table of c1%rowtype;
    recs reclist;*/

    v_limit pls_integer;

begin
    open c1;
    fetch c1 bulk collect into nameslist, sals;
    close c1;

    for i in nameslist.first..nameslist.last loop
        dbms_output.put_line(nameslist(i) || ' with salary: ' || sals(i));
        end loop;
end;


select LAST_NAME, SALARY
from emp_copy
order by last_name;

-- A FETCH BULK COLLECT statement that returns a large number of rows produces a large
-- collection. To limit the number of rows and the collection size, use the LIMIT clause.




declare
    type numtab is table of number index by pls_integer;

    cursor c1 is
        select employee_id
        from employees;

    empids numtab;

begin
    open c1;
    fetch c1 bulk collect into empids limit 10;
    close c1;
    for i in 1..empids.count loop
        dbms_output.put_line('Employee_id: ' || empids(i));
        end loop;
end;


--Als je into een associative array bulk fetched dan gaat het die
--Voor die index(which is only allowed to be a pls_integer) gewoon die rownum zetten
declare
    type numtab is table of number index by pls_integer;

    cursor c1 is
        select employee_id
        from employees;

    empids numtab;
    l_index number:=0;

begin
    open c1;
    fetch c1 bulk collect into empids limit 10;
    close c1;

    l_index:=empids.first;

    while l_index is not null loop
            dbms_output.put_line(l_index);
            dbms_output.put_line(empids(l_index));
            l_index:=empids.next(l_index);

        end loop;
end;

select *
from empl;












----------Returning into met bulk collect into
DROP TABLE emp_temp;
CREATE TABLE emp_temp AS
SELECT * FROM employees
ORDER BY employee_id;

declare
    type idstype is table of employees.employee_id%type;
    type fnametype is table of employees.first_name%type;

    ids idstype;
    fnames fnametype;
begin
    update emp_temp set last_name='heehee' returning last_name, employee_id bulk collect into fnames,ids;

    for i in 1..ids.last loop
        dbms_output.put_line(ids(i) || ' updated: ' || fnames(i));
        end loop;
end;


-- Using FORALL Statement and BULK COLLECT Clause Together
declare
    type idstype is table of employees.employee_id%type;
    type fnametype is table of employees.first_name%type;
    TYPE NumList IS TABLE OF NUMBER;

    ids idstype;
    fnames fnametype;
    depts NumList := NumList(30,50,80);
begin
    forall j in depts.first..depts.count
    update emp_copy set last_name='heeheehawhhhh'
    where department_id=depts(j) returning EMPLOYEE_ID, first_name bulk collect into ids, fnames;

        for i in ids.first..ids.last loop
        dbms_output.put_line(ids(i) || ' ' || fnames(i));
        end loop;

    DBMS_OUTPUT.PUT_LINE ('Deleted ' || SQL%ROWCOUNT || ' rows:');

end;

--Dont do this one bc every iteration it will overwrite your old values
declare
    type idstype is table of employees.employee_id%type;
    type fnametype is table of employees.first_name%type;
    TYPE NumList IS TABLE OF NUMBER;

    ids idstype;
    fnames fnametype;
    depts NumList := NumList(30,50,80);
begin
    for  j in depts.first..depts.count loop
    update emp_copy set last_name='heeheehawhhhh'
    where department_id=depts(j) returning EMPLOYEE_ID, first_name bulk collect into ids, fnames;
    end loop;

    for i in ids.first..ids.last loop
        dbms_output.put_line(ids(i) || ' ' || fnames(i));
        end loop;

    DBMS_OUTPUT.PUT_LINE ('Deleted ' || SQL%ROWCOUNT || ' rows:');


    end;




drop table emp_copy;
create table emp_copy
as select *
from employees;

select *
from emp_copy;