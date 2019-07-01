#!/usr/bin/env nextflow

// Set default values for parameters
// These can be changed when invoking the script by setting (e.g.) --ref_name hg37
params.ref_name = "hg38"
ref_name = params.ref_name


// REFERENCE FILES
params.base = "/fh/fast/_HDC/cortex/dnambi/workflows"
params.ref_base = "/fh/fast/_HDC/cortex/dnambi/workflows/reference/cellranger"
params.ref_hg = "/refdata-cellranger-mm10-1.2.0/fasta/genome.fa"
params.gtf_hg = "/refdata-cellranger-mm10-1.2.0/genes/genes.gtf"
params.ref_addon = "/roba/data-meta/cart-sequence/addon.fa"
params.gtf_addon = "/roba/data-meta/cart-sequence/addon.gtf"
params.ref_denovo = "cart-bcma"

//Debug local variable values
//params.base = "/Users/dnambi/Documents/GitHub/scrnaseq-workflows/nextflow/slurm-mkref"
//params.ref_hg = "/genome.fa"
//params.gtf_hg = "/genes.gtf"
//params.gtf_addon = "/addon.gtf"
//params.ref_addon = "/addon.fa"


process combineDenovoAddons {
    input:
    file file_ref_addon from file(params.base + params.ref_addon)
    file ref_name from file(params.ref_base+params.ref_name)
    file ref_hg from file(params.ref_base+params.ref_hg)
    file gtf_addon from file(params.base+params.gtf_addon)
    file gtf_hg from file(params.ref_base+params.gtf_hg)

    output:
    file("tmp_${ref_name}.fasta") into denovo_addon_fasta_ch
    file("tmp_${ref_name}.gtf") into denovo_addon_gtf_ch

    """
    cat ${file_ref_addon} ${ref_hg} > tmp_${ref_name}.fasta
    cat ${gtf_addon} ${gtf_hg} > tmp_${ref_name}.gtf
    """
}


process createDenovoReference {
    echo = true

    input:
    file(input_fasta) from denovo_addon_fasta_ch
    file(input_gtf) from denovo_addon_gtf_ch

    output:
    file({params.ref_denovo}) into denovo_ref_ch

    """
    echo "Genome ${params.ref_denovo}"
    echo "Fasta ${input_fasta}"
    echo "Genes ${input_gtf}"
    ml cellranger
    cellranger mkref --genome=${params.ref_denovo} --fasta=${input_fasta} --genes=${input_gtf}
    """
}