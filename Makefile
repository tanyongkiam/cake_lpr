cake_lpr_array: basis_ffi.c lpr_array.S
	gcc basis_ffi.c lpr_array.S -o cake_lpr_array

cake_lpr: basis_ffi.c lpr.S
	gcc basis_ffi.c lpr.S -o cake_lpr

cake_lpr_array_m: basis_ffi_m.c lpr_array_m.S
	gcc basis_ffi_m.c lpr_array_m.S -o cake_lpr_array_m -static

clean:
	rm -fv cake_lpr_array cake_lpr cake_lpr_array_m

