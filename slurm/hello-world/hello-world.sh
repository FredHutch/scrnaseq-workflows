#!/bin/bash
#SBATCH --mail-user=<span>dnambi</span>@fredhutch.org 
#SBATCH --mail-type=END
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1


date
sleep 5
echo "Job done on $(date)"