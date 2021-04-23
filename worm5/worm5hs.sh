#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM5=$MORPHEUS/worm5
export MODELIN=$WORM5/worm5h.xml
export OUTDIR=$WORM5/sim5h1
rm -rf $OUTDIR
mkdir -p $OUTDIR
export MODELOUT=$OUTDIR/worm5h00000000.xml
cp $MODELIN $MODELOUT
gzip $MODELOUT
export MODELOUT=$OUTDIR/worm5h00000000.xml.gz
uname -a
date
gtime -v morpheus -f $MODELOUT --perf-stats --outdir $OUTDIR | timestamp
date



