cake_lpr: basis_ffi.c cake_lpr.S
	gcc basis_ffi.c cake_lpr.S -o cake_lpr

clean:
	rm -fv cake_lpr
