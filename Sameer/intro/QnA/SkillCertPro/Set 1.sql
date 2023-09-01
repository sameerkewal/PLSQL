--Q 13:

--B ziet er waar uit. Die cursor name like bv als je dit doet
--Dan is c niet echt een traditional variable yk
declare
    cursor c is select *
    from HR.emp_copy;

    type empcurtype is ref cursor return employees%rowtype;

    emp_cur empcurtype;

begin
    null;
end;


--Q 35:
--OOh yeahhhh .last returned die index not the actual value
declare
    type t is varray(20) of varchar2(20);
    array t:=t(20, 30, 40, 50);
begin
    dbms_output.put_line(array.last);
end;