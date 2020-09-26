#Generate the LRAT benchmark proofs
#Assumes setup.sh has been ran

# run with argument:
# ./gen_lrat_benchmark.sh unsat

TIMEFORMAT=%R
TIMEOUT=5000
CADICAL=./cadical/build/cadical # OR your favorite SAT solver
DRATTRIM=./drat-trim/drat-trim
LOGFILE=timing_logs/gen_lrat_benchmark_timing_$1.log

mkdir -p timing_logs/

if [ "$#" -ne 1 ]; then
    echo "!!! Need exactly 1 argument path/to/dir containing cnfs!!!"
    exit 1
fi

if test -f "$LOGFILE"; then
  echo "!!! $LOGFILE already exists. Exiting to prevent accidental overwritting !!!"
  exit 1
fi

for f in $1/*.cnf;
do
  echo "Running $f"
  echo $f >> $LOGFILE
  #Generate DRAT file
  echo "Generating ${f%.*}.drat"
  echo -n "CaDiCaL: " >> $LOGFILE
  time (timeout $TIMEOUT $CADICAL $f ${f%.*}.drat ;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
       ) 2>>$LOGFILE
  #Generate LRAT file
  echo "Generating ${f%.*}.lrat"
  echo -n "drat-trim: " >> $LOGFILE
  time (timeout $TIMEOUT $DRATTRIM $f ${f%.*}.drat -L ${f%.*}.lrat ;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
       ) 2>>$LOGFILE
done

