--Q 26:
-- https://docs.oracle.com/cd/B19306_01/appdev.102/b14261/fundamentals.htm

-- If a static package constant is used as the BOOLEAN expression in a valid selection directive
-- in a PL/SQL unit, then the conditional compilation mechanism automatically places a dependency
-- on the package referred to. If the package is altered, then the dependent unit becomes
-- invalid and needs to be recompiled to pick up any changes.
-- Note that only valid static expressions can create dependencies.


--q 36:
create or replace function functest2(p1 in number, p2 out number)return number is
begin
    if p1 = 20 then
        p2:=40;
    end if;
    return 70;
end;


declare
    l_result number;
    l2_value number;
begin
    l_result:=functest2(20, l2_value);
    dbms_output.put_line(l_result || ' ' || l2_value);
end;


--Q 57:


declare
    a constant number:=20;

begin
    null;
end;
-- mag wel not null zijn
--Maar mag geen constant zijn
declare
    type r is record(a number not null:=20, b varchar2(20));
    type rs is record(a constant number);
begin
    null;
end;


--Q 58:
-- PLS-00989: Cursor Variable in record, object, or collection is not supported by this release
declare
    type r is record(a sys_refcursor);

begin
    null;
end;