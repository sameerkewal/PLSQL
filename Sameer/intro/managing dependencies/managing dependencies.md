# Managing dependencies:

- CREATE statements automatically update all dependencies.
- Dynamic SQL statements do not create dependencies. 

- With **croase grained invalidation** a ddl statement that changes a referenced object
invalidates all of its dependents
- With **fine grained invalidation** a ddl statement that changes a referenced object
invalidates only dependents for which either of these statements is true
  - The dependent relies on the attribute of the referenced objects that the ddl
  statement changed.
  - The compiled metadata of the dependent is no longer correct for the changed
  referenced object. 


The ddl statement create or replace object has no effect under these conditions:
- Object is a plsql object, the new plsql source text is identical to the existing source text and the plsql compilation paramater
settings stored with object are identical to those in the session environment
- Object is a synonym and the statement does not change the target object

- The entry point number of a procedure or funciton is determined by its location
in the PL/SQL package code. A procedure or function added to the end of a plsql package
is given a new entry-point number. 

- When a privilege is granted to or revoked from a user or public, Oracle
invalidates all the owner's dependent objects, to verify that an owner of a dependent
object continues to have the necessary privileges for all referenced objects


- When adding items to a pkg, add them to the end of the pkg, which preserves the entry
point numbers of existing top level package items, preventing their invalidation 


## Dependencies among local and remote database proceures
- Dependencies among stored procedures(including functions, packages and triggers)
in a distributed database system are managed using either timestamp checking or signature
checking.
- Dynamic initialization parameter remote_dependencies_mode determines whether time stamps
or signatures govern remote dependencies. 

- Oracle db does not manage dependencies among remote schema objects other than
local-procedure to remote-procedure dependencies. 
- If DML statements precede the invalid call they roll back only if they and the invalid
call are in the same plsql block. 


## Signature stuff:
- An RPC signature is associated with each compiled stored program unit. It
identifies the unit by these characteristics
  - Name
  - Number of parameters
  - Data type class of each paramater
  - Mode of each paramater
  - Data type class of return value(for a function)
- An rpc signature does not include deterministic, parallel_enable or purity information.
If these settings change for a function on remote system,optimizations based on them are
not automatically reconsidered. Therefore, calling the remote function in a SQL statement
or using it in a function-based index might cause incorrect query results. 



- A compiled program unit contains the RPC signature of each remote procedure that it calls
(and the schema, package name, procedure name, and time stamp of the remote procedure)
- In RPC signature dependency mode, when the local program unit calls a subprogram
in a remote program unit. The database ignores time stamp mismatches and compares the rpc 
signature that the local unit has for the remote subporgram to the current rpc signature
of the remote subprogram. 

- Changing the body of a subprogram does not change the rpc signature of the subprogram
- changing data type of a parameter to another data type in the same class does not change
the RPC signature, but changing the data type to a data type in another class does

- Change the name of a package type, or the names of its internal components,
does not change the RPC signature of the package




  ## Remote dependencies mode:
- If the remote_dependencies_mode is not specified, either in the init.ora parameter
file or using the alter session or alter system statements, timestamp is the default value.


- When REMOTE_DEPENDENCIES_MODE=SIGNATURE, the recorded time stamp in the calling unit is
first compared to the current time stamp in the called remote unit. If they match,
the call proceeds. If the time stamps do not match, then the RPC signature of the called
remote subprogram, as recorded in the calling subprogram, is compared to the current
RPC siganture of the called subprogram. If they do not match then an error is returned. 