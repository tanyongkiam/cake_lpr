#Check the LPR benchmark proofs
#Assumes setup.sh has been ran

# run with argument:
# ./run_lpr_benchmark.sh hole
# ./run_lpr_benchmark.sh mchess
# ./run_lpr_benchmark.sh Urquhart

TIMEFORMAT=%R
TIMEOUT=10000
CAKEML=../../cake_lpr #path to cake_lpr
#COQ=./coq/coq_lrat #path to Coq checker
#ACL2=~/acl2/books/projects/sat/lrat/cube/run.sh #path to ACL2 checker

LOGFILE=timing_logs/run_lpr_benchmark_timing_$1.log

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
  #Check LPR file
  echo "Checking ${f%.*}.lpr with CakeML"
  echo -n "cake_lpr (lpr): " >> $LOGFILE
  time (timeout $TIMEOUT $CAKEML $f ${f%.*}.lpr;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
       ) 2>>$LOGFILE

  #Check LRAT file
  echo "Checking ${f%.*}.lrat with CakeML"
  echo -n "cake_lpr (lrat): " >> $LOGFILE
  time (timeout $TIMEOUT $CAKEML $f ${f%.*}.lrat;
        if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
       ) 2>>$LOGFILE

  #OPTIONAL: check with ACL2
  if [[ -z "${ACL2}" ]]; then
    echo "Skipped checking with ACL2"
  else
    echo "Checking ${f%.*}.lrat with ACL2"
    echo -n "ACL2 checker: " >> $LOGFILE
    time (./drat-trim/to-clrat ${f%.*}.lrat ${f%.*}.clrat ;
          timeout $TIMEOUT $ACL2 $f ${f%.*}.clrat $f ;
          if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
         ) 2>>$LOGFILE
  fi

  #OPTIONAL: check with Coq
  if [[ -z "${COQ}" ]]; then
    echo "Skipped checking with Coq"
  else
    #Need for the Coq checker to not run out of stack
    ulimit -s 16777216
    echo "Checking ${f%.*}.lrat with Coq"
    echo -n "Coq checker: " >> $LOGFILE
    time (timeout $TIMEOUT $COQ $f ${f%.*}.lrat;
          if [ $? -eq 124 ] ; then echo -n "TIMEOUT " >> $LOGFILE; fi;
         ) 2>>$LOGFILE
  fi
done


