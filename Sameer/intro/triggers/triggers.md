## Instead of trigger:
- DML trigger created on a noneditioning view or a nested table column of a noneditioning view
- System trigger defined on a create statement

## Conditional trigger:
- has a when clause that specifies an sql condition that the db evaluates for each row
that the triggering statement affects. 

## Crossedition trigger:
- A DML trigger for use only in edition-based redefinition


## System trigger:
- Trigger created on a schema or the database, then the triggering event
is composed of either ddl or database operation statements, and the trigger is called
a system trigger. 

## DML trigger:
- Trigger created on a table or view then the triggering event is composed of DML
statements, and the trigger is called a DML trigger. 





## Instead of trigger:
- kan old en new values lezen but cannot change them
- an instead of trigger with the nested table clause fires only if the triggering statement
operates on the elements of the specified nested table column of the view. The trigger fires
for each modified nested table element




## Compound DML trigger:
- Old new and parent cannot appear in the declarative part, the before or after statement section
- Only the before each row can change the value of new
- Je kan je old variable nooit veranderen
- Timing point section cannot handle exceptions raised in other timing point section
- If a timing point section has a goto statement, the target of the goto statement must be in the same
timing point


## Pseudo-records:
- A pseudorecord cannot appear in a record-level operation.
For example, the trigger cannot include this statement:
:NEW := NULL;
- Cannot be a subprogram parameter, alleen die field kan een subprogram parameter zijn




## System triggers:
- is created on either the schema or the database
- Kan either getriggered worden door ddl of door database operation statements
- Kan before statement, after statement, instead of trigger


## Database triggers:
- Created on the db and fires whenever any database user initiates the triggering event







- If a trigger references another object and that object is modified or dropped, then the trigger becomes invalid.
The next time the triggering event occurs, the compiler tries to revalidate the trigger. 
- Als een trigger een subprogram met IR rechten invoken then the user who created the trigger is considered to be the current user(invoker ig)

Usually if an exception occurs then the db rolls back both the fx of both the trigger and the triggering
statement. 
In the following case only the fx of the trigger is rolled back but not the fx of the triggering statement:
- The triggering event is after startup on db or before shutdown on db
- The triggering event is after logon on db and the user has the administer database trigger
- The triggering event is after logon on schema and the user either owns the schema or has
the alter any trigger privilege


- If you are creating two or more triggers with the same timing point, and the order in
which they fire is important, then you can control their firing order using the FOLLOWS
and PRECEDES clauses (see "FOLLOWS | PRECEDES")
 

- When one trigger causes another trigger to fire, the triggers are said to be cascading.
The database allows up to 32 triggers to cascade simultaneously. To limit the number
of trigger cascades, use the initialization parameter OPEN_CURSORS (described in Oracle
Database Reference), because a cursor opens every time a trigger fires.


## When clause:
- Mag niet in een statement level trigger
- Not in an instead of trigger
- Als je het voor een serverror doet dan moet je condition zijn: `errno=error_code`
- Mag wel in schema triggers