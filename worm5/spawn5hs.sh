#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM5=`realpath $MORPHEUS/worm5s`
declare -i seed
seed=$1

printf -v step '%02d' $2

export LASTDIR=$WORM5/sim5hseed${seed}-${step}
if [[ ! -f $LASTDIR/inprogress ]]; then
    exit 0
fi
printf -v nextsuffix '%02d' $(( step + 1 ))
export OUTDIR=$WORM5/sim5hseed${seed}-${nextsuffix}
rm -rf $OUTDIR
mkdir -p $OUTDIR
echo $nextsuffix >$OUTDIR/inprogress
export LOGOUT=$OUTDIR/worm5hseed$seed.out
export CHECKPOINT=`ls $LASTDIR/*.xml.gz | grep -v ${seed}last.xml.gz | tail -n 1`
# export CHECKPOINTFN=${CHECKPOINT##*/}
export CPXML=worm5h${seed}last.xml
zcat $CHECKPOINT | grep -v 'RandomSeed' > $OUTDIR/$CPXML
gzip -v $OUTDIR/$CPXML
( cd $MORPHEUS; env CSVDIR=$OUTDIR sbatch -d afterburstbuffer:${SLURM_JOB_ID} csvcompress.sh )
( cd $MORPHEUS; env SEED=$seed STEP=$nextsuffix sbatch -d afternotok:${SLURM_JOB_ID} spawn5h.sh )
uname -a > $LOGOUT
date >> $LOGOUT
gtime -v morpheus -f $OUTDIR/$CPXML.gz --perf-stats --outdir $OUTDIR | timestamp >> $LOGOUT
rm $OUTDIR/inprogress
date >> $LOGOUT
