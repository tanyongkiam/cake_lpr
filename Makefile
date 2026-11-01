CFLAGS ?= -O2

# Pick the build for the host machine: x64 or ARMv8
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),x86_64)
CAKE_LPR = cake_lpr.S
CAKE_LSR = cake_lsr.S
else ifeq ($(UNAME_M),arm64)
CAKE_LPR = cake_lpr_arm8.S
CAKE_LSR = cake_lsr_arm8.S
else ifeq ($(UNAME_M),aarch64)
CAKE_LPR = cake_lpr_arm8.S
CAKE_LSR = cake_lsr_arm8.S
else
$(error Unsupported architecture $(UNAME_M): only x64 and ARMv8 are available)
endif

.PHONY: all clean

all: cake_lpr cake_lsr

cake_lpr: basis_ffi.c $(CAKE_LPR)
	$(CC) $(CFLAGS) basis_ffi.c $(CAKE_LPR) -o cake_lpr

cake_lsr: basis_ffi.c $(CAKE_LSR)
	$(CC) $(CFLAGS) basis_ffi.c $(CAKE_LSR) -o cake_lsr

clean:
	rm -fv cake_lpr cake_lsr
