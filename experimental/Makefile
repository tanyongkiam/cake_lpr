all: cake_clpr

cake_clpr: ../basis_ffi.c cake_clpr.S
	gcc ../basis_ffi.c cake_clpr.S -o cake_clpr

clean:
	rm -fv cake_clpr
