# Loop:
- Do not use EXIT or EXIT WHEN statements within FOR and WHILE loops. You
should use a FOR loop only when you want to iterate through all the values (integer
or record) specified in the range. An EXIT inside a FOR loop disrupts this process
and subverts the intent of that structure. A WHILE loop, on the other hand, specifies
its termination condition in the WHILE statement itself.
- Do not use the RETURN or GOTO statements within a loop—again, these cause
the premature, unstructured termination of the loop. It can be tempting to use these
constructs because in the short run they appear to reduce the amount of time spent
writing code. In the long run, however, you (or the person left to clean up your
mess) will spend more time trying to understand, enhance, and fix your code over
time.

The FOR loop explicitly states: “I am going to execute the body of this loop n times”
(where n is a number in a numeric FOR loop, or the number of records in a cursor FOR
loop). An EXIT inside the FOR loop (line 12) short-circuits this logic. The result is code
that’s difficult to follow and debug.
If you need to terminate a loop based on information fetched by the cursor FOR loop,
you should use a WHILE loop or a simple loop in its place. Then the structure of the
code will more clearly state your intentions. 



# GOTO:
- At least one executable statement must follow a goto
- The target label must be in the same scope as the goto statement
- The target label must be in the same part of the plsql block as the goto statement