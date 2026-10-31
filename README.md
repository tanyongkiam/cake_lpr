# cake_lpr
This repository contains pre-compiled versions of LPR proof checkers produced using the CakeML compiler and associated toolchains (https://cakeml.org/).

Source and proof files are available in the main CakeML repository (https://github.com/CakeML/cakeml/tree/master/examples/lpr_checker)

The files `cake_lpr.S` (x64) and `cake_lpr_arm8.S` (ARMv8) are built from the following repository versions

```
HOL4: 9783a49979c94c401ff8c0e51b2eefae7ea95ae3

CakeML: 665f9b21712ad093e10a404ccc2f78e64a34aeef
```

# News

**Final release (1 Nov 2026):** This is the last planned update of `cake_lpr`; it will soon be superseded by a new checker in this repository. Both checkers are rebuilt with the latest CakeML, and `basis_ffi.c` is now CakeML's standard wrapper for checkers. `make` auto-detects your architecture (x64 or ARMv8), so the `make cake_lpr_arm8` and `make starexec` targets are gone. For larger heap/stack, see options under Examples.

**New (22 Jul 2026):** Incompatibility: heap/stack sizes are no longer read from the `CML_HEAP_SIZE`/`CML_STACK_SIZE` environment variables; pass the command-line flags `--CML_HEAP_SIZE=<n>`/`--CML_STACK_SIZE=<n>` (in MiB) instead.

**New (16 Feb 2025):** Improved `cake_lpr` performance by around 5-10% and reduced its compiled binary size by around 20%.

**New (11 Mar 2024):** `cake_lpr` now natively supports LRAT/LPR proof files in binary format.

# Instructions

Running `make` will build the proof checker `cake_lpr` for the host machine: `cake_lpr.S` on x64 machines and `cake_lpr_arm8.S` on ARMv8 machines (e.g., Apple silicon Macs).

To check the files against the released checksums, run `sha256sum -c cake_lpr.sha256` (on macOS: `shasum -a 256 -c cake_lpr.sha256`).

This help string is printed to stderr when `cake_lpr` is run with no arguments:

```
cake_lpr can be invoked in several ways from the command line.

The LPR proof file can optionally be in binary format.

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

- The default heap/stack sizes are 4096 MiB each. To change them (in MiB), pass the following flags, e.g., as follows:

  ```
  ./cake_lpr --CML_HEAP_SIZE=4000 --CML_STACK_SIZE=4000 example.cnf example.lpr
  ```

  These flags are handled by the C wrapper (`basis_ffi.c`) and are not passed on to the checker; run `./cake_lpr --h` for the wrapper's help message.

- Alternatively, change the defaults at compile time, e.g., `make -B CFLAGS="-O2 -DCML_HEAP_SIZE=65536 -DCML_STACK_SIZE=16384"` (`-B` forces a rebuild), or modify the default values of `CML_HEAP_SIZE` and `CML_STACK_SIZE` in `basis_ffi.c`.
