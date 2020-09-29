#NOTE: assumes a working python installation

# Get the pgbdd repository
git clone https://github.com/rebryant/pgbdd.git

# Generate the CNFs and schedules
cd pgbdd/benchmarks

./chess.py -n 20  -r mchess-20
./chess.py -n 40  -r mchess-40
./chess.py -n 60  -r mchess-60
./chess.py -n 80  -r mchess-80
./chess.py -n 100 -r mchess-100

cd ../..

mkdir -p mchess

mv pgbdd/benchmarks/mchess*.* mchess/

git clone https://github.com/marijnheule/drat-trim.git

# Build drat-trim
cd drat-trim ; make ; make compress ; cd ..
