### SQL%rowcount is onafhankelijk van de state van een transaction.
- when a trans rolls back to a savepoint the value of sql%rowcount is not restored
to the value it had before the savepoint.
- When an autonomous trans ends, sql%rowcount is not restored to the original value
in the parent transaction

When an explicit cursor query includes a virtual column (an expression), that column must
have an alias if either of the following is true:
• You use the cursor to fetch into a record that was declared with %ROWTYPE.
• You want to reference the virtual column in your program.


### Cursor:
- If an explicit cursor is not open, referencing any attribute except %ISOPEN raises the
predefined exception INVALID_CURSOR.


%FOUND returns:
• NULL after the explicit cursor is opened but before the first fetch
• TRUE if the most recent fetch from the explicit cursor returned a row
• FALSE otherwise


## Cursor variable:
- Before you can reference a cursor variable, you must make it point to a SQL work area,
either by opening it or by assigning it the value of an open PL/SQL cursor variable or open
host cursor variable.
- Cursor variables and explicit cursors are not interchangeable—you cannot use one
where the other is expected. For example, you cannot reference a cursor variable in
a cursor FOR LOOP statement.

## Weak typed:
- Als je return type specified dan zijn je ref cursor type and cursor variable of that type
strong. 
- Anders zijn ze zwak. sys_refcursor and cursor variables of that type are weak.

- With a strong cursor variable, you can associate only queries that return the specified
type. With a weak cursor variable, you can associate any query

- You need not close a cursor variable before reopening it (
that is, using it in another OPEN FOR statement). 
After you reopen a cursor variable, the query previously associated with it is lost

When declaring a cursor variable as the formal parameter of a subprogram:
• If the subprogram opens or assigns a value to the cursor variable, then the
parameter mode must be IN OUT.
• If the subprogram only fetches from, or closes, the cursor variable, then the
parameter mode can be either IN or IN OUT.




## Autonomous Transaction:
- Cant apply it to a whole package or adt but you can use it in each subprohram of a package or each
method of an ADT.
- Mag niet in een nested block

- When you enter the executable section of an autonomous routine, the main transaction
suspends. When you exit the routine, the main transaction resumes.
If you try to exit an active autonomous transaction without committing or rolling back, the
database raises an exception. If the exception is unhandled, or if the transaction ends
because of some other unhandled exception, then the transaction rolls back


- You cannot run a PIPE ROW statement in an autonomous routine while an
autonomous transaction is open. You must close the autonomous transaction
before running the PIPE ROW statement. This is normally accomplished by
committing or rolling back the autonomous transaction before running the PIPE ROW
statement.
