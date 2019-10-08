#!/bin/bash

## Process scRNAseq with kallisto|bustools pipeline

## Load software
module purge
module load kallisto
module load bustools

## Base directory for analysis
BASE=/home/ramezqui/analysis/_SODA

## Change working dir
cd $BASE

## Plain Quantification -------------------------------------------------------
## Specify reference index
INDEX_BASE=/home/ramezqui/work/reference/kallisto_ref/mus_musculus_with_tcrt-genes
INDEX=${INDEX_BASE}/Mus_musculus_with_tcrt-genes.GRCm38.cdna.all.idx
TXP2GENE=${INDEX_BASE}/transcripts_to_genes.txt
TENX_WHITELIST=/home/ramezqui/work/reference/10x_whitelists/10xv2_whitelist.txt
TENX_WHITELIST_VER="10xv2"

## Outputs
KALLISTOBUS_OUTDIR=$BASE/data-raw/kallisto-bustools
mkdir -p $KALLISTOBUS_OUTDIR

## Inputs
S=($(ls -d $BASE/data-raw/fastq/*))
R1=($(ls $BASE/data-raw/fastq/*/*R1*.fastq.gz))
R2=($(ls $BASE/data-raw/fastq/*/*R2*.fastq.gz))

## Hardware specs
THREADS=8
MEMORY=64000
PARTITION=largenode

## Sbatch header
KB_SBATCH_OUTDIR=data-raw/kb_sbatch
mkdir -p $KB_SBATCH_OUTDIR

REQS="module purge; module load kallisto; module load bustools"
for I in $(seq 0 $(expr ${#S[@]} - 1)); do
    SAMPLE=$(basename ${S[$I]})

    echo "Working on $SAMPLE .."
    echo ""

    CMD_SBATCH="sbatch -n 1 -c $THREADS -p $PARTITION --mem=$MEMORY --time=24:00:00 -o logs/kallisto-bustools/out_$SAMPLE.txt -e logs/kallisto-bustools/err_$SAMPLE.txt -J ${SAMPLE}_kallisto -D $BASE"

    CMD_01="kallisto bus -i $INDEX -o $KALLISTOBUS_OUTDIR/$SAMPLE -x $TENX_WHITELIST_VER -t $THREADS ${R1[$I]} ${R2[$I]}"
    CMD_02="cd $KALLISTOBUS_OUTDIR/$SAMPLE; mkdir -p genecount tmp"
    CMD_03="bustools correct -w $TENX_WHITELIST -p output.bus | bustools sort -T tmp/ -t 4 -p - | bustools count -o genecount/genes -g $TXP2GENE -e matrix.ec -t transcripts.txt --genecounts -"

    CMD_MAIN="$REQS; $CMD_01; $CMD_02; $CMD_03"
    CMD_ALL="$CMD_SBATCH --wrap='$CMD_MAIN'"

    ## Compose bash script
    echo '#!/bin/bash' > ${KB_SBATCH_OUTDIR}/${SAMPLE}.sh
    echo "" >> ${KB_SBATCH_OUTDIR}/${SAMPLE}.sh
    echo "$CMD_MAIN" >> ${KB_SBATCH_OUTDIR}/${SAMPLE}.sh

    ## Make it executable
    chmod +x ${KB_SBATCH_OUTDIR}/${SAMPLE}.sh

    ## Command to submit sbatch script to cluster
    ## CMD_ALL="$CMD_SBATCH ${KB_SBATCH_OUTDIR}/${SAMPLE}.sh"

    ## Actually submit the job
    ## eval "$CMD_ALL"

    ## Just run the command
    eval "$CMD_MAIN"
done