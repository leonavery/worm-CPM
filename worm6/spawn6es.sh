#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM6=`realpath $MORPHEUS/worm6s`
declare -i seed
seed=$1

printf -v step '%02d' $2

export LASTDIR=$WORM6/sim6eseed${seed}-${step}
if [[ ! -f $LASTDIR/inprogress ]]; then
    exit 0
fi
printf -v nextsuffix '%02d' $(( step + 1 ))
export OUTDIR=$WORM6/sim6eseed${seed}-${nextsuffix}
rm -rf $OUTDIR
mkdir -p $OUTDIR
echo $nextsuffix >$OUTDIR/inprogress
export LOGOUT=$OUTDIR/worm6eseed$seed.out
export CHECKPOINT=`ls $LASTDIR/*.xml.gz | grep -v ${seed}last.xml.gz | tail -n 1`
# export CHECKPOINTFN=${CHECKPOINT##*/}
export CPXML=worm6e${seed}last.xml
zcat $CHECKPOINT | grep -v 'RandomSeed' > $OUTDIR/$CPXML
gzip -v $OUTDIR/$CPXML
( cd $MORPHEUS; env CSVDIR=$OUTDIR sbatch -d afterburstbuffer:${SLURM_JOB_ID} csvcompress.sh )
( cd $MORPHEUS; env SEED=$seed STEP=$nextsuffix sbatch -d afternotok:${SLURM_JOB_ID} spawn6e.sh )
uname -a > $LOGOUT
date >> $LOGOUT
gtime -v morpheus -f $OUTDIR/$CPXML.gz --perf-stats --outdir $OUTDIR | timestamp >> $LOGOUT
rm $OUTDIR/inprogress
date >> $LOGOUT
