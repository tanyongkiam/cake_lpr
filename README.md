# cake_lpr and cake_lsr

**NOTE: This branch is undergoing development.**

The `cake_lsr` is a new tool implementing LSR proof checking using CakeML and its associated toolchains (https://cakeml.org/).

## News

**(1 Nov 2026):** First draft version of the LSR proof checker (binary only).

## Instructions

Running `make` will build the proof checker `cake_lsr` for the host machine: `cake_lsr.S` on x64 machines and `cake_lsr_arm8.S` on ARMv8 machines (e.g., Apple silicon Macs).

Running `cake_lsr` with no arguments will print its help string.

```
cake_lsr

Version details:
Sun Nov 01 05:45:03 2026 UTC

CakeML: 530b75baec6436287ff7573419d83538f0ba8477
HOL4:   9783a49979c94c401ff8c0e51b2eefae7ea95ae3
PolyML: Poly/ML 5.9 Release    RTS version: X86_64-5.9 (Git version v5.9-1-g39d96a2d)



Usage:  cake_lsr [--] <CNF formula file> <optional: LSR proof file>
        cake_lsr --dump [--] <CNF formula file>

Run LSR unsatisfiability proof checking.
The proof is read from the proof file if one is given, and from standard input otherwise.
--dump parses the formula file and prints the formula.
```

It is possible to configure `cake_lsr`'s heap/stack usage.
This is required because CakeML fully manages its own memory in a formally verified way.
To expose these options, run `cake_lsr --h`.

```
./cake_lsr --h
usage: ./cake_lsr [--CML_HEAP_SIZE=<n>] [--CML_STACK_SIZE=<n>] [--h] <program arguments ...>

This help message is printed by the C wrapper (basis_ffi.c) hosting the
CakeML program. It documents the wrapper's own flags only; it is NOT the
help for the underlying program itself, which receives all remaining
arguments unchanged.

  --CML_HEAP_SIZE=<n>   set the CakeML heap size to <n> MiB (default: 4096)
  --CML_STACK_SIZE=<n>  set the CakeML stack size to <n> MiB (default: 4096)
  --h                   print this wrapper help message and exit
```

The default heap/stack sizes are 4096 MiB each. To change them (in MiB), pass the following flags, e.g., as follows:

```
./cake_lsr --CML_HEAP_SIZE=4000 --CML_STACK_SIZE=4000
```

Alternatively, change the defaults at compile time, e.g., `make -B CFLAGS="-O2 -DCML_HEAP_SIZE=65536 -DCML_STACK_SIZE=16384"` (`-B` forces a rebuild), or modify the default values of `CML_HEAP_SIZE` and `CML_STACK_SIZE` in `basis_ffi.c`.

## Implementation Details

- The tool (currently) supports binary-only proofs and aims to be compatible with both the standard LRAT binary format and the LSR binary format (https://github.com/ccodel/dsr-trim).

  More specifically, an addition line starts with either `a` (byte `0x61`) or the byte `0x03` and the rest of the line as usual in the variable byte encoding for LRAT/LPR/LSR (id, clause/witness, 0, hints, 0).
  A deletion line starts with `d` (byte `0x64`) followed by a list of IDs to delete then 0.
  It also supports the variant used in `dsr-trim` which starts with the byte `0x04` followed by the line ID, before the IDs to be deleted; the line ID is ignored by `cake_lsr`.

- There is one important format incompatibility for hints.
  Consider an LRAT/LPR/LSR step which has a witness substitution (mapping variables to literals or true/false) and not refuted by the global hints.
  In general, this requires a walk over each clause in the database.

  - If all literals in the clause are either unmapped or mapped to true, the clause can be skipped.

  - This leaves the "touched" clauses where at least one literal in it is mapped to false or to a different literal (SR).
    ALL of these clauses require a group of hints (`-id ...`) in the stricter variant implemented by `cake_lsr`.

  - In particular, `cake_lsr` does NOT allow skipping touched clauses where the trail satisfies the clause after substitution. This includes:
    
    1) touched clauses where the substitution maps at least one literal to true (hence it is trivially satisfied), but also has other literals touched by the substitution (mapped to false or to a different literal);
    
    2) touched clauses which are not trivially satisfied, but where the trail satisfies the substituted clause.

- Minor incompatibilities. First, in each line the group of hints (`-id1 ... -id2 ... 0`) must name each `id` only once. Second, clauses in the input formula which are tautologies (containing a literal and its negation) are considered deleted.

---

**The original README for `cake_lpr` is reproduced as-is below (some parts outdated). At the moment `cake_lpr` is kept in the release for backwards compatibility (some other files have been removed but remain in git history). However, this text may be removed in the future.**

**See tag: https://github.com/tanyongkiam/cake_lpr/releases/tag/cake_lpr/v1.0.0**

---

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
