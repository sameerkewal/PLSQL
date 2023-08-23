# PLSQL Compiler:
- Optimizer is enabled by default
- If overhead of the optimizer makes compilation of very large apps too slow, you can lower it by
setting the compilation parameter plsql_optimize_level instead of its default value of 2.
- In rarer cases, plsql might raise an exception earlier than expected or not at all
- Setting PLSQL_optimize_level=1 prevents the code from being rearranged. 

When the inline pragma precedes a declaration, it affects:
- Every invocation of the specified subrprogram in that declaration
- Every initialization value in that declaration except the default initialization values of records


## PLSQL_CODE_TYPE:
- if a plsql library unit is compiled native, all subsequent automatic recompilations
of that library unit will use native compilation. 
- Maar als je het manaully verandert naar interpreted dan blijft ie ook daarop(obvious)



## PLSQL_WARNINGS:
- Kinda logisch maar als je die parameter verandert en daarna opnieuw
compiled het automatisch die nieuwe value gaat nemen