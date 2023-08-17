## Parameters:
- If the subprogram ends with an exception, then the value of the actual parameter
is undefined.
- Bij een in parameter kan je niet modifyen. Anw daar pass je dmv reference so probably remember that
- Bij out pass je bij value but could be using reference if u specify nocopy
- Bij een in out same thing as above, but also the value is passed in boh directions

## Granting roles to plsql package and standalone programs:
- Typically you grant roles to an IR unit, so users with lower privileges than
yours can run the unit with only the privileges needed to do so. 
- Typically you grant roles to an DR unit(whose invokers run it with all your privileges)
only if the DR unit issues dynamic sql, which is only checked at run time 

- If an IR unit issues static SQL statements, then the schema objects that these
statements affect must exist in the owner's schema at compile time(so the compiler can
resolve references) and it must exist in the invoker's schema at run time.
- The definitions of the schema objects must match(same names and columns). 
- The objects in the owner's schema dont need to contain any data bc the compiler doesn't
need it. Therefore they are called template objects. 
