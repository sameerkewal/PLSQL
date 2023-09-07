--Q 1:

--You can assign a weak cursor variable to a strong cursor variable which is weird
--Maar je gaar toch nog die originele return type hebben when u try to open sth using the cursor
declare
    type empcur is ref cursor return employees%rowtype;
    type deptcur is ref cursor return departments%rowtype;

    c1 empcur;
    c2 deptcur;
    c3 sys_refcursor;
begin
--     c1:=c2;
--     c1:=c3;
        c3:=c2;
    open c1 for select *
        from employees;

    open c3 for select *
        from jobs;



end;

