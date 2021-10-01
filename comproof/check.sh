CNF=$1
COMPROOF=$2

SIZE=`wc $COMPROOF | awk '{print $1}'`

for (( i=0; i<$SIZE; i++ ))
do
  j=$(($i+1))
  ../cake_lpr $CNF $COMPROOF $i-$j lrat/proof-$j.lrat
done

