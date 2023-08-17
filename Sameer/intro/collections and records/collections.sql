--Defining an associative array indexed by String
declare
    type population is table of number
    index by varchar2(64);
    
    l_index varchar2(128);
    
    city_population population;
begin
    city_population('Smallville'):=2000;
    city_population('Midland'):=750000;
    city_population('Australia'):=750000;
    city_population('Blasiab'):=750000000;
    city_population('Megapolis'):=1000000;

    l_index:=city_population.first;
    
    while l_index is not null loop
        dbms_output.PUT_LINE(city_population(l_index));
        l_index:=city_population.next(l_index);
        dbms_output.PUT_LINE(l_index);
        end loop;
end;



--Function returns associative array indexed by varchar2
declare
type name_age is table of number index by varchar2(200);

returned_name_age name_age;
l_index varchar2(255);

function funcAssociativeArray
    return name_age
is
    name_aged name_age;
begin
    name_aged('Sameer'):=21;
    name_aged('Test'):=20;
    return funcAssociativeArray.name_aged;
end;
begin
    returned_name_age:= funcAssociativeArray();

    l_index:=returned_name_age.first;

    while l_index is not null loop
        dbms_output.put_line('The age of ' || l_index || ' is ' || returned_name_age(l_index));
        l_index:=returned_name_age.next(l_index);
        end loop;
end;


-- In the declaration of an associative array indexed by string, the string type must be
-- VARCHAR2 or one of its subtypes.
-- However, you can populate the associative array with indexes of any data type that the
-- TO_CHAR function can convert to VARCHAR2.
declare
type test is table of varchar2(25) index by varchar2(25);
mytest test;
begin
    dbms_output.put_line('test');
    mytest(localtimestamp):='sameer';
end;

declare
type test is table of varchar2(25) index by varchar2(25);
mytest test:= test('Sameer'=> 'Kewal', 'bruh'=>'moment');
begin
   dbms_output.put_line(mytest.first);
end;



-- Assigning Values to Associative Array Type Variables Using Qualified
-- Expressions
declare
    type t_aa is table of varchar2(50) index by pls_integer;
    v_aa1 t_aa := t_aa(1 => 'hello', 2 => 'world', 3 => '!');
begin
    dbms_output.put_line(v_aa1(1) || v_aa1(2) || v_aa1(3));
end;







--Varray
declare
type foursome is varray(4) of varchar2(15);
    team foursome := foursome('John', 'Mary', 'Alberto');
begin
    for i in 1..4 loop
        dbms_output.PUT_LINE(team(i));
        if team(i) is null then
            dbms_output.PUT_LINE('element ' || i || ' is null');
        end if;
        end loop;
    dbms_output.PUT_LINE(team.count);
end;


--Omdat 4 basically leeg is
declare
type foursome is varray(4) of varchar2(15);
    team foursome := foursome('John', 'Mary', 'Alberto');
begin
    team(4):='sadge';
    dbms_output.PUT_LINE(team.count);
end;

--Dus dan moet je het extenden
declare
type foursome is varray(4) of varchar2(15);
    team foursome := foursome('John', 'Mary', 'Alberto');
begin
    team.extend;
    team(4):='sadge';
    dbms_output.PUT_LINE(team.count);
end;

declare
type foursome is varray(4) of varchar2(15);
    team foursome := foursome('John', 'Mary', 'Alberto', null);
begin
--    team.extend;
    team(4):='sadge';
    dbms_output.PUT_LINE(team.count);
end;


declare
type testarr is varray(4) of varchar2(15);
    team testarr := testarr('John', 'Mary', 'Alberto', 'Jesus christ');
begin
    team(1):='Sameer';
    for i in 1..team.count loop
        dbms_output.PUT_LINE(team(i));
        if team(i) is null then
            dbms_output.PUT_LINE('element ' || i || ' is null');
        end if;
        end loop;
    dbms_output.PUT_LINE(team.count);
end;


declare
type testarr is varray(4) of varchar2(15);
    team testarr := testarr('John', 'Mary', 'Alberto', 'Jesus christ');
begin
    team:=testarr('sameer', 'shaun', null, 'Trisha');
--     dbms_output.put_line(team.first);
    for i in 1..team.count loop
        dbms_output.put_line(team(i));
        if team(i) is null then
            dbms_output.PUT_LINE('what');
        end if;
        end loop;
end;


--Je collection moet eerst initialized zijn voor je een reference ernaar mag maken
--Btw als het uninitialized is dan is die array itself null
declare
    type test is varray(5) of varchar2(20);
    team test;--:=test(); --uncomment this for it to work
begin
dbms_output.put_line(team.count);
end;

declare
    type test is varray(5) of varchar2(20);
    team test :=test('sameer'); --uncomment this for it to work
begin
    for i in 1..2 loop
        dbms_output.PUT_LINE(team(i));
        end loop;
end;

--Zo mag je ook een type declareren voor je varray
declare
    type test is varray(5) of employees.first_name%type;
begin
    dbms_output.put_line('test');
end;

--Gaat ook voor je associative array(both ways nog erbij)
declare
    type test is table of employees.last_name% type index by employees.first_name%type;
begin
    dbms_output.put_line('test');
end;





--------------Nested table

declare
    type t_locations is table of varchar2(100);
    loc t_locations;
begin
    loc:=t_locations('USA', 'UK', 'JAP');

    for i in 1..loc.count loop
        dbms_output.put_line(loc(i));
        end loop;
end;

declare
    type t_locations is table of varchar2(100);
    loc t_locations;
begin
    loc:=t_locations('USA', 'UK', 'JAP');

    for i in loc.first..loc.count loop
        dbms_output.put_line(loc(i));
        end loop;
end;


declare
    type t_locations is table of varchar2(100);
    loc t_locations;
begin
    loc:=t_locations('USA', 'UK', 'JAP');
    loc.extend;
    loc(4):='Can';
    for i in loc.first..loc.count loop
        dbms_output.put_line(loc(i));
        end loop;
end;


--Nested table heeft je delete function meer opties
--Nu is bij index 3 daar basically leeg dus krijg je no data found error
--Extend zet eentje aan het eind so u cant fill the gap like that
declare
    type t_locations is table of varchar2(100);
    loc t_locations;
begin
    loc:=t_locations('USA', 'UK', 'JAP');
    loc.extend;
    loc(4):='Can';
    loc.delete(3);
    loc.extend;


    dbms_output.put_line(loc(5));

--     for i in loc.first..loc.count loop
--         dbms_output.put_line(loc(i));
--         end loop;
end;


declare
    type t_locations is table of varchar2(100);
    loc t_locations;
begin
    loc:=t_locations('USA', 'UK', 'JAP');
    loc.extend;
    loc(4):='Can';
    loc.delete(3);
    loc.extend;
    loc(3):='SUR';

    dbms_output.put_line(loc.count);

    for i in loc.first..loc.count loop
        dbms_output.put_line(loc(i));
        end loop;
end;

--Using nested table in sql itself
--Dont do this lmfao
create or replace type t_tel as table of number;

create table t_customer(
    cust_id number,
    cust_name varchar2(100),
    cust_tel t_tel
)
nested table cust_tel store as t_cust_tel;

insert into t_customer(cust_id, cust_name, cust_tel)values (1, 'sam', 0589877);



--je type van je array moet ook hetzelfde zijn
declare
    type triplet is varray(3) of varchar2(15);
    type trio is varray(3) of varchar2(15);
    group1 triplet := triplet('Jones', 'Wong', 'Marceau');
    group2 triplet;
    group3 trio;
begin
    group2 := group1; -- succeeds
    group3 := group1; -- fails
end;

--You cannot compare associative arrays to each other or to null
declare
    type test is table of number index by varchar2(100);
    arr_one test;
    arr_two test;
begin
  arr_one('sameer'):=21;
  arr_two('sameer'):=21;
  
  if arr_one=arr_two then
      dbms_output.put_line('test');
  end if;
  
 dbms_output.put_line(sys.diutil.BOOL_TO_INT(arr_one=arr_two));
end;

--varrays kunnen niet vergeleken worden met elkaar(wel met null)
declare
    type test is varray(20) of varchar2(15);

    arr_one test:=test(10,20);
    arr_two test:=test(10,20);
begin
   if arr_one is not null then
       dbms_output.put_line('test');
   end if;

   if arr_two=arr_one then
       dbms_output.put_line('test');
   end if;
end;



--Two nested table variables are equal if and only if they have the same set of elements (
-- in any order).
-- If two nested table variables have the same nested table type, and that nested table
-- type does not have elements of a record type,
-- then you can compare the two variables for equality
-- or inequality with the relational operators equal (=) and not equal (<>, !=, ~=, ^=).
declare
    type test is table of number;

    myArrOne test:=test(10, 20, 30, null);
    myArrTwo test:=test(10, 30, 20);

begin
    if myarrone = myarrtwo then
        dbms_output.put_line('you can compare nested tables');
    else
        dbms_output.put_line('they''re not equal');
    end if;
end;






--Methods
--Delete
--Bij associative array kan het alle 3 mogelijkheden van delete
--dus alle elementen
--de index van de element
--de range aangeven
declare
    type test is table of number
    index by varchar2(20);
    l_index varchar2(200);
    l_test1 test:=test('Sameer'=>20, 'Man'=>69, 'Sameer2'=>20, 'A'=>50, 'B'=> 70, 'C'=>90);
begin
--     l_test1.delete(); --alle elementen
--     l_test1.delete('Sameer'); --de index van de element
    l_test1.delete('A', 'C'); --de range van de element

    l_index:=l_test1.first;
    while l_index is not null loop
        dbms_output.put_line(l_index || ' his age is: ' || l_test1(l_index));
        l_index:=l_test1.next(l_index);
    end loop;
end;

--Bij varray kan je alleen alle elementen weghalen
declare
    type test is varray(20) of number;
    myArr test:=test(20, 30, 40);
begin
     myarr.delete; --gaat
--      myarr.delete(20); --gaat niet
--     myarr.delete(20, 30); --gaat ook niet

    for i in myarr.first..myarr.last loop
        dbms_output.put_line(myarr(i));
        end loop;
end;


--Bij nested table kan je ook alle 3 doen
-- For these two forms of DELETE, PL/SQL keeps placeholders for the deleted
-- elements. Therefore, the deleted elements are included in the internal size of the
-- collection, and you can restore a deleted element by assigning a valid value to it.

declare
    type test is table of number;
    l_test1 test:=test(10,20,39, 40, 60, 65);
begin
--     l_test1.delete;
--     l_test1.delete(1);
    l_test1.delete(1, 3);
    l_test1.delete(2);
    l_test1(2):=0;

     --dbms_output.put_line(l_test1(2)); -- als je element 2 hebt delete en dit print dan krijg
                                        --krijg je error omdat er niets daar is

--     if l_test1.first is null then
--         dbms_output.put_line('dat shit is null');
--     end if;
--      for i in l_test1.first..l_test1.last loop
--         dbms_output.put_line(l_test1(i));
--         end loop;
end;






--Trim
/*TRIM operates on the internal size of a collection. That is, if DELETE deletes an element but
keeps a placeholder for it, then TRIM considers the element to exist. Therefore, TRIM can
delete a deleted element.
PL/SQL does not keep placeholders for trimmed elements. Therefore, trimmed elements are
not included in the internal size of the collection, and you cannot restore a trimmed element
by assigning a valid value to it.*/
--werkt alleen op varray en nested tables
declare
    type test is table of number;
    l_test1 test:=test(10,20,39, 69);
begin
    l_test1.trim(2); --haalt (n) elementen weg
    l_test1.trim; --haalt de laatste element weg
        for i in l_test1.first..l_test1.last loop
        dbms_output.put_line(l_test1(i));
        end loop;
end;


--Since het die hele value nuked you cant assign a value to the index again
declare
    type test is table of number;
    l_test1 test:=test(10,20,39);
begin
    l_test1.trim(1);
    l_test1(3):=40;
    for i in l_test1.first..l_test1.last loop
        dbms_output.put_line(l_test1(i));
        end loop;
end;

--Kijk als je delete kan je opnieuw een value ertoe assignen
declare
    type test is table of number;
    l_test1 test:=test(10,20,39);
begin
    l_test1.delete(3);
    l_test1(3):=40;
    for i in l_test1.first..l_test1.last loop
        dbms_output.put_line(l_test1(i));
        end loop;
end;


--Extend
declare
type test is table of number;
l_test1 test:=test(30);
begin
    l_test1.extend; --appends one null element to the collection
   l_test1.extend(2); --appends 2 null elements to the collection
   l_test1.extend(2, 1); --EXTEND(n,i) appends n copies of the ith element to the collection.
    for i in l_test1.first..l_test1.last loop
        dbms_output.put_line((nvl(to_char(l_test1(i)), 'null')));
        end loop;
end;

declare
    type test is table of number;
    l_test1 test:=test(10,20,39);
begin
    
    dbms_output.put_line(
        sys.diutil.BOOL_TO_INT(l_test1.exists(1))
        );
    --1 vorm waarbij het gewoon letterlijk chekt of er een value bij die index is
    --als je een index out of range gaat ie false geven
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_test1.exists(20)));
    dbms_output.put_line(sys.diutil.BOOL_TO_INT(l_test1.exists(3)));
    end;


declare
    type test is table of number;
    l_test1 test:=test(10,20,39);
begin
    l_test1.delete(3);
    dbms_output.put_line(l_test1.last);
end;


declare
    type team_type is varray(4) of varchar2(15);
    team team_type;
    procedure print_team(heading varchar2)
        is
    begin
        dbms_output.put_line(team.count);
        dbms_output.put_line(heading);
        if team is null then
            dbms_output.put_line('Does not exist');
        elsif team.first is null then
            dbms_output.put_line('Has no members');
        else
            for i in team.first..team.last
                loop
                    if team(i) is null then
                        dbms_output.put_line('element ' || i || ' is null.');
                    end if;
                    dbms_output.put_line(i || '. ' || team(i));
                end loop;
        end if;
        dbms_output.put_line('---');
    end;

begin
    team := team_type('John', null); -- Put 2 members on team.
    print_team('----');
    end;
/


declare
    type test is table of number;
    l_test1 test:=test(10,20,39);
    begin
    l_test1.delete(1);
    dbms_output.put_line(l_test1.count);
end;

declare
    type test is table of number index by varchar2(100);
    team_age test;
begin
    team_age('sameer'):=21;
    team_age('sameer2'):=23;
    team_age('sameer3'):=23;

    team_age.delete('sameer');
    dbms_output.put_line(team_age.count);
end;



declare
    type test is varray(4) of number;
    l_test1 test:=test(10,20,39);
    begin

--     l_test1.extend;
    dbms_output.put_line(l_test1.count);
end;


declare
type test is table of number;
l_test1 test:=test(10,20,39);
begin
    l_test1.delete(3);

    for i in l_test1.first..l_test1.last loop
            dbms_output.put_line(l_test1(i));
        end loop;
end;


--------Limit voor een associative array(doesnt work unless u index by a pls_integer)
declare
    type test is table of number index by varchar2(20);
    l_test1 test;
    begin
        l_test1('sameer'):=20;
        dbms_output.put_line(l_test1('sameer'));
        
        if l_test1.limit is null then
            dbms_output.put_line('shit');
        end if;
--         dbms_output.put_line(l_test1.limit);
end;

--Limit werkt properly op een varray want dat alleen kan een limiet hebben
declare
    type test is varray(200) of varchar2(20);
   l_test1 test:=test();
    begin
        dbms_output.put_line(l_test1.limit);
end;


--Werkt ook op een nested table but prints null
declare
    type test is table of number;
    l_test1 test:=test(10,20,39);
begin
    dbms_output.put_line(l_test1.limit);
    if l_test1.limit is null then
        dbms_output.put_line('the limit of l_test_1 is null');
    end if;
end;

--Even if the datatype is varchar
declare
    type test is table of varchar2(50);
    l_test1 test:=test('sameer', 'jasmine');
begin
    dbms_output.put_line(l_test1.limit);
    if l_test1.limit is null then
        dbms_output.put_line('the limit of l_test_1 is null');
    end if;
end;

--Limit on a associative array bc the index is pls_integer
declare
    type aa_type is table of integer index by pls_integer;
    aa aa_type; -- associative array
begin
    aa(1) := 3; aa(2) := 6; aa(3) := 9; aa(4) := 12;
    dbms_output.put('aa.COUNT = ');
    dbms_output.put_line(nvl(to_char(aa.count), 'NULL'));
    dbms_output.put('aa.LIMIT = ');
    dbms_output.put_line(nvl(to_char(aa.limit), 'NULL'));
end;
/

--Als je index een varchar is dan werkt limit niet op je associative array
declare
    type test is table of integer index by pls_integer;
    l_test1 test;
    begin
        l_test1(69):=20;

        dbms_output.put_line(nvl(to_char(l_test1.limit), 'NULL'));
--         if l_test1.limit is null then
--             dbms_output.put_line('shit');
--         end if;
-- --         dbms_output.put_line(l_test1.limit);
end;






--------------------Prior and next methods----------------

--on an associative array indexed by pls_integer
declare
    type test is table of number index by pls_integer;
    l_test1 test;
begin
    l_test1(1):=10;
    l_test1(2):=20;
    l_test1(3):=30;
    
    --dbms_output.put_line(l_test1.next(4));
    dbms_output.put_line(l_test1.prior(999));
    dbms_output.put_line(nvl(to_char(l_test1.next(4)), 'woops'));
    dbms_output.put_line(l_test1.next(-40));
    
    end;

--on an associative array indexed by varchar2
declare
    type test is table of number index by varchar2(20);
    l_test1 test:=test('C'=>30, 'D'=>40);
begin
    dbms_output.put_line(l_test1.next('A'));
    dbms_output.put_line(l_test1.prior('Z'));
    dbms_output.put_line(nvl(l_test1.prior('C'), 'what'));
end;

--on a varray
declare
    type test is varray(4) of number;
    l_test1 test:=test(10, 20, 30, 40);
begin
    dbms_output.put_line(l_test1.next(-999));
    dbms_output.put_line(l_test1.prior(999));
end;


--On a nested table
declare
    type test is table of number;
    l_test1 test:=test(10,20,39);
begin
    dbms_output.put_line(l_test1.prior(9999));
    dbms_output.put_line(l_test1.next(-40));
end;


declare
    type test is table of number index by pls_integer;
    l_test1 constant test:=test(10=>100);
begin
    dbms_output.put_line('shoit');
end;


--You can query a goddamn collection only if its created ar schema level or declared in a
-- package
--Alleen nested table en varray kunnen at schema level, alhoewel associative array wel
-- in een package kan
-- The data type of the collection element is either a scalar data type, a user-defined
-- type, or a record type.

create or replace package pkg_test as
    type myarraytype is varray(20) of varchar2(20);
    type rec is record(f1 number, f2 varchar2(30));
    type mytab is table of rec index by pls_integer;
 end;

declare
    myarray pkg_test.myarraytype:=pkg_test.myarraytype(20, 30, 40);
    c1 sys_refcursor;
    v1 number:=20;
begin
    open c1 for select * from table(myarray);
    loop
        fetch c1 into v1;
        exit when c1%notfound;
        dbms_output.put_line(v1);
        end loop;
    close c1;
end;


--Looping over a table of records
--select on a record
declare
    myarray pkg_test.mytab := pkg_test.mytab(1 => pkg_test.rec(F1 => 20, F2 => '30'), 2=> pkg_test.rec(F1 => 40, F2 => '80'));
    c1 sys_refcursor;
    myrec pkg_test.rec := pkg_test.rec(null, null);
    v1 pkg_test.rec;
    l_counter number:=0;
begin
    open c1 for select * from table(myarray);
    loop
    fetch c1 into v1;
    exit when c1%notfound;
    l_counter:=l_counter+1;

     dbms_output.put_line(myarray(l_counter).f1);
    end loop;
end;
/

/*
declare

begin
    dbms_output.put_line();
end;*/
