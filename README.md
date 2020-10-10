# TACAS 2021 Artifact Evaluation

This branch contains the artifact for the submission

`cake_lpr: Verified Propagation Redundancy Checking in CakeML`

The standard build instructions for the tool `cake_lpr` can be found in this README (below).

To run the experiments, please read the respective READMEs in:

`experiments/sadical` (corresponds to Section 5.1)

`experiments/satrace2019` (corresponds to Section 5.2)

`experiments/pgbdd` (corresponds to Section 5.3)

To download this artifact, clone the repository as usual:

`git clone -b TACAS21 https://github.com/tanyongkiam/cake_lpr.git` 

Please email the authors if you have trouble with this artifact submission.

# cake_lpr

This repository contains pre-compiled versions of LPR proof checkers produced using the CakeML compiler and associated toolchains (https://cakeml.org/).

Source and proof files are available in the main CakeML repository (https://github.com/CakeML/cakeml/tree/master/examples/lpr_checker)

The file `cake_lpr.S` is built from the following repository versions

```
HOL4: 841cced433cd0e9e4913c6e9c05c9b7542e38a6b

CakeML: 018eec673b8b703adeecb85ccab09ec91be05cb3
```

# Instructions

Running `make` will build the the proof checker `cake_lpr`

This help string is printed to stdout when `cake_lpr` is run with no arguments:

```
Usage: cake_lpr <DIMACS formula file> <Optional: LPR proof file> \
                <Optional: Size of clause array (if proof file given)>
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

- Running the checker with CNF files and LPR proof and configuring the clause array size: `./cake_lpr example.cnf example.lpr 10000`

  Output (stdout):
  ```
  s VERIFIED UNSAT
  ```

  Note that the array is automatically grown (up to the heap limit) by the proof checker.

- Running the checker with CNF files and LPR proof and configuring the clause array size (too much will give an error): `./cake_lpr example.cnf example.lpr 1000000000`

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
