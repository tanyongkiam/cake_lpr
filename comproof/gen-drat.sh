CNF=$1
CUBES=$2

SIZE=`wc $CUBES | awk '{print $1}'`

mkdir -p drat

COMP=$3

rm $COMP

#Generate cube proofs
for (( i=1; i<=$SIZE; i++ ))
do
  echo $i
  cp $CNF tmp.icnf
   head -n $i $CUBES | tail -n 1 >> tmp.icnf
  ./CnC/iglucose/core/iglucose tmp.icnf -certified -certified-output=drat/proof-$i.drat
  tail -n 1 drat/proof-$i.drat >> $COMP
  rm tmp.icnf
done

#Run the overall proof
cat $CNF | awk -v var=$SIZE '/p cnf/ {printf "p cnf %i %i\n", $3, $4+var} / 0/ {print $0}' > tmp.icnf
cat $COMP >> tmp.icnf
./CnC/iglucose/core/iglucose tmp.icnf -certified -certified-output=drat/proof-$((SIZE+1)).drat

echo '0' >> $COMP
