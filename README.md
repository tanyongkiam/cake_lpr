# cake_lpr
This repository contains pre-compiled versions of LPR proof checkers produced using the CakeML compiler and associated toolchains (https://cakeml.org/).

Source and proof files are available in the main CakeML repository (https://github.com/CakeML/cakeml/tree/master/examples/lpr_checker)

The file `cake_lpr.S` is built from the following repository versions

```
HOL4: f4896684a972fcd114e6710e022950aedefd0366

CakeML: e7a5c005596708fcf02ba333f849a5ae1eefdf8a
```

# Instructions

Running `make` will build the the proof checker `cake_lpr`

This help string is printed to stdout when `cake_lpr` is run with no arguments:

```
Usage:  cake_lpr <DIMACS formula file>
Parses the DIMACS file and prints the parsed formula.

Usage:  cake_lpr <DIMACS formula file> <LPR proof file>
Run LPR unsatisfiability proof checking

Usage:  cake_lpr <DIMACS formula file> <LPR proof file> <DIMACS transformation file>
Run LPR transformation proof checking

Usage:  cake_lpr <DIMACS formula file> <summary proof file> i-j <LPR proof file>
Run two-level transformation proof checking for lines i-j

Usage:  cake_lpr <DIMACS formula file> <summary proof file> -check <output file>
Check that output intervals cover all lines of summary proof file

```

# Examples

- Running the checker with a CNF file and an LPR proof: `./cake_lpr example.cnf example.lpr`

  Output (stdout):
  ```
  s VERIFIED UNSAT
  ```


- Running the checker with a CNF file and an incorrect LPR proof: `touch foo.lpr; ./cake_lpr example.cnf foo.lpr`


  Output (stderr):
  ```
  c empty clause not derived at end of proof
  ```
  
  Other errors are possible during LPR proof checking. These will all be reported on stderr.


- Running the checker with a CNF file only dumps the file (after parsing): `./cake_lpr example.cnf`

  Output (stdout):
  ```
  p cnf 12 22
  1 2 3 0
  4 5 6 0
  7 8 9 0
  10 11 12 0
  -1 -4 0
  -2 -5 0
  -3 -6 0
  ...
  ```

- It is possible for the checker to run out of stack/heap space on large proofs, e.g., with:

  Output (stderr):
  ```
  CakeML heap space exhausted.
  ```

- To increase heap/stack size, modify the default values of `cml_heap_sz` and `cml_stack_sz` in `basis_ffi.c`.

- Alternatively, set the environment variables, e.g., as follows:

  ```
  export CML_HEAP_SIZE=4000
  export CML_STACK_SIZE=4000
  ./cake_lpr example.cnf example.lpr
  ```
