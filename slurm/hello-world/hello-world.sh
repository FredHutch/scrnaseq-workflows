#!/bin/bash

#' hello world

#SBATCH --mail-user=dnambi@fredhutch.org 
#SBATCH --mail-type=END
#SBATCH --nodes=1
#SBATCH --output=helloworldout/par-%J.out
#SBATCH --error=helloworldout/par-%J.err
#SBATCH --cpus-per-task=1


date
sleep 5
date