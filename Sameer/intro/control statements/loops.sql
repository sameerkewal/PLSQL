

--Simple exit when loopie loop
declare
    l_counter number:= 0;
begin
    loop
        dbms_output.PUT_LINE(l_counter);
        exit when l_counter = 10;
        l_counter:= l_counter+1;
    end loop;
end;

--Je kan ook gewoon een if statement met een exit doen like this
declare
    l_counter number:= 0;
begin
    loop
        dbms_output.PUT_LINE(l_counter);
        if l_counter=10 then
            exit;
        end if;
        l_counter:= l_counter+1;
    end loop;
end;


--For Loop
declare
begin
    for i in 1..10 loop
        dbms_output.PUT_LINE(i);
        end loop;
end;

--Nested for loop
--Obvious wat het doet
declare
begin
    for i in 1..10 loop
        for j in 1..5 loop
            dbms_output.PUT_LINE('inner loop with j value: ' || j);
            end loop;
        dbms_output.PUT_LINE('outer loop with i value: ' || i);
        end loop;
end;


--While loop
declare
    l_counter number:= 0;
begin
    while l_counter<10 loop
        l_counter:=l_counter+1;
        dbms_output.PUT_LINE(l_counter);
        end loop;
end;


/*
PL/SQL does not provide a REPEAT UNTIL loop in which the condition is tested after
the body of the loop is executed and thus guarantees that the loop always executes at
least once. You can, however, emulate a REPEAT UNTIL with a simple loop, as follows:
LOOP
 ... body of loop ...
 EXIT WHEN boolean_condition;
END LOOP;*/


--reverse loops
begin
    for i in reverse 1..10 loop
        dbms_output.PUT_LINE('outer loop: ' || i);
        for j in reverse 1..10 loop
            dbms_output.PUT_LINE('inner loop : ' || j);
            end loop;
        end loop;
end;

--Doing anything with the l_counter during the loop isn't gonna have an effect
-- If you make changes within the loop to the variables that you
-- used to determine the FOR loop range, those changes will have no effect
declare
l_counter number := 15;
begin
    for i in 1..l_counter loop
        dbms_output.PUT_LINE(i);
        l_counter:=l_counter+1;
        l_counter := null;
        end loop;
end;

--Omdat het maar 1 keer true is
begin
for i in 1..1 loop
    dbms_output.PUT_LINE(i);
    end loop;
end;


--Mag niet

begin
    for i in 1..10 loop
        i:=i+1;
        dbms_output.PUT_LINE(i);
        end loop;
end;
/
/*
If you have a loop body that you want executed for a nontrivial increment (something
other than one), you will have to write some cute code. For example, what if you want
your loop to execute only for even numbers between 1 and 100? You can make use of
the numeric MOD function, as follows*/
declare
    loop_index number := 0;
begin
    for loop_index in 1..100
        loop
            if mod(loop_index, 2) = 0 then
                dbms_output.put_line(loop_index);
            end if;
        end loop;
end;
/


--Cursor for loop. Ik ken nog geen cursors maar je kan ipv een explicit select statement
--ook een cursor name ofzo daar plaatsen
--where record is a record declared implicitly by PL/SQL with the %ROWTYPE attribute
--against the cursor specified by cursor_name
begin
    for employee in (select * from hr.employees) loop
            dbms_output.PUT_LINE(employee.employee_id);
        end loop;
end;


--Actual cursor
declare
    cursor employee_cur is
    select EMPLOYEE_ID, FIRST_NAME
        from employees order by employee_id;

    employee_rec employee_cur%rowtype;
begin
    open employee_cur;
    loop
        fetch employee_cur into employee_rec;
        dbms_output.PUT_LINE('the employee numbers are: ' || employee_rec.employee_id);
        exit when employee_cur%notfound;
    end loop;
    close employee_cur;
end;


--cursor for loop
--Hier hoef je je cursor niet te openen en te closen
--Ook geen fetch into clause nodig
--Ook geen %notfound attribute nodig
declare
    cursor employee_cur2 is
    select EMPLOYEE_ID, FIRST_NAME
        from employees
            order by employee_id;
begin
    for employee_rec in employee_cur2 loop
        dbms_output.PUT_LINE(employee_rec.first_name);
        end loop;
end;

--If any of the columns in the select list of the cursor is an expression, remember that you
--must specify an alias for that expression in the select list.
declare
    cursor employee_cur2 is
    select department_id, max(salary) as max_sal
        from employees
            group by department_id
            order by department_id;
begin
    for employee_rec in employee_cur2 loop
        dbms_output.PUT_LINE(employee_rec.max_sal);
        end loop;
end;


--Loop labels
-- You can use the loop label to qualify the name of the loop indexing variable (either
-- a record or a number). Again, this can be helpful for readability. Here is an example:
begin
    <<loop_label>>
    for i in 1..10 loop
        dbms_output.PUT_LINE(loop_label.i);
        end loop loop_label;
end;

/*
• When you have nested loops, you can use the label both to improve readability and
to increase control over the execution of your loops. You can, in fact, stop the
execution of a specific named outer loop by adding a loop label after the EXIT
keyword in the EXIT statement of a loop, as follows:*/
begin
    <<outer_loop>>
    for i in 1..10 loop
        dbms_output.PUT_LINE('outer loop: ' || outer_loop.i );
        <<inner_loop>>
        for i in 1..5 loop
            dbms_output.PUT_LINE('inner loop: ' || inner_loop.i);
            --exit outer_loop when i = 5;  --ik kan die outer loop stoppen vanuit die binnenste loop
            exit when i = 4; --als ik gewoon dit doe pakt ie die innerste loop
            end loop inner_loop;
        end loop outer_loop;
end;



--Ofc heb je ook je continue statement
--Als je continue hebt dan gaat het die iteratie skippen,
-- dus alle even getallen zullen niet geprint worden
begin
    for i in 1..10 loop
        continue when mod(i, 2)= 0;
        dbms_output.PUT_LINE(i);
        end loop;
end;



--You can also use CONTINUE to terminate an inner loop and proceed immediately to
--the next iteration of an outer loop’s body. To do this, you will need to give names
-- to your loops using labels. Here is an example:
--Elke keer gaat die inner loop gelijk continuen naar die outer loop
--dus die inner loop gaat elke keer maar 1 keer printen
begin
    <<outer>>
    for outer_index in 1..5 loop
        dbms_output.PUT_LINE('outer index = ' || outer_index);
        <<inner>>
        for j in 1..3 loop
            dbms_output.PUT_LINE('inner index = ' || j);
            continue outer;
            end loop inner;
        end loop outer;
end;

--Maar nu met een if statement
--Nu gaat die inner elke keer tot en met 2
begin
    <<outer>>
    for outer_index in 1..5 loop
        dbms_output.PUT_LINE('outer index = ' || outer_index);
        <<inner>>
        for j in 1..3 loop
            dbms_output.PUT_LINE('inner index = ' || j);
            continue outer when j = 2;
            end loop inner;
        end loop outer;
end;

--Je hebt ook access to die outer loop variables dus je kan dit ook doen

--Dus hier zeg je vanuit die inner loop dat wanneer die outer loop index gelijk is aan
--2 om door te gaan naar die volgende iteratie van die outer loop
begin
    <<outer>>
    for outer_index in 1..5 loop
        dbms_output.PUT_LINE('outer index = ' || outer_index);
        <<inner>>
        for j in 1..3 loop
            continue outer when outer_index = 2;
            dbms_output.PUT_LINE('inner index = ' || j);
            end loop inner;
        end loop outer;
end;



--Simpel voorbeeld van return keyword
create or replace procedure testreturn(p1 in number)
as
begin
    if p1 = 20 then
        dbms_output.PUT_LINE('returning control back to main structure');
        return;
    else
        dbms_output.PUT_LINE('what');
    end if;
end;




begin
    testreturn(p1 => 10);
end;


--Met een goto statement kan je wel uit een loop gaat en in een loop gaan

declare
    l_test number:=20;
    begin
    if l_test=20 then
        goto loop;
    end if;
    <<print>>
    dbms_output.PUT_LINE('testing123');
    <<loop>>
    for i in 1..10 loop
        dbms_output.PUT_LINE(i);
        if i = 5
            then goto the_end;
        end if;
        end loop;
    <<the_end>>
        dbms_output.PUT_LINE('man');
    null;
end;



-- An EXIT WHEN statement in an inner loop can transfer control to an outer loop only
-- if the outer loop is labeled
declare
    l_test number:=0;
    l_inner_test number:=0;
begin
    for i in 1..5 loop
        dbms_output.PUT_LINE('set');
        for j in 1..3 loop
            dbms_output.PUT_LINE('j');
           exit when j = 2;
            end loop;
        end loop;
end;
/

declare
    i pls_integer := 0;
    j pls_integer := 0;
begin
    loop
        i := i + 1;
        dbms_output.put_line('i = ' || i);

        loop
            j := j + 1;
            dbms_output.put_line('j = ' || j);
            exit when (j > 3);
        end loop;
        dbms_output.put_line('Exited inner loop');
        exit when (i > 2);
    end loop;
    dbms_output.put_line('Exited outer loop');
end;


--Simulating STEP Clause in FOR LOOP Statement

declare
step integer:=5;
begin
    for i in 1..3 loop
        dbms_output.PUT_LINE(i*5);
        end loop;
end;


--with the for loop you cannot change the value of the index
declare
begin
    for i in 1..10 loop
        i:=i+5;
        dbms_output.PUT_LINE('i: ' || i);
        end loop;
end;

--You can change the start or end range but it doesnt do anything
declare
    l_start number:=1;
begin
    for i in l_start..10 loop
        dbms_output.PUT_LINE('l_start_range: ' || l_start);
        l_start:=5;
        dbms_output.PUT_LINE('i: ' || i);
        end loop;
end;

declare
    l_end number:=10;
begin
    for i in 1..l_end loop
        dbms_output.PUT_LINE('l_end_range: ' || l_end);
        l_end:=3;
        dbms_output.PUT_LINE('i: ' || i);
        end loop;
end;

/*
Some languages have a LOOP UNTIL or REPEAT UNTIL structure, which tests a condition
at the bottom of the loop instead of at the top, so that the statements run at least once.
To simulate this structure in PL/SQL, use a basic LOOP statement with an EXIT WHEN
statement:*/
--Equivalent of do while in Java
declare
    l_counter number:=0;
begin
    loop
        dbms_output.PUT_LINE('test');
        exit when l_counter=0;
    end loop;
end;



--Label test
--Je kan meerdere labels in dezelfde scope hebben, maar het gaat pas een error geven,
--wanneer je een goto gebruikt en naar 1 van ze gaat
--eentje gedeclareerd in een if block is niet een aparte scope btw
declare
    l_test number:= 50;
begin
    if l_test = 50 then
        goto test;
    end if;
    if l_test=50 then
       <<test>>
        for k in 1..50 loop
           dbms_output.PUT_LINE(k);
           end loop;
    end if;
   /* <<TEST>>
    for i in 1..20 loop
        dbms_output.PUT_LINE('first i: ' || i);
        end loop;*/
    <<test>>
    for i in 1..30 loop
        dbms_output.PUT_LINE(i);
        end loop;
    <<loop_3>>
    for j in 1..20 loop
        dbms_output.PUT_LINE(j);
        end loop;
    end;


--Je mag niet naar een andere block gaan using your goto statement
declare
begin
    goto wtf;
    dbms_output.PUT_LINE('test');
    raise case_not_found;
exception
when others then
    dbms_output.PUT_LINE('others');
    <<wtf>>
    begin
        dbms_output.PUT_LINE('what');
    end;
end;

--Je what label is in een whole other scope declared en dat mag helemaal niet
declare
    l_test number := 50;
begin
    if l_test = 50 then
        goto what;
    end if;
    declare
        l_inner_test number := 20;
    begin
        <<what>>
            dbms_output.put_line('inner label');
    end;
end;


--Een goto statement kan control overdragen aan een enlclosing block
--Is in dezelfde block en in dezelfde scope
declare
    v_last_name varchar2(50);
    v_emp_id number(6):=120;
begin
    <<get_name>>
    select LAST_NAME into v_last_name
    from employees
    where employee_id=v_emp_id;

    begin
        dbms_output.PUT_LINE(v_last_name);
        v_emp_id:=v_emp_id+5;
        if v_emp_id<150 then
            goto get_name;
        end if;
    end;
end;

-- GOTO Statement Cannot Transfer Control into IF Statement
declare
    valid boolean := true;
begin
    goto update_row;

    if valid then
        <<update_row>>
            null;
    end if;
end;

--Je kan ook niet into a loop gaan
declare
    l_test number:=20;
begin
    goto inner_loop;
    for i in 1..20 loop
        <<inner_loop>>
        l_test:= 40;
        dbms_output.PUT_LINE('test');
        end loop;
    dbms_output.PUT_LINE(l_test);
end;



--Using null
begin
    null;
    dbms_output.PUT_LINE('test');
    dbms_output.put_line('test');

end;