#!/usr/bin/env nextflow

// Set default values for parameters
// These can be changed when invoking the script by setting (e.g.) --ref_name hg37
params.json_loc = "hg38"
json_loc = params.ref_name


// REFERENCE FILES
params.jq_runs_query = ".runs[] | [.group_label,.raw_location,.csv_location,.fastq_output_dir] | @tsv"
json_file = file(params.json_loc)


process parseInputRuns {
    input:
    file json_input from json_file
    val jq_query from params.jq_runs_query

    output:
    set into run_label_ch

    """
    cat $json_input | jq -r $jq_query
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

