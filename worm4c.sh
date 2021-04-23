#!/bin/bash
#SBATCH --mail-user=lavery@uwaterloo.ca
#SBATCH --mail-type=ALL
#SBATCH --job-name=worm4c
#SBATCH --output=worm4c-%j.out
#SBATCH --time=2:59:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
##SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=32
##SBATCH --mem-per-cpu=3G
#SBATCH --mem=0
set -vx
export NCPUS=$SLURM_CPUS_PER_TASK
export MORPHEUS=`realpath $HOME/morpheus`
cd $MORPHEUS/worm4
make -j$NCPUS -C worm4c

