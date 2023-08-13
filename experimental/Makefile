all: cake_clpr cake_lpr_arm8

cake_clpr: ../basis_ffi.c cake_clpr.S
	gcc ../basis_ffi.c cake_clpr.S -o cake_clpr

# NOTE: this is only for cross-compilation.
# If you have an ARM machine, use your usual compilation toolchain
cake_lpr_arm8: ../basis_ffi.c cake_lpr_arm8.S
	aarch64-linux-gnu-gcc -static ../basis_ffi.c cake_lpr_arm8.S -o cake_lpr_arm8

clean:
	rm -fv cake_clpr cake_lpr_arm8
