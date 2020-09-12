
# Get the relevant SaDiCaL files

wget http://fmv.jku.at/sadical/sadical.zip
unzip sadical.zip
wget http://fmv.jku.at/sadical/prencode-benchmarks.zip
unzip prencode-benchmarks.zip

#Split into folders for nicer handling
mkdir -p hole
mv hole*.cnf hole/

mkdir -p mchess
mv mchess*.cnf mchess/

mkdir -p Urquhart
mv Urquhart*.cnf Urquhart/

# dpr-trim
git clone https://github.com/marijnheule/dpr-trim.git

# drat-trim
git clone https://github.com/marijnheule/drat-trim.git

# pr2drat
git clone https://github.com/marijnheule/pr2drat.git

# Build SaDiCaL
cd sadical ; ./configure.sh ; make ; cd ..

# Build dpr-trim
cd dpr-trim ; make ; cd ..

# Build drat-trim
cd drat-trim ; make ; make to-clrat cd ..

# Build pr2drat
cd pr2drat; make ; cd ..
