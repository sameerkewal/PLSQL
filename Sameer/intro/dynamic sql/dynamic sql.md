Before passing a SQL cursor number to the DBMS_SQL.TO_REFCURSOR function, you must OPEN,
PARSE, and EXECUTE it (otherwise an error occurs).
After you convert a SQL cursor number to a REF CURSOR variable, DBMS_SQL operations can
access it only as the REF CURSOR variable, not as the SQL cursor number. For example, using
the DBMS_SQL.IS_OPEN function to see if a converted SQL cursor number is still open causes
an error.