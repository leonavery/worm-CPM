#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM5=$MORPHEUS/worm5s
export MODEL=$WORM5/worm5g.xml
export OUTDIR=$WORM5/sim5g7
export LOGOUT=$OUTDIR/worm5g.out
export MODELIN=$WORM5/worm5gstart.xml.gz
rm -rf $OUTDIR
mkdir -p $OUTDIR
uname -a > $LOGOUT
date >> $LOGOUT
gtime -v morpheus -f $MODELIN --perf-stats --outdir $OUTDIR |& timestamp >> $LOGOUT
date >> $LOGOUT



