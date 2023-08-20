### Package state:
- If the package declares atleast one variable, constant or cursor then the package is
stateful, otherwise it is stateless
- Each session that references a package item has its own instantiation of that package. If the
package is stateful, the instantiation includes its state.
- Package state persists for the life of the session, except in these situations
  - Package is SERIALLY_REUSABLE 
  - Package body is recompiled
  - Any of the session's instantiated packages are invalidated and revalidated


## SERIALLY_REUSABLE:
- Trying to access a SERIALLY_REUSABLE package from a database trigger, or from a
PL/SQL subprogram invoked by a SQL statement, raises an error



## Tips:
- If you change the package specification, you must recompile any subprograms
that invoke the public subprograms of the package. If you change only the
package body, you need not recompile those subprogramsiu
- Als je een initialization part hebt voor je package runned dat alleen de eerste keer dat
je je package referenced
