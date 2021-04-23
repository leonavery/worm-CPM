#!/bin/bash
#SBATCH --mail-user=lavery@uwaterloo.ca
#SBATCH --mail-type=ALL
#SBATCH --job-name=nextworm5f
#SBATCH --output=nextworm5f-%j.out
#SBATCH --time=167:59:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
##SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=3G
##SBATCH --mem=0
set -vx
export NCPUS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
env > ${SLURM_JOB_NAME}-${SLURM_JOB_ID}.env
cd $MORPHEUS/worm5
sh nextworm5fs.sh

