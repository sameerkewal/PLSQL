- In a package specification, a package body, a type body, a schema-level function
and in a schema level procedure, at least one nonwhitespace plsql token must appear 
after the identifier of the unit name before a conditional compilation directive is valid. 


- In simpelere woorden na je unit name moet er een nonwhitespace token(bv authid of accessible by) zijn

- Die opening parentheses kan ook tellen als een nonwhitespace character
- Zo ook die comment characters


- In a trigger or anonymous block, the first cc directive cannot appear before the keyword declare or begin.
Whichever comes first.


## Code-based access control: granting roles to program units:
- A user of a definer's rights procedure requires only the privilege to execute the procedure and no privileges on 
the underlying objects that the procedure accesses. This is because a definer's rights procedure operates 
under the security domain of the user who owns the procedure, regardless of who is executing it. 


- A user of an invoker's rights procedure must have privileges (granted to the user either directly or through a role) 
on objects that the procedure accesses through external references that are resolved in the schema of the invoker. 
When the invoker runs an invoker's rights procedure, this user temporarily has all of the privileges of the invoker.


## Use invokers rights procedures in the following situation:
These situations are as follows:

- When creating a PL/SQL procedure in a high-privileged schema. 
When lower-privileged users invoke the procedure, 
then it can do no more than those users are allowed to do. 
In other words, the invoker's rights procedure runs with the privileges of the invoking user.

- When the PL/SQL procedure contains no SQL and is available to other users. 
The DBMS_OUTPUT PL/SQL package is an example of a PL/SQL subprogram that contains no SQL and is available to all users. 
The reason you should use an invoker's rights procedure in this situation is because the unit issues no SQL statements at 
run time, so the run-time system does not need to check their privileges. 
Specifying AUTHID CURRENT_USER makes invocations of the procedure more efficient, 
because when an invoker's right procedure is pushed onto, or comes from, 
the call stack, the values of CURRENT_USER and CURRENT_SCHEMA, and the currently enabled roles do not change.


- When a user runs an invoker's rights procedure, Oracle Database checks it to ensure that the procedure 
owner has either the INHERIT PRIVILEGES privilege on the invoking user, or if the owner has been granted the 
INHERIT ANY PRIVILEGES privilege


`GRANT INHERIT PRIVILEGES ON USER invoking_user TO procedure_owner;`
- invoking user is the user who runs the invokers rights procedure.
- procedure owner is the user who owns the invokers rights procedure. 

`GRANT INHERIT PRIVILEGES ON USER jward TO ebrown;`
- Enables any invokers rights procedure that ebrown writes, or will write to access jwards privileges
when jward runs it. 





- The following users or roles must have the INHERIT PRIVILEGES privilege granted to them by users 
who will run their invoker's rights procedures:
  - Users or roles who own the invoker's rights procedures
  - Users or roles who own BEQUEATH CURRENT_USER views