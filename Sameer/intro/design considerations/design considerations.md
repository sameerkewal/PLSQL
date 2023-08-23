Standardizing exception handling example: Consider writing a subprogram for common exception handling
to:
Display errors based on SQLCODE and SQLERRM values for exceptions
Track run-time errors easily by using parameters in your code to identify:
The procedure in which the error occurred
The location (line number) of the error
RAISE_APPLICATION_ERROR using stack trace capabilities, with the third argument set to TRUE


## Inherit privileges
 The INHERIT PRIVILEGES privilege is a way to control the privileges of invoker’s rights procedures and 
 functions in Oracle. It allows the owner of the procedure or function to inherit the privileges of 
 the user who invokes it. 
 This can prevent privilege escalation or unauthorized operations by malicious code.
 


## Autonomous Transaction:
- Changes made by an AT are visible if isolation level is set to read committed(the default)
- If isolation level of MT is set to serializable changes made by AT are not visible to MT when it resumes
- Transaction properties are only visible to that transaction itself
- Cursor attributes are not affected by Autonomous Transactions
- Allowed in a:
  - Schema level(not nested) anonymous block
  - Standalone, package or nested subprogram
  - Method of ADT
  - Noncompound trigger


## Parallel enable:
- Can only appear once in the function
- Must not use session state, such as package variables, bc those are not necessarily shared among
the parallel execution servers. 

## Deterministic Clause:
- Specify this keyword if u intend to invoke this function in:
  - The expression of a function based index
  - A virtual column definition
  - From the query of a materialized view that is marked refresh fast or enable query rewrite
- Specifying this clause for a polymorphic table function is not allowed

- Good practice to use them in the following place:
  - Functions used in a group by, where or group by clause
  - Functions that map or order methods of a sql type
  - Functions that help determine whether a row will appear in a result set





## Bulk SQL and Bulk Binding
- Bulk SQL minimizes the performance overhead of the communication between SQL and PL/SQL.
- Assigning values to PL/SQL variables that appear in SQL statements is called binding

- The FORALL statement sends DML statements from PL/SQL to SQL in batches rather
than one at a time

- The BULK COLLECT clause returns results from SQL to PL/SQL in
batches rather than one at a time

- If a query or DML statement affects four or more
database rows, then bulk SQL can significantly improve performance.

- Parallel DML is disabled with bulk SQL
- cannot perform bulk SQL on remote tables

- The DML statement in a FORALL statement can reference multiple collections, but
performance benefits apply only to collection references that use the FORALL index
variable as an index.

- To allow a forall stmt to continue even if some of its dml statements fail, include the save
exceptions clause.

- After the FORALL statement completes, PL/SQL
raises a single exception for the FORALL statement (ORA-24381).
In the exception handler for ORA-24381, you can get information about each individual DML
statement failure from the implicit cursor attribute SQL%BULK_EXCEPTIONS.


## Bulk collect:
The BULK COLLECT clause, a feature of bulk SQL, returns results from SQL to PL/SQL
in batches rather than one at a time.
The BULK COLLECT clause can appear in:
- SELECT INTO statement
- FETCH statement
- RETURNING INTO clause of:
- DELETE statement
- INSERT statement
- UPDATE statement
- EXECUTE IMMEDIATE statement