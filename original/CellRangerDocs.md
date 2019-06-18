# CellRanger Docs

## Count

```
'cellranger count' quantifies single-cell gene expression.

The commands below should be preceded by 'cellranger':

Usage:
    count
        --id=ID
        [--fastqs=PATH]
        [--sample=PREFIX]
        --transcriptome=DIR
        [options]
    count <run_id> <mro> [options]
    count -h | --help | --version

Arguments:
    id      A unique run id, used to name output folder [a-zA-Z0-9_-]+.
    fastqs  Path of folder created by mkfastq or bcl2fastq.
    sample  Prefix of the filenames of FASTQs to select.
    transcriptome   Path of folder containing 10x-compatible reference.

Options:

Single Cell Gene Expression
    --description=TEXT  Sample description to embed in output files.
    --libraries=CSV     CSV file declaring input library data sources.
    --expect-cells=NUM  Expected number of recovered cells.
    --force-cells=NUM   Force pipeline to use this number of cells, bypassing
                            the cell detection algorithm.
    --feature-ref=CSV   Feature reference CSV file, declaring feature-barcode
                             constructs and associated barcodes.
    --nosecondary       Disable secondary analysis, e.g. clustering. Optional.
    --r1-length=NUM     Hard trim the input Read 1 to this length before
                            analysis.
    --r2-length=NUM     Hard trim the input Read 2 to this length before
                            analysis.
    --chemistry=CHEM    Assay configuration. NOTE: by default the assay
                            configuration is detected automatically, which
                            is the recommened mode. You usually will not need
                            to specify a chemistry. Options are: 'auto' for
                            autodetection, 'threeprime' for Single Cell 3',
                            'fiveprime' for  Single Cell 5', 'SC3Pv1' or
                            'SC3Pv2' or 'SC3Pv3' for Single Cell 3' v1/v2/v3,
                            'SC5P-PE' or 'SC5P-R2' for Single Cell 5'.
                            paired-end/R2-only. Default: auto.
    --no-libraries      Proceed with processing using a --feature-ref but no
                            feature-barcoding data specified with the
                            'libraries' flag.
    --lanes=NUMS        Comma-separated lane numbers.
    --indices=INDICES   Comma-separated sample index set "SI-001" or sequences.
    --project=TEXT      Name of the project folder within a mkfastq or
                            bcl2fastq-generated folder to pick FASTQs from.

Note: 'cellranger count' can be called in two ways, depending on how you
demultiplexed your BCL data into FASTQ files.

1. If you demultiplexed with 'cellranger mkfastq' or directly with
   Illumina bcl2fastq, then set --fastqs to the project folder containing
   FASTQ files. In addition, set --sample to the name prefixed to the FASTQ
   files comprising your sample. For example, if your FASTQs are named:
       subject1_S1_L001_R1_001.fastq.gz
   then set --sample=subject1

2. If you demultiplexed with 'cellranger demux', then set --fastqs to a
   demux output folder containing FASTQ files. Use the --lanes and --indices
   options to specify which FASTQ reads comprise your sample.
   This method is deprecated. Please use 'cellranger mkfastq' going forward.
```

## Mkfastq

```
/app/easybuild/software/cellranger/3.0.2/cellranger-cs/3.0.2/bin
cellranger mkfastq (3.0.2)
Copyright (c) 2019 10x Genomics, Inc.  All rights reserved.
-------------------------------------------------------------------------------

Run Illumina demultiplexer on sample sheets that contain 10x-specific sample
index sets, and generate 10x-specific quality metrics after the demultiplex.
Any bcl2fastq argument will work (except a few that are set by the pipeline
to ensure proper trimming and sample indexing). The FASTQ output generated
will be the same as when running bcl2fastq directly.

These bcl2fastq arguments are overridden by this pipeline:
    --fastq-cluster-count
    --minimum-trimmed-read-length
    --mask-short-adapter-reads

Usage:
    cellranger mkfastq --run=PATH [options]
    cellranger mkfastq -h | --help | --version

Required:
    --run=PATH              Path of Illumina BCL run folder.

Optional:
Sample Sheet
    --id=NAME               Name of the folder created by mkfastq.  If not
                                supplied, will default to the name of the
                                flowcell referred to by the --run argument.
    --csv=PATH
    --samplesheet=PATH
    --sample-sheet=PATH     Path to the sample sheet.  The sample sheet can either
                                be a simple CSV with lane, sample and index columns,
                                or an Illumina Experiment Manager-compatible
                                sample sheet.  Sample sheet indexes can refer to
                                10x sample index set names (e.g., SI-GA-A12).
    --simple-csv=PATH       Deprecated.  Same meaning as --csv.
    --ignore-dual-index     On a dual-indexed flowcell, ignore the second sample
                                index, if the second sample index was not used
                                for the 10x sample.
    --qc                    Calculate both sequencing and 10x-specific metrics,
                                including per-sample barcode matching rate. Will
                                not be performed unless this flag is specified.

bcl2fastq Pass-Through
    --lanes=NUMS            Comma-delimited series of lanes to demultiplex.
                                Shortcut for the --tiles argument.
    --use-bases-mask=MASK   Same as bcl2fastq; override the read lengths as
                                specified in RunInfo.xml. See Illumina bcl2fastq
                                documentation for more information.
    --delete-undetermined   Delete the Undetermined FASTQ files left by
                                bcl2fastq.  Useful if your sample sheet is only
                                expected to match a subset of the flowcell.
    --output-dir=PATH       Same as in bcl2fastq. Folder where FASTQs, reports
                                and stats will be generated.
    --project=NAME          Custom project name, to override the samplesheet or
                                to use in conjunction with the --csv argument.


Note: 'cellranger mkfastq' can be called in two ways, depending on how you
demultiplexed your BCL data into FASTQ files.

1. If you demultiplexed with 'cellranger mkfastq' or directly with
   Illumina bcl2fastq, then set --fastqs to the project folder containing
   FASTQ files. In addition, set --sample to the name prefixed to the FASTQ
   files comprising your sample. For example, if your FASTQs are named:
       subject1_S1_L001_R1_001.fastq.gz
   then set --sample=subject1

2. If you demultiplexed with 'cellranger demux', then set --fastqs to a
   demux output folder containing FASTQ files. Use the --lanes and --indices
   options to specify which FASTQ reads comprise your sample.
   This method is deprecated. Please use 'cellranger mkfastq' going forward.



```

## Agg


```
/app/easybuild/software/cellranger/3.0.2/cellranger-cs/3.0.2/bin
cellranger aggr (3.0.2)
Copyright (c) 2019 10x Genomics, Inc.  All rights reserved.
-------------------------------------------------------------------------------

'cellranger aggr' aggregates the feature/cell count data
generated from multiple runs of the 'cellranger count' pipeline.

To run this pipeline, supply a CSV that enumerates the paths to the
aggregator_output.h5 files produced by 'cellranger count'.

Please see the following URL for details on the CSV format:
support.10xgenomics.com/single-cell/software

The commands below should be preceded by 'cellranger':

Usage:
    aggr
        --id=ID
        --csv=CSV
        [options]
    aggr <run_id> <mro> [options]
    aggr -h | --help | --version

Arguments:
    id      A unique run id, used to name output folder [a-zA-Z0-9_-]+.
    csv     Path of CSV file enumerating 'cellranger count' outputs.

Options:
Aggregation
    --description=TEXT  Sample description to embed in output files.
    --normalize=<mode>  Library depth normalization mode.
                            Valid values: mapped, raw, none [default: mapped].
    --nosecondary       Disable secondary analysis, e.g. clustering.


Note: 'cellranger aggr' can be called in two ways, depending on how you
demultiplexed your BCL data into FASTQ files.

1. If you demultiplexed with 'cellranger mkfastq' or directly with
   Illumina bcl2fastq, then set --fastqs to the project folder containing
   FASTQ files. In addition, set --sample to the name prefixed to the FASTQ
   files comprising your sample. For example, if your FASTQs are named:
       subject1_S1_L001_R1_001.fastq.gz
   then set --sample=subject1

2. If you demultiplexed with 'cellranger demux', then set --fastqs to a
   demux output folder containing FASTQ files. Use the --lanes and --indices
   options to specify which FASTQ reads comprise your sample.
   This method is deprecated. Please use 'cellranger mkfastq' going forward.


```


## Mkref


```
cellranger mkref --genome=$(basename $REF_DENOVO) --fasta=tmp_hg38.fasta --genes=tmp_hg38.gtf

--genome
--fasta
--genes

```