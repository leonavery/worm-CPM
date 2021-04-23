#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM6=$MORPHEUS/worm6
export CPDIR=$WORM6/worm6ecps
export CHECKPOINT=`ls -1 $CPDIR/*.xml.gz | tail -n 1`
export MODEL=$CHECKPOINT
export OUTDIR=$WORM6/sim6e1
rm -rf $OUTDIR
mkdir -p $OUTDIR
uname -a
date
gtime -v morpheus -f $MODEL --perf-stats --outdir $OUTDIR | timestamp
date



