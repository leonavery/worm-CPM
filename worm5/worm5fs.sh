#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM5=$MORPHEUS/worm5
export MODEL=$WORM5/worm5f.xml
export OUTDIR=$WORM5/sim5f3
rm -rf $OUTDIR
mkdir -p $OUTDIR
uname -a
date
gtime -v morpheus -f $MODEL --perf-stats --outdir $OUTDIR | timestamp
date



