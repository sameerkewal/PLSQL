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