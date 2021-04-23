#!/bin/bash
set -vx
export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export MORPHEUS=`realpath $HOME/morpheus`
export WORM6=$MORPHEUS/worm6
export MODELIN=$WORM6/worm6c.xml
declare -i min
min=$1
declare -i max
max=$2

for ((i=$min; i<=$max; i++)); do
    export OUTDIR=$WORM6/sim6cseed$i
    rm -rf $OUTDIR
    mkdir -p $OUTDIR
    export MODELOUT=$OUTDIR/worm6cseed$i.xml
    export LOGOUT=$OUTDIR/worm6cseed$i.out
    sed -e 's/RandomSeed value=\"[0-9]*\"/RandomSeed value=\"'$i'\"/' $MODELIN > $MODELOUT
    uname -a > $LOGOUT
    date >> $LOGOUT
    (gtime -v morpheus -f $MODELOUT --perf-stats --outdir $OUTDIR | timestamp >> $LOGOUT) &
    date >> $LOGOUT
done
wait
