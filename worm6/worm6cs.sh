#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM6=$MORPHEUS/worm6
export MODEL=$WORM6/worm6c.xml
export OUTDIR=$WORM6/sim6c7
rm -rf $OUTDIR
mkdir -p $OUTDIR
uname -a
date
gtime -v morpheus -f $MODEL --perf-stats --outdir $OUTDIR | timestamp
date



