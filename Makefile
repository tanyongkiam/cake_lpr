# Default build
cake_lpr: basis_ffi.c cake_lpr.S
	gcc basis_ffi.c cake_lpr.S -o cake_lpr -std=c99

# Default build with 64 GB heap and 16 GB stack for starexec
starexec: basis_ffi.c cake_lpr.S
	gcc basis_ffi.c cake_lpr.S -o cake_lpr -std=c99 \
	-DCML_HEAP_SIZE=65536 -DCML_STACK_SIZE=16384

clean:
	rm -fv cake_lpr
