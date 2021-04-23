#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM5=$MORPHEUS/worm5
export MODELIN=$WORM5/worm5g.xml
declare -i seed
seed=$1

export OUTDIR=$WORM5/sim5gseed$seed
rm -rf $OUTDIR
mkdir -p $OUTDIR
export MODELOUT=$OUTDIR/worm5gseed$seed.xml
export LOGOUT=$OUTDIR/worm5gseed$seed.out
sed -e 's/RandomSeed value=\"[0-9]*\"/RandomSeed value=\"'$seed'\"/' $MODELIN > $MODELOUT
uname -a > $LOGOUT
date >> $LOGOUT
gtime -v morpheus -f $MODELOUT --perf-stats --outdir $OUTDIR | timestamp >> $LOGOUT
date >> $LOGOUT
