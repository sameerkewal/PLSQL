/*To list the session cursors that each user session currently has opened and parsed,
query the dynamic performance view V$OPEN_CURSOR.*/
select *
from v$open_cursor;

drop user damien;


--SQL%iopen
-- SQL%ISOPEN always returns FALSE, because an implicit cursor always closes after its
-- associated statement runs.
declare
    rec_emp employees%rowtype;
begin
    select * into rec_emp from employees
    where employee_id=100;
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(sql%isopen));
end;

-- SQL%FOUND returns:
-- • NULL if no SELECT or DML statement has run
-- • TRUE if a SELECT statement returned one or more rows or a DML statement affected one
-- or more rows
-- • FALSE otherwise
declare
begin
    delete from emp_copy;-- where employee_id=999;
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(sql%found));
end;


--Als je een rollback zet dan wordt het nu 0
--Omdat die rollback die effecten van je delete undoet
declare
begin
    delete from emp_copy;
    rollback;
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(sql%found));
end;

--Als je een commit doen dan is het ook geen 0(ig it checks the specific transaction)
--Sql%found doesnt persist past transactions
declare
begin
    delete from emp_copy;
    commit;
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(sql%found));
end;


-- SQL%NOTFOUND (the logical opposite of SQL%FOUND) returns:
-- • NULL if no SELECT or DML statement has run
-- • FALSE if a SELECT statement returned one or more rows or a DML statement
-- affected one or more rows
-- • TRUE otherwise
declare
    l_result boolean:=false;
    emp_rec employees%rowtype;
begin
    select * into emp_rec from employees
    where employee_id=1000;
    l_result:=sql%notfound;
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_result));
end;

--Gaat true zijn hier
declare
    l_result boolean:=false;
    emp_rec employees%rowtype;
begin
    delete from emp_copy where employee_id=999;
    l_result:=sql%notfound;
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_result));
end;

--Gaat null zijn omdat er hier geen enkele statement heeft gerunned
declare
    l_result boolean:=false;
    emp_rec employees%rowtype;
begin
    l_result:=sql%notfound;
    if l_result is null then
        dbms_output.put_line('no statement executed!');
    end if;
    
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_result));
end;


--SQL%rowcount how many rows effected
declare
begin
    delete
        from emp_copy;
    dbms_output.put_line(sql%rowcount);
    rollback;
end;







