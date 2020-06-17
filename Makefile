cake_lpr_array: basis_ffi.c lpr_array.S
	gcc basis_ffi.c lpr_array.S -o cake_lpr_array

clean:
	rm -fv cake_lpr_array
