#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM6=$MORPHEUS/worm6
export MODELIN=$WORM6/worm6e.xml
declare -i seed
seed=$1

export OUTDIR=$WORM6/sim6eseed$seed
rm -rf $OUTDIR
mkdir -p $OUTDIR
export MODELOUT=$OUTDIR/worm6eseed$seed.xml
export LOGOUT=$OUTDIR/worm6eseed$seed.out
sed -e 's/RandomSeed value=\"[0-9]*\"/RandomSeed value=\"'$seed'\"/' $MODELIN > $MODELOUT
uname -a > $LOGOUT
date >> $LOGOUT
gtime -v morpheus -f $MODELOUT --perf-stats --outdir $OUTDIR | timestamp >> $LOGOUT
date >> $LOGOUT
