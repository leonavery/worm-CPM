#!/bin/bash
set -vx
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OPENBLAS_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
export WORM7=`realpath $MORPHEUS/worm7s`
export MODEL=worm7a.xml

declare -i seed
seed=$1

step=$2

if [[ $step == "new" ]]; then
   nextsuffix="00"
   export CHECKPOINT=worm7a${seed}last.xml
   sed -e 's/RandomSeed value=\"[0-9]*\"/RandomSeed value=\"'${seed}'\"/' $MODEL > $CHECKPOINT
else
   printf -v step '%02d' $(( 10#$step ))

   export LASTDIR=$WORM7/sim7aseed${seed}-${step}
   if [[ ! -f $LASTDIR/inprogress ]]; then
       exit 0
   fi
   printf -v nextsuffix '%02d' $(( 10#$step + 1 ))
   export CHECKPOINT=`ls $LASTDIR/*.xml.gz | grep -v ${seed}last.xml.gz | tail -n 1`
fi
export CPXML=worm7a${seed}last.xml
export OUTDIR=$WORM7/sim7aseed${seed}-${nextsuffix}
rm -rf $OUTDIR
mkdir -p $OUTDIR
if [[ $step == "new" ]]; then
   cp $CHECKPOINT $OUTDIR/$CPXML
   rm $CHECKPOINT
else
   zcat $CHECKPOINT | grep -v 'RandomSeed' > $OUTDIR/$CPXML
fi
gzip -v $OUTDIR/$CPXML
echo $nextsuffix >$OUTDIR/inprogress
export LOGOUT=$OUTDIR/worm7aseed$seed.out
( cd $MORPHEUS; env CSVDIR=$OUTDIR sbatch -d afterburstbuffer:${SLURM_JOB_ID} csvcompress.sh )
( cd $MORPHEUS; env SEED=$seed STEP=$nextsuffix sbatch -d afternotok:${SLURM_JOB_ID} spawn7a.sh )
uname -a > $LOGOUT
date >> $LOGOUT
gtime -v morpheus -f $OUTDIR/$CPXML.gz --perf-stats --outdir $OUTDIR | timestamp >> $LOGOUT
rm $OUTDIR/inprogress
date >> $LOGOUT
