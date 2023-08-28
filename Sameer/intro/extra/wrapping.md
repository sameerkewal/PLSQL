# Wrapping:
- A wrapped file can be moved, backed up or processed by sqlplus or the import and export utilities. 
- To produce a wrapped file, either use the PL/SQL wrapper utility or the DBMS_DDL subprogram
- The wrapper utility wraps the source text of every wrappable PL/SQL unit created by a specified SQL file. 
- The DBMS_DDL subprograms wrap the source text of every single dynamically generated wrappable PL/SQL unit
- Triggers mogen niet gewrapped worden
- To hide the implementation details of a trigger, put them in a stored subprogram, wrap the subprogra, and write a one line trugger that invokes
the subprogram
- Wrap only the body of a package or type, not the specification. 
- Leaving the spec unwrapped allows other devs to see the info needed to use the package or type. Wrapping the body prevents them from seeing
the package or type implementation 
- You cannot edit wrapped files, if a wrpped file needs changes, u must edit the original unwrapped file and then wrap it again


- Both the wrapper utility and DBMS_ddl subprogram detect tokenization errors(
for example runaway strrings but not syntax or semantic errors(for example non existant tables))