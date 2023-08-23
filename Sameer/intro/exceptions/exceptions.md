# Exceptions:


After an exception handler runs, control transfers to the next statement of the
enclosing block. If there is no enclosing block, then:
• If the exception handler is in a subprogram, then control returns to the invoker, at
the statement after the invocation.


![exception_categories.png](..%2Fresources%2Fexception_categories.png)

## Verschil tussen internally defined en predefined:
- Internally heeft alleen een naam if u assign it one
- Predefined heeft altijd een naam

## Tips:
- If you know that your database operations might raise specific internally defined
exceptions that do not have names, then give them names so that you can write
exception handlers specifically for them. Otherwise, you can handle them only with
OTHERS exception handlers.


- Predefined exceptions are internally defined exceptions that have predefined names, which
PL/SQL declares globally in the package STANDARD. The runtime system raises predefined
exceptions implicitly (automatically). Because predefined exceptions have names, you can
write exception handlers specifically for them(table 11-3 in book)


- Oracle recommends against redeclaring predefined exceptions—that is, declaring a
user-defined exception name that is a predefined exception name. (For a list of
predefined exception names, see Table 11-3.)
If you redeclare a predefined exception, your local declaration overrides the global
declaration in package STANDARD. Exception handlers written for the globally declared
exception become unable to handle it—unless you qualify its name with the package
name STANDARD


## Raise:
- The RAISE statement explicitly raises an exception. Outside an exception handler, you
must specify the exception name. Inside an exception handler, if you omit the
exception name, the RAISE statement reraises the current exception

- Although the runtime system raises internally defined exceptions implicitly, you can
raise them explicitly using the raise statement as long as they have names. 

  - In an exception handler, you can use the RAISE statement to"reraise" the exception being
handled. Reraising the exception passes it to the enclosing block, which can handle it further

- You can invoke the RAISE_APPLICATION_ERROR procedure (defined in the
DBMS_STANDARD package) only from a stored subprogram or method. Typically, you
invoke this procedure to raise a user-defined exception and return its error code and
error message to the invoker.

- You must have assigned error_code to the user-defined exception with the EXCEPTION_INIT
pragma.
The error_code is an integer in the range -20000..-20999 and the message is a character
string of at most 2048 bytes


- A user-defined exception can propagate beyond its scope (that is, beyond the block that
declares it), but its name does not exist beyond its scope. Therefore, beyond its scope, a
user-defined exception can be handled only with an OTHERS exception handler.

- An exception raised in a declaration propagates immediately to the enclosing block (or
to the invoker or host environment if there is no enclosing block). Therefore, the
exception handler must be in an enclosing or invoking block, not in the same block as
the declaration.

- If a stored subprogram exits with an unhandled exception, PL/SQL does not roll back
database changes made by the subprogram.


## Retrieving Error code and Error msg:
- You can retrieve the error message with either:
– The PL/SQL function SQLERRM, described in "SQLERRM Function"
This function returns a maximum of 512 bytes, which is the maximum length of an
Oracle Database error message (including the error code, nested messages, and
message inserts such as table and column names)