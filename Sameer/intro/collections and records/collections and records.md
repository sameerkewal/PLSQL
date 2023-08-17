# Associative Array:
- Basically een hashmap, je index is je key
- Je index(key) kan een string type(varchar2, varchar, string, long) zijn of pls_integer
- Indexes are stored in sort order, not in insertion order
- does not need disk space or network operations
- Als je niets declared voor je index dan default het naar pls_integer

In the declaration of an associative array indexed by string, the string type must be
VARCHAR2 or one of its subtypes.
However, you can populate the associative array with indexes of any data type that the
TO_CHAR function can convert to VARCHAR2.



## Nested table
- It is a valid data type in sql(unlike associative arrays/varray)
- Can be stored in db

## a nested table differs from an array in these important ways:
- An array has a declared number of elements, but a nested table does not. The size of a
nested table can increase dynamically.
-  An array is always dense. A nested array is dense initially, but it can become sparse,
because you can delete elements from it.

## Comparison stuff:
- You cannot compare associative arrays to each other or to null
- Two nested table variables are equal if and only if they have the same set of elements (in any
order).
If two nested table variables have the same nested table type, and that nested table type
does not have elements of a record type, then you can compare the two variables for equality
or inequality with the relational operators equal (=) and not equal (<>, !=, ~=, ^=).

## Method stuff:
## TRIM: 
operates on the internal size of a collection. That is, if DELETE deletes an element but
keeps a placeholder for it, then TRIM considers the element to exist. Therefore, TRIM can
delete a deleted element.
PL/SQL does not keep placeholders for trimmed elements. Therefore, trimmed elements are
not included in the internal size of the collection, and you cannot restore a trimmed element
by assigning a valid value to it.

### Extend:
EXTEND is a procedure that adds elements to the end of a varray or nested table.

• EXTEND appends one null element to the collection.
• EXTEND(n) appends n null elements to the collection.
• EXTEND(n,i) appends n copies of the ith element to the collection.



## Exists: 
EXISTS is a function that tells you whether the specified element of a varray or nested
table exists.
EXISTS(n) returns TRUE if the nth element of the collection exists and FALSE otherwise.
If n is out of range, EXISTS returns FALSE instead of raising the predefined exception
SUBSCRIPT_OUTSIDE_LIMIT

### Limit:
LIMIT is a function that returns the maximum number of elements that the collection can
have. If the collection has no maximum number of elements, LIMIT returns NULL. Only a
varray has a maximum size.



## Records:
- kunnen niet getest worden voor nullity, equality of inequality