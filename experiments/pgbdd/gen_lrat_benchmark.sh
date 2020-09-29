#Generate the LRAT benchmark proofs
#Assumes setup.sh has been ran

# run with argument:
# ./gen_lrat_benchmark.sh mchess

TIMEFORMAT=%R
TIMEOUT=10000
PGBDD=./pgbdd/prototype/solver.py
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
  #Generate LRAT file
  echo "Generating ${f%.*}.lrat"
  echo -n "pgbdd: " >> $LOGFILE
  time (timeout $TIMEOUT $PGBDD -i $f -s ${f%.*}.schedule -o ${f%.*}.lrat ;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
       ) 2>>$LOGFILE
done

