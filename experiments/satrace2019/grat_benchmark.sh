#Generate and run GRAT benchmark proofs
#Assumes setup.sh has been ran

# run with argument:
# ./grat_benchmark unsat


TIMEFORMAT=%R
TIMEOUT=10000
# PATHS TO ISABELL GRATGEN and GRATCHK
GRATGEN=./isabelle/gratgen/gratgen
GRATCHK=./isabelle/gratchk/code/gratchk
LOGFILE=timing_logs/grat_benchmark_timing_$1.log

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
  #Generate GRAT files from regular format, 8 cores
  echo "Generating ${f%.*} GRAT"
  time (timeout $TIMEOUT $GRATGEN $f ${f%.*}.drat -b -j 8 -l ${f%.*}.gratl -o ${f%.*}.gratp;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
       ) 2>>$LOGFILE

  echo "Checking ${f%.*} GRAT with Isabelle"
  echo -n "Isabelle: " >> $LOGFILE
  time (timeout $TIMEOUT $GRATCHK unsat $f ${f%.*}.gratl ${f%.*}.gratp;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
       ) 2>>$LOGFILE
done
