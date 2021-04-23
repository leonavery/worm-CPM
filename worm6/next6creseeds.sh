#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM6=$MORPHEUS/worm6
declare -i seed
seed=$1

export LASTOUTDIR=$WORM6/sim6cseed${seed}b
export CHECKPOINT=`ls -1 $LASTOUTDIR/*.xml.gz | tail -n 1`
export MODELIN=$CHECKPOINT
export OUTDIR=$WORM6/sim6cseed${seed}c
rm -rf $OUTDIR
mkdir -p $OUTDIR
export LOGOUT=$OUTDIR/next6cseed$seed.out
uname -a > $LOGOUT
date >> $LOGOUT
gtime -v morpheus -f $MODELIN --perf-stats --outdir $OUTDIR | timestamp >> $LOGOUT
date >> $LOGOUT
