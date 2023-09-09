-- Q 29:


--the value of %ROWCOUNT before the first row is fetched is Zero
declare
    cursor c is select *
    from HR.employees;
begin
    open c;
    dbms_output.put_line(c%rowcount);
end;


--Q 35:
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/plsql-subprograms.html#GUID-518B8827-26CC-4734-B799-ACB038185638
-- -- IN OUT:
-- Formal parameter acts like an
-- initialized variable: When the
-- subprogram begins, its value is
-- that of its actual parameter


--Bij out is het the default value van die type