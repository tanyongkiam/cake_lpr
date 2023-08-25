#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
    echo "usage: update.sh HOL_commit_hash CakeML_commit_hash"
else

HOLHASH=$1
CMLHASH=$2

echo '*** ********************************************* ***'
echo '*** WARNING: make sure .S files have been updated ***'
echo '*** ********************************************* ***'

# Ensure submodules are init-ed
# git submodule update --init --recursive

# Pull latest commits
git submodule update --recursive --remote

# Checkout the commits
cd HOL ; git checkout $HOLHASH ; cd ..
cd cakeml ; git checkout $CMLHASH ; cd ..

# Update README.md
sed -i "s/HOL4: .*/HOL4: $HOLHASH/" README.md
sed -i "s/CakeML: .*/CakeML: $CMLHASH/" README.md

# MD5 checksum of the relevant executable files
sha256sum Makefile basis_ffi.c cake_lpr.S cake_lpr_arm8.S > cake_lpr.sha256

# Stage everything for commit
git add HOL
git add cakeml
git add README.md
git add cake_lpr.sha256
git add cake_lpr.S
git add cake_lpr_arm8.S
git add basis_ffi.c
git add Makefile

fi
