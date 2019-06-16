## Base working directory
BASE=/fh/fast/gottardo_r/ramezqui_working/analysis/gottardo_10x-pont-bcma-all
BASE2=/fh/fast/_HDC/cortex/dnambi/workflows

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


## Copy the lanes over
mkdir -p $BASE2/data-meta/lanes
mkdir -p $BASE2/data-raw/fastq/runs
mkdir -p $BASE2/data-raw/fastq/samples

## CSVs of lanes, sample names, and chromium indexes for cellranger mkfastq
LANES_180308_1126=$BASE/data-meta/lanes/lanes_180308_1126.csv
LANES_180308_1127=$BASE/data-meta/lanes/lanes_180308_1127.csv
LANES_180710_1217=$BASE/data-meta/lanes/lanes_180710_1217.csv
LANES_180710_1218=$BASE/data-meta/lanes/lanes_180710_1218.csv
LANES_180914_0609=$BASE/data-meta/lanes/lanes_180914_0609.csv
LANES_180920_0611=$BASE/data-meta/lanes/lanes_180920_0611.csv

LANES2_180308_1126=$BASE2/data-meta/lanes/lanes_180308_1126.csv
LANES2_180308_1127=$BASE2/data-meta/lanes/lanes_180308_1127.csv
LANES2_180710_1217=$BASE2/data-meta/lanes/lanes_180710_1217.csv
LANES2_180710_1218=$BASE2/data-meta/lanes/lanes_180710_1218.csv
LANES2_180914_0609=$BASE2/data-meta/lanes/lanes_180914_0609.csv
LANES2_180920_0611=$BASE2/data-meta/lanes/lanes_180920_0611.csv


cp -r $LANES_180308_1126 $LANES2_180308_1126
cp -r $LANES_180308_1127 $LANES2_180308_1127
cp -r $LANES_180710_1217 $LANES2_180710_1217
cp -r $LANES_180710_1218 $LANES2_180710_1218
cp -r $LANES_180914_0609 $LANES2_180914_0609
cp -r $LANES_180920_0611 $LANES2_180920_0611


## Where all samples will be stored (after linking from mkfastq outputs)
SAMPLE_DIR=$BASE/data-raw/fastq/samples
SAMPLE_DIR2=$BASE2/data-raw/fastq/samples

cd $BASE

## Denovo Reference genome creation --------------------------------------------
## Locations of default references
# DEVN - THIS ISN'T THERE!!!
REF_BASE=/fh/fast/gottardo_r/ramezqui_working/reference
REF_BASE2=$BASE2/reference

cp -r $REF_BASE $REF_BASE2

REF_HG38=$REF_BASE/refdata-cellranger-hg38-1.2.0/fasta/genome.fa
REF_HG382=$REF_BASE2/refdata-cellranger-hg38-1.2.0/fasta/genome.fa
GTF_HG38=$REF_BASE/refdata-cellranger-hg38-1.2.0/genes/genes.gtf
GTF_HG382=$REF_BASE2/refdata-cellranger-hg38-1.2.0/genes/genes.gtf


cp -r $REF_HG38 $REF_HG382
cp -r $GTF_HG38 $GTF_HG382







## New references uses S287-v2 codon-optimized sequence
REF_ADDON2=$BASE2/data-meta/cart-sequence/addon.fa
GTF_ADDON2=$BASE2/data-meta/cart-sequence/addon.gtf

mkdir -p $BASE2/data-meta/cart-sequence
# NOTE: use nano to copy-paste these in