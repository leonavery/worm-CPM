#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM5=$MORPHEUS/worm5
export OUTDIR=$WORM5/sim5g5
export LASTOUTDIR=$WORM5/sim5g4
export CHECKPOINT=`ls -1 $LASTOUTDIR/*.xml.gz | tail -n 1`
export MODEL=$CHECKPOINT
rm -rf $OUTDIR
mkdir -p $OUTDIR
uname -a
date
gtime -v morpheus -f $MODEL --perf-stats --outdir $OUTDIR | timestamp
date



