# Get the SAT competition files

wget http://satcompetition.org/sr2019benchmarks.zip
unzip sr2019benchmarks.zip

# Extract 10 UNSAT benchmarks for testing
mkdir -p unsat

mv sr2019/old/6s139-sc2013.cnf.xz unsat
mv sr2019/old/9dlx_vliw_at_b_iq8-sc2007.cnf.xz unsat
mv sr2019/old/ablmulub2x32o-sc2016.cnf.xz unsat
mv sr2019/old/aes_equiv_encry_3_rounds.debugged-sc2012.cnf.xz unsat
mv sr2019/old/countbitswegner128-sc2011.cnf.xz unsat
mv sr2019/new/Biere/eqbpdtlf14bpwtcl14.cnf.xz unsat
mv sr2019/old/hwmcc15deep-oski15a10b10s-k22-sc2017.cnf.xz unsat
mv sr2019/new/Savicky/size_4_4_4_i4295_r8.cnf.xz unsat
mv sr2019/old/snw_13_8_pre-sc2016.cnf.xz unsat
mv sr2019/old/uniqinv47prop-sc2018.cnf.xz unsat

xz --decompress unsat/*

# drat-trim
git clone https://github.com/marijnheule/drat-trim.git

# CaDiCaL (you can also try your favorite SAT solver here, e.g. https://github.com/arminbiere/kissat.git)
git clone https://github.com/arminbiere/cadical.git

# Build CaDiCaL
cd cadical ; ./configure ; make ; cd ..

# Build drat-trim
cd drat-trim ; make ; make compress ; cd ..
