#!/bin/bash

# first, log in
# ssh dnambi@rhino
#' Cellranger Processing
#'
#' Usage:
#' sbatch -n 1 -c 16 -p largenode --mem=256000 --time=72:00:00 process-10x.sh
#'
#' Triggers processing via cellranger of 10X data, from custom reference
#' creation to counting to aggregation. Custom for the project to figure
#' out parameters for automation of a pipeline.

## Data specs -------------------------------------------------------------------
ml cellranger

## Base working directory
BASE=/fh/fast/_HDC/cortex/dnambi/workflows

## Note: make sure that concatenation of vars always in same order
## Run group label IDs to be used by cellranger mkfastq for 10X run groups
GROUP_LABELS=(180308_1126 180308_1127 180710_1217 180710_1218 180914_0609 180920_0611)

## Sample labels
SAMPLE_LABELS=(00600_d-SCR_BMA 00600_2017_BMA 00600_2012-1_BMA 00600_2012-2_BMA
          00600_d-014_BMA 00600_d-014_BMC 00600_d-028_BMA 00600_d-028_BMC
          00587_d-SCR_BMA 00587_d-028_BMA 00587_d-060_BMA 00587_d-090_BMA
          00587_d-PLA_TuB 00599_d-SCR_BMA 00599_d-014_BMA 00599_d-060_BMC
          00599_d-090_BMA 00599_d-180_BMA)

## Location of raw data from 10X
RAW_BASE=/shared/ngs/illumina/mpont

RAW_180308_1126=$RAW_BASE/180308_SN367_1126_AHF52CBCX2
RAW_180308_1127=$RAW_BASE/180308_SN367_1127_BHF52FBCX2
RAW_180710_1217=$RAW_BASE/180710_SN367_1217_AHKJFHBCX2
RAW_180710_1218=$RAW_BASE/180710_SN367_1218_BHKJ7FBCX2
RAW_180914_0609=$RAW_BASE/180914_D00300_0609_BCCT68ANXX
RAW_180920_0611=$RAW_BASE/180920_D00300_0611_AHM7VFBCX2

RAW=($RAW_180308_1126 $RAW_180308_1127 $RAW_180710_1217
     $RAW_180710_1218 $RAW_180914_0609 $RAW_180920_0611)


## CSVs of lanes, sample names, and chromium indexes for cellranger mkfastq
LANES_180308_1126=$BASE/data-meta/lanes/lanes_180308_1126.csv
LANES_180308_1127=$BASE/data-meta/lanes/lanes_180308_1127.csv
LANES_180710_1217=$BASE/data-meta/lanes/lanes_180710_1217.csv
LANES_180710_1218=$BASE/data-meta/lanes/lanes_180710_1218.csv
LANES_180914_0609=$BASE/data-meta/lanes/lanes_180914_0609.csv
LANES_180920_0611=$BASE/data-meta/lanes/lanes_180920_0611.csv

LANES=($LANES_180308_1126 $LANES_180308_1127 $LANES_180710_1217
       $LANES_180710_1218 $LANES_180914_0609 $LANES_180920_0611)


## Fastq Outputs
FASTQ_180308_1126=$BASE/data-raw/fastq/runs/fastq_180308_1126
FASTQ_180308_1127=$BASE/data-raw/fastq/runs/fastq_180308_1127
FASTQ_180710_1217=$BASE/data-raw/fastq/runs/fastq_180710_1217
FASTQ_180710_1218=$BASE/data-raw/fastq/runs/fastq_180710_1218
FASTQ_180914_0609=$BASE/data-raw/fastq/runs/fastq_180914_0609
FASTQ_180920_0611=$BASE/data-raw/fastq/runs/fastq_180920_0611

FASTQ=($FASTQ_180308_1126 $FASTQ_180308_1127 $FASTQ_180710_1217
       $FASTQ_180710_1218 $FASTQ_180914_0609 $FASTQ_180920_0611)

## Where all samples will be stored (after linking from mkfastq outputs)
SAMPLE_DIR=$BASE/data-raw/fastq/samples

cd $BASE

## Denovo Reference genome creation --------------------------------------------
## Locations of default references
REF_BASE=/fh/fast/_HDC/cortex/dnambi/workflows/reference/cellranger
REF_HG38=$REF_BASE/refdata-cellranger-mm10-1.2.0/fasta/genome.fa
GTF_HG38=$REF_BASE/refdata-cellranger-mm10-1.2.0/genes/genes.gtf

## New references uses S287-v2 codon-optimized sequence
REF_ADDON=$BASE/data-meta/cart-sequence/addon.fa
GTF_ADDON=$BASE/data-meta/cart-sequence/addon.gtf

## New combined reference output that will be made by cellranger mkref
REF_DENOVO=$BASE/data-raw/reference/cart-bcma

## Create denovo reference if unavailable --------------------------------------
echo "Working on creating reference..."

## Combine addons with base reference genomes
mkdir -p $BASE2/data-raw/reference
cd $BASE2/data-raw/reference
cat $REF_ADDON $REF_HG38 > tmp_hg38.fasta
cat $GTF_ADDON $GTF_HG38 > tmp_hg38.gtf

## Create denovo reference
cellranger mkref --genome=$(basename $REF_DENOVO) --fasta=tmp_hg38.fasta --genes=tmp_hg38.gtf

# ## Cleanup
# rm tmp_hg38.fasta tmp_hg38.gtf
