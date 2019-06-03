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
BASE=/fh/fast/_HDC/cortex/dnambi/workflows/roba

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



## Fastq extract ----------------------------------------------------------------
echo "Working on demultiplexing fastq data..."
## Demultiplex samples into constituent fastq files
## requires a csv with lanes, sample-name, and chromium index

for I in $(seq 0 $(expr ${#FASTQ[@]} - 1)); do
    mkdir -p ${FASTQ[$I]}
    cd ${FASTQ[$I]}

    cellranger mkfastq \
          --id=${GROUP_LABELS[$I]} \
          --run=${RAW[$I]} \
          --simple-csv=${LANES[$I]} \
          --output-dir=${FASTQ[$I]} \
          --delete-undetermined
done

## make sure all the fastq runs go into a "data-raw/fastq/runs" parent folder
## then make a "data-raw/fastq/samples" folder to link to each within the runs
mkdir -p $BASE/data-raw/fastq/samples
cd $BASE/data-raw/fastq/samples

## Within each fastq_* run group, link to the individual samples
## such that all samples are now at the same directory level
for I in ${SAMPLE_LABELS[*]}; do
    ## link to a sample, use a common run group pattern as parent folder for search
    ln -s ../runs/*/*/$I .
done

###

Outputs:
- Run QC metrics:        null
- FASTQ output folder:   /fh/fast/_HDC/cortex/dnambi/workflows/roba/data-raw/fastq/runs/fastq_180308_1126
- Interop output folder: /fh/fast/_HDC/cortex/dnambi/workflows/roba/data-raw/fastq/runs/fastq_180308_1126/180308_1126/outs/interop_path
- Input samplesheet:     /fh/fast/_HDC/cortex/dnambi/workflows/roba/data-raw/fastq/runs/fastq_180308_1126/180308_1126/outs/input_samplesheet.csv
###