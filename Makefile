CFLAGS ?= -O2

# Pick the build for the host machine: x64 or ARMv8
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),x86_64)
CAKE_S = cake_lpr.S
else ifeq ($(UNAME_M),arm64)
CAKE_S = cake_lpr_arm8.S
else ifeq ($(UNAME_M),aarch64)
CAKE_S = cake_lpr_arm8.S
else
$(error Unsupported architecture $(UNAME_M): only x64 and ARMv8 are available)
endif

cake_lpr: basis_ffi.c $(CAKE_S)
	$(CC) $(CFLAGS) basis_ffi.c $(CAKE_S) -o cake_lpr

clean:
	rm -fv cake_lpr
