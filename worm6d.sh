#!/bin/bash
#SBATCH --mail-user=lavery@uwaterloo.ca
#SBATCH --mail-type=ALL
#SBATCH --job-name=worm6d
#SBATCH --output=worm6d-%j.out
#SBATCH --time=167:59:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
##SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=3G
##SBATCH --mem=0
set -vx
export NCPUS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
env > ${SLURM_JOB_NAME}-${SLURM_JOB_ID}.env
cd $MORPHEUS/worm6
sh worm6ds.sh

