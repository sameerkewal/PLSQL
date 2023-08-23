--How to display the dependent and references object types in your db if you are logged in as dba
select *
from dba_dependencies;


--Dit zijn ig types die een dependency kunnen hebben
select distinct type from dba_dependencies
order by type;


--Dit zijn die types die gereferenced worden
select distinct REFERENCED_TYPE
from user_dependencies;


select *
from user_dependencies;


