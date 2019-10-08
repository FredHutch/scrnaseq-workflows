#!/usr/bin/env nextflow


// REFERENCE FILES
params.base = "/home/ramezqui/analysis/_SODA"
params.index_base = "/home/ramezqui/work/reference/kallisto_ref/mus_musculus_with_tcrt-genes"
params.index = params.index_base + "/Mus_musculus_with_tcrt-genes.GRCm38.cdna.all.idx"
params.txp2gene = params.index_base + "/transcripts_to_genes.txt"
params.tenxwhitelist = "/home/ramezqui/work/reference/10x_whitelists/10xv2_whitelist.txt"
params.tenxwhitelist_ver = "10xv2"

params.output_dir = params.base + "/data-raw/kallisto-bustools"
params.job_outdir = params.base + "/data-raw/kb_sbatch"

params.threads = 8



// PART A: Create channels for each file
sample_ch = Channel.fromPath ( params.base + 'data-raw/fastq/*' )
r1_ch = Channel.fromPath( params.base + '/data-raw/fastq/*/*R1*.fastq.gz' )
r2_ch = Channel.fromPath( params.base + '/data-raw/fastq/*/*R2*.fastq.gz' )


// take the 3 channels and merge them together, to create 1 list for each <sample, r1, r2> combo
merged_ch = Channel.create()
sample_ch
    .merge (r1_ch, r2_ch)
    .into (merged_ch)



// PART B: Create working directories
process createDirectories {
    echo = true

    input:
    val outdir from params.output_dir
    val job_outdir from params.job_outdir

    output:
    val 'done' into dir_semaphore

    script:
    """
    mkdir -p $outdir
    mkdir -p $job_outdir
    """
}



// PART C: Execute the Kallisto command
// This runs once per <sample, r1, r2> combo , and can run in parallel
process runKallisto {
    echo = true

    input:
    set sample, r1, r2 from merged_ch
    val dirs from dir_semaphore.collect()

    val base from params.base
    val index_base from params.index_base
    val index from params.index
    val txp2gene from params.txp2gene
    val tenxwhitelist from params.tenxwhitelist
    val tenxwhitelist_ver from params.tenxwhitelist_ver
    val output_dir from params.output_dir
    val threads from params.threads

    script:
    """
    SAMPLE="\$(basename $sample)"
    echo "Sample is $sample , base sample is \$SAMPLE , R1 is $r1 , R2 is $r2"
    echo "Index $index , 10xver is $tenxwhitelist_ver , 10x is $tenxwhitelist"
    echo "Output dir is $output_dir , threads $threads"
    echo "txp2gene is $txp2gene"

    module purge
    module load kallisto
    module load bustools
    kallisto bus -i $index -o $output_dir/\$SAMPLE -x $tenxwhitelist_ver -t $threads \$R1 \$R2 
    cd $output_dir/\$SAMPLE; mkdir -p genecount tmp
    bustools correct -w $tenxwhitelist -p output.bus | bustools sort -T tmp/ -t 4 -p - | bustools count -o genecount/genes -g $txp2gene -e matrix.ec -t transcripts.txt --genecounts
    """
}

