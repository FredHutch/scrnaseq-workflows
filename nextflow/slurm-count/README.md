# Running Cellranger count on Slurm


```
ml nextflow

cd nextflow/slurm-count

screen 
nextflow slurm-count.nf --with-trace >>log.txt 2>&1

```