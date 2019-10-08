#!/usr/bin/env nextflow


// REFERENCE FILES
params.base = "/home/dnambi/nextflow/kallisto"

// PART A: Create channels for each file
sample_ch = Channel.fromPath ( params.base + '/samples/*' )
r1_ch = Channel.fromPath( params.base + '/r1/*' )
r2_ch = Channel.fromPath( params.base + '/r2/*' )

merged_ch = Channel.create()

sample_ch
    .merge (r1_ch, r2_ch)
    .into (merged_ch)

process genChannels {
    echo = true

    input:
    set sample, r1, r2 from merged_ch

    script:
    """
    echo "Sample $sample , r1 $r1 , r2 $r2"
    """
}

