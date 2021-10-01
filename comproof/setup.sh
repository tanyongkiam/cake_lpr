# Get cube-and-conquer tools

git clone https://github.com/marijnheule/CnC

# Build CnC
cd CnC ; ./build.sh ; cd ..

# drat-trim
git clone https://github.com/marijnheule/drat-trim.git

# Build drat-trim
cd drat-trim ; git checkout develop ; make ; make compress ; cd ..
