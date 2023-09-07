When necessary, PL/SQL offers many ways to qualify an identifier so that a reference
to the identifier can be resolved. Using packages, for example, you can create variables
with global scope. Suppose that I create a package called company_pkg and declare a
variable named last_company_id in that package’s specification, as follows:
PACKAGE company_pkg
IS
 last_company_id NUMBER;
 ...
END company_pkg;

Then, I can reference that variable outside of the package, as long as I prefix the identifier
name with the package name:
IF new_company_id = company_pkg.last_company_id THEN


By default, a value assigned to one of these package-level variables persists for the du‐
ration of the current database session; it doesn’t go out of scope until the session dis‐
connects.







## Pragma: 
- It cannot be 0 or any positive number besides 100.
- It cannot be a negative number less than −1000000.
- • It cannot be −1403 (one of the two error codes for NO_DATA_FOUND). If for
some reason you want to associate your own named exception with this error, you
need to pass 100 to the EXCEPTION_INIT pragma

## Raise application error
- When u run this, execution of the current plsql block is halted immediately and
  any changes made to out or in arguments(if present and with the nocopy hint) will be 
reversed.
- Changes made to global data structures such as packaged variables and tables and stuff
will not be rolled back. 



## Unhandled exception:
- Als je exception ungehandled blijft dan bepaalt de tool dat je gebruikt wat er bv gebeurt met je transactie
Like does it get committed or rollbacked. SQLPlus gaat het rollbacken


##
- laatste stuff
26.6