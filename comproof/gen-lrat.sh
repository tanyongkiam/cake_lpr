CNF=$1
COMPROOF=$2

SIZE=`wc $COMPROOF | awk '{print $1}'`

mkdir -p lrat

for (( i=0; i<$SIZE; i++ ))
do
  j=$(($i+1))
  echo $j
  cat $CNF | awk -v var=$i '/p cnf/ {printf "p cnf %i %i\n", $3, $4+var} / 0/ {print $0}' > tmp.cnf
  head -n $i $COMPROOF >> tmp.cnf
  ./drat-trim/drat-trim tmp.cnf drat/proof-$j.drat -L lrat/proof-$j.lrat
  rm tmp.cnf
done

