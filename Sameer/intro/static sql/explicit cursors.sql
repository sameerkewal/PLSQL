declare
    --je declaratie:
    cursor emp_cur return employees%rowtype;

    --Je definitie
    --If you declared the cursor earlier, then the explicit cursor definition defines it;
    --otherwise, it both declares and defines it.
    cursor emp_cur return employees%rowtype is select * from HR.employees;
    
begin
    dbms_output.put_line('tets');
end;

--Fetch statement met individuele variabelen
declare
    cursor c1 is select last_name, job_id
                 from employees;
    v_last_name employees.last_name%type;
    v_job_id    employees.last_name%type;
    v_counter   number := 0;
begin
    open c1;
    loop
        fetch c1 into v_last_name, v_job_id;
        exit when c1%notfound;
        dbms_output.put_line(rpad(v_last_name, 25, ' ') || v_job_id);
        v_counter := v_counter + 1;
    end loop;
    dbms_output.put_line('count: ' || v_counter);
end;

declare
    cursor emp_cur is select * from employees;
    emp_rec employees%rowtype;
begin
    open emp_cur;
    loop
        fetch emp_cur into emp_rec;
        exit when emp_cur%notfound;
       DBMS_OUTPUT.PUT_LINE( RPAD(emp_rec.last_name, 25, ' ') || emp_rec.job_id );
    end loop;
end;

--zolang die cursor opened dan evalueert het emp_id al increment je emp_id in je loop
--its not gonna matter
declare
    l_emp_id number:=100;
    cursor emp_cur is select * from employees
        where employee_id>l_emp_id;
begin
    l_emp_id:=140;
    for item in emp_cur loop
        dbms_output.put_line(item.employee_id || ' ' || item.job_id);
    l_emp_id:=200;
    end loop;
end;


/*When an explicit cursor query includes a virtual column (an expression), that column must
have an alias if either of the following is true:
• You use the cursor to fetch into a record that was declared with %ROWTYPE.
• You want to reference the virtual column in your program.*/

declare
cursor c1 is
    select employee_id,
           (salary * .05)raise
    from employees;

    emp_rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into emp_rec;
        exit when c1%notfound;
        dbms_output.put_line(emp_rec.employee_id);
    end loop;
end;


--Explicit cursor that accepts parameters
declare

    l_lastname employees.last_name%type;
    l_jobid employees.job_id%type;
    l_salary employees.salary%type;

    cursor c(job varchar2, max_sal number)
    is select LAST_NAME, job_id, (salary-max_sal) overpayment
    from employees
        where job_id=job
        and salary>max_sal
    order by salary;
    begin
    open c('IT_PROG', 20);
    loop
        fetch c into l_lastname, l_jobid, l_salary;
        exit when c%notfound;
        dbms_output.put_line(l_jobid);
    end loop;
end;


--Je kan ook default values hier aangeven
--dmv default keyword
declare

    l_lastname employees.last_name%type;
    l_jobid employees.job_id%type;
    l_salary employees.salary%type;

    cursor c(job varchar2:='AC_ACCOUNT', max_sal number default 2000)
    is select LAST_NAME, job_id, max_sal overpayment
    from employees
        where job_id=job
        and salary>max_sal
    order by salary;
    begin
    open c;
    loop
        fetch c into l_lastname, l_jobid, l_salary;
        exit when c%notfound;
        dbms_output.put_line(l_salary);
    end loop;
end;


------------Cursor attributes

--isopen returns true als je cursor al open is
/*If you try to open an explicit cursor that is already open, PL/SQL raises the predefined
exception CURSOR_ALREADY_OPEN. You must close an explicit cursor before you can
reopen it.*/
declare
    cursor c is select * from employees;
begin
    open c;
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(c%isopen));
    close c;
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(c%isopen));
end;

/*   %FOUND returns:
• NULL after the explicit cursor is opened but before the first fetch
• TRUE if the most recent fetch from the explicit cursor returned a row
• FALSE otherwise*/
declare
 cursor c(p_employee_id number default 100) is select * from employees
    where employee_id=p_employee_id;
    emp_rec employees%rowtype;
    l_result boolean;
begin
    open c;
    l_result:=c%found;
    
    if l_result is null then
        dbms_output.put_line('shiut is null bc we havent processed any rows');
        
        --true
        fetch c into emp_rec;
        dbms_output.put_line('after fetching a row: ');
        dbms_output.put_line(sys.diutil.BOOL_TO_INT(c%found));


        close c;

        open c(p_employee_id => 999);
        fetch c into emp_rec;
        --Zal 0 returnen bc it doesnt find any rows(nergens is emp_id 999)
        dbms_output.put_line(sys.diutil.BOOL_TO_INT(c%found));
        close c;
    end if;
end;

--Notfound is opposite

declare
    cursor emp_cur is select * from employees;
    emp_rec employees%rowtype;
begin
    open emp_cur;
    loop
        fetch emp_cur into emp_rec;
        exit when emp_cur%notfound;
    end loop;
    dbms_output.put_line(emp_cur%rowcount);
end;

declare


--Implicit cursor for loop
begin
    for item in (select * from employees) loop
        dbms_output.put_line(item.employee_id);
        end loop;
end;

--Explicit cursor met een for loop but i pass variables to it

declare
    cursor c1(job varchar2, max_wage number)is
    select first_name, last_name from employees where job_id=job and salary>max_wage;
begin
    for person in c1('IT_PROG', 0) loop
        dbms_output.put_line(person.first_name);
        end loop;

    --en nu met andere argumenten:
    for human in c1(job => 'ACC_ACCOUNT', max_wage => 2000) loop
        dbms_output.put_line(human.last_name);
        end loop;
end;



--Verplicht om alias te gebruiken als je een expression vanuit die column
--wilt refereren
BEGIN
    for item in (
        select first_name || ' ' || last_name as full_name, salary,
               salary * 10
        from employees
        where rownum <= 5
        order by salary*10 desc, last_name asc
        )
        loop
 DBMS_OUTPUT.PUT_LINE
 (item.full_name || ' dreams of making ' || item.salary*10);
        end loop;
end;




