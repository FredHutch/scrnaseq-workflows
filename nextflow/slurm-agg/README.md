# Running Cellranger Agg on Slurm


```
ml nextflow

cd nextflow/slurm-agg

screen 
nextflow slurm-agg.nf --with-trace >>log.txt 2>&1

```