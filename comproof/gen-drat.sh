CNF=$1
CUBES=$2

SIZE=`wc $CUBES | awk '{print $1}'`


for (( i=1; i<=$SIZE; i++ ))
do
  echo $i
  cp $CNF tmp.icnf
  head -n $i $CUBES | tail -n 1 >> tmp.icnf
  ./iglucose/core/iglucose tmp.icnf -certified -certified-output=drat/proof-$i.drat
done

