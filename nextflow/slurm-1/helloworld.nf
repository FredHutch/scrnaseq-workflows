#!/usr/bin/env nextflow

// Set default values for parameters
// These can be changed when invoking the script by setting (e.g.) --ref_name hg37
params.ref_name = "hg38"
ref_name = params.ref_name


// REFERENCE FILES
params.base = "/fh/fast/gottardo_r/ramezqui_working/analysis/gottardo_10x-pont-bcma-all"
params.ref_base = "/fh/fast/gottardo_r/ramezqui_working/reference/cellranger"
params.ref_hg = "refdata-cellranger-hg38-1.2.0/fasta/genome.fa"
params.gtf_hg = "refdata-cellranger-hg38-1.2.0/genes/genes.gtf"
params.ref_addon = "data-meta/cart-sequence/addon.fa"
params.gtg_addon = "data-meta/cart-sequence/addon.gtf"
params.ref_denovo = "data-raw/reference/cart-bcma"
params.force-cells = 10000



process parseInputRuns {
    input:

    output:
    set into run_label_ch

    """
    jq
    """
}

process parseInputSamples {
    input:

    output:
    set into sample_label_ch

    """
    jq
    """
}


process combineDenovoAddons {
    input:
    val base from params.base
    file ref_addon from file(params.ref_addon)
    file ref_name from file(params.ref_name)
    file gtf_addon from file(params.gtf_addon)
    file gtf_hg from file(params.gtf_hg)

    output:
    set val(base), file("tmp_${ref_name}.fasta") into denovo_addon_fasta_ch
    set val(base), file("tmp_${ref_name}.gtf") into denovo_addon_gtf_ch

    """
    cat ${ref_addon} ${ref_hg} > tmp_${ref_name}.fasta
    cat ${gtf_addon} ${gtf_hg} > tmp_${ref_name}.gtf
    """
}


process createDenovoReference {
    input:
    set val(base), file(input_fasta) from denovo_ref_fasta_ch
    set val(gtf_base), file(input_gtf) from denovo_ref_gtf_ch
    val ref_denovo from params.ref_denovo

    output:
    set val(ref_denovo), file(ref_denovo) into denovo_ref_ch

    """
    cellranger mkref --genome={ref_denovo} --fasta={input_fasta} --genes={input_gtf}
    """
}


// makes a FastQ file from 
process makeFastQ {
    input:
    set val(group_label), file(raw-location), file(csv-location), file(fastq-output-dir) from run_label_ch

    output:
    set val(), file(fastq-output-dir) into fastq_run_ch

    """
    cellranger mkfastq \
           --id=${group_label} \
           --run=${raw-location} \
           --simple-csv=${csv-location} \
           --output-dir=${fastq-output-dir} \
           --delete-undetermined
    """
}




process countQuantification {
    input:
    val force-cells from params.force-cells
    set val(), file(ref_denovo) denovo_ref_ch
    set val(), file(fastq-dir) from fastq_run_ch
    set val(sample-label) from sample_label_ch

    output:
    set 

    """
    cellranger count \
           --id=${sample-label} \
           --transcriptome=${ref_denovo} \
           --fastqs=${fastq-dir} \
           --force-cells={force-cells} \
           --nosecondary
    """

}

process sampleAggregation {
    input:


    output:


    """
for I in $(ls $BASE/data-meta/aggregate/aggregate*all.csv); do 
    echo "Aggregating on $I .."
    cellranger aggr \
       --id=$(basename $I .csv) \
       --csv=$I
done
    """

}

