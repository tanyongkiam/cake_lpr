#Generate the LPR benchmark proofs
#Assumes setup.sh has been ran

# run with argument:
# ./gen_lpr_benchmark.sh hole
# ./gen_lpr_benchmark.sh mchess
# ./gen_lpr_benchmark.sh Urquhart


TIMEFORMAT=%R
TIMEOUT=10000
SADICAL=./sadical/sadical
DPRTRIM=./dpr-trim/dpr-trim
DRATTRIM=./drat-trim/drat-trim
PR2DRAT=./pr2drat/pr2drat
LOGFILE=timing_logs/gen_lpr_benchmark_timing_$1.log

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
  #Generate PR file
  echo "Generating ${f%.*}.pr"
  echo -n "SaDiCaL: " >> $LOGFILE
  time (timeout $TIMEOUT $SADICAL --binary=false $f ${f%.*}.pr;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
       ) 2>>$LOGFILE
  #Generate LPR file
  echo "Generating ${f%.*}.lpr"
  echo -n "dpr-trim: " >> $LOGFILE
  time (timeout $TIMEOUT $DPRTRIM $f ${f%.*}.pr -L ${f%.*}.lpr ;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
        sort -n ${f%.*}.lpr -o ${f%.*}.lpr) 2>>$LOGFILE
  #Generate DRAT file
  echo "Generating ${f%.*}.drat"
  echo -n "pr2drat: " >> $LOGFILE
  time (timeout $TIMEOUT $PR2DRAT $f ${f%.*}.pr > ${f%.*}.drat ;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
       ) 2>>$LOGFILE
  #Generate LRAT file
  echo "Generating ${f%.*}.lrat"
  echo -n "drat-trim: " >> $LOGFILE
  time (timeout $TIMEOUT $DRATTRIM $f ${f%.*}.drat -L ${f%.*}.lrat ;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
       ) 2>>$LOGFILE
done

