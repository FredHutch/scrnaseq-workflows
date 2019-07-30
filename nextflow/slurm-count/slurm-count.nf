#!/usr/bin/env nextflow

// Set default values for parameters
// These can be changed when invoking the script by setting (e.g.) --ref_name hg37
params.ref_name = "hg38"
ref_name = params.ref_name
params.denovo = false


// REFERENCE FILES
params.base = "/fh/fast/_HDC/cortex/dnambi/workflows"
params.ref_base = "/fh/fast/_HDC/cortex/dnambi/workflows/reference/cellranger"
params.ref_hg = "/refdata-cellranger-mm10-1.2.0/fasta/genome.fa"
params.gtf_hg = "/refdata-cellranger-mm10-1.2.0/genes/genes.gtf"
params.ref_addon = "/roba/data-meta/cart-sequence/addon.fa"
params.gtf_addon = "/roba/data-meta/cart-sequence/addon.gtf"
params.ref_denovo = "cart-bcma"

params.base_raw_dir = "/shared/ngs/illumina/mpont"
params.base_working_dir = "/fh/fast/_HDC/cortex/dnambi/workflows/count"
params.base_sample_dir = "/fh/fast/_HDC/cortex/dnambi/workflows/count"
params.count_flags = " --force-cells=10000 --nosecondary"

params.jsonloc = 'process10x.json'
json_file = file(params.jsonloc)

params.count_expect_cells = '999'


/**
The number of iterations of the algorithm

@name: force cells
@type: int
@range: {0,infinity}
*/
params.count_force_cells = 666
params.count_nosecondary = ''



// PART A: PARSE INPUTS AND CREATE PARAMETER CHANNELS
process parseJsonInput {

    input:
    stdin json_input from json_file

    output:
    file 'runs*' into run_ch, run_ch2
    file 'samples*' into sample_ch, sample_ch2

    '''
    #!/usr/bin/env python
    import sys
    import json
    import uuid

    file_loc = sys.stdin.readlines()
    input_dict = {}
    with open(file_loc[0], 'r') as f:
        input_dict = json.loads(f.read())
    # now write out each run as its own JSON
    for run in input_dict.get('runs',[]):
        file_name = 'runs-{}'.format(uuid.uuid4())
        with open(file_name,'w') as o:
            o.write(json.dumps(run))
    # now write out each sample as its own JSON
    for sample in input_dict.get('samples',[]):
        file_name = 'samples-{}'.format(uuid.uuid4())
        with open(file_name,'w') as o:
            o.write(sample)
    '''
}




// PART B: Create a denovo reference, if needed
process combineDenovoAddons {
    input:
    file file_ref_addon from file(params.base + params.ref_addon)
    file ref_name from file(params.ref_base+params.ref_name)
    file ref_hg from file(params.ref_base+params.ref_hg)
    file gtf_addon from file(params.base+params.gtf_addon)
    file gtf_hg from file(params.ref_base+params.gtf_hg)

    when:
    params.denovo == true

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




// PART C: RUN CELLRANGER MKFASTQ
process rangerMkfastq {
    echo = true

    input:
    file run from run_ch.flatMap()
    val raw_base from params.base_raw_dir
    val working_base from params.base_working_dir

    output:
    val run_name into fastq_semaphore

    script:
    run_name = run.name
    """
    GROUP_LABEL="\$(cat $run | jq -r '.group_label')"
    RAW_LOCATION="\$(cat $run | jq -r '.raw_location')"
    CSV_LOCATION="\$(cat $run | jq -r '.csv_location')"
    FASTQ_OUTPUT_DIR="\$(cat $run | jq -r '.fastq_output_dir')"

    echo "Group label is \$GROUP_LABEL"
    echo "Raw location is $raw_base/\$RAW_LOCATION"
    echo "Csv is $working_base/\$CSV_LOCATION"
    echo "Fastq output goes to $working_base/\$FASTQ_OUTPUT_DIR"

    ml bzip2/1.0.6-foss-2016b
    ml bcl2fastq
    ml cellranger
    cellranger mkfastq --id=\$GROUP_LABEL --run=$raw_base/\$RAW_LOCATION --simple-csv=$working_base/\$CSV_LOCATION --output-dir=$working_base/\$FASTQ_OUTPUT_DIR --delete-undetermined
    """
}


// PART C2: Flatten the sample directories down so they're easily accessible
process flattenSampleDirectories {
    echo = true

    input:
    val fastq from fastq_semaphore.collect()
    val sample_base from params.base_sample_dir
    file sample from sample_ch2.flatMap()

    output:
    val 'Linkage made' into flatdir_semaphore

    script:
    """
    SAMPLE_LABEL="\$(cat $sample)"

    mkdir -p $sample_base/data-raw/fastq/samples
    cd $sample_base/data-raw/fastq/samples

    echo "Flatten directories sample label is \$SAMPLE_LABEL"
    LINKCOUNT=\$(ls -la | grep \$SAMPLE_LABEL | wc -l)
    if [ \$LINKCOUNT = 0 ]; then
        ln -s \$PWD/../runs/*/*/\$SAMPLE_LABEL .
    else
        echo "ln -s already exists for \$SAMPLE_LABEL , skipping"
    fi
    """
}




// PART D: RUN CELLRANGER COUNT
process rangerCount {
    echo = true

    input:
    file run from run_ch2.flatMap()
    val transcript_loc from params.ref_denovo
    val sample_base from params.base_sample_dir
    val run_denovo from params.denovo
    val flat_dirs from flatdir_semaphore
    val flags from params.count_flags

    """
    ID="\$(cat $run | jq -r '.group_label')"
    FASTQ_OUTPUT_DIR="\$(cat $run | jq -r '.fastq_output_dir')"

    echo "ID (label) is \$ID"
    echo "Fastq is at \$FASTQ_OUTPUT_DIR"
    echo "transcriptome location is $transcript_loc"

    mkdir -p $sample_base/data-raw/counts
    cd $sample_base/data-raw/counts

    COMMAND="cellranger count --id=\$ID --fastqs=$sample_base/\$FASTQ_OUTPUT_DIR $flags"
    if [ $run_denovo = "true" ]; then
        COMMAND="\$COMMAND --transcriptome=$transcript_loc"
    fi
    
    ml cellranger
    echo "Command: \$COMMAND"
    eval \$COMMAND
    """

    /**
    NEW CALL:
    cellranger count \
        -id = $ID
        -transcriptome = $TRANSCRIPT_LOC
        -feature-ref = $FEATURE_REF
        -expect-cells = $EXPECT_CELL_COUNT
        -libraries = $LIBRARIES
        -fastqs = $FASTQ_DIR
        -force-cells = $FORCE_CELL_COUNT
        -nosecondary (optional param)
    */

    /*
    ORIGINAL CALLS:
    cellranger count \
           --id=${SAMPLE_LABELS[$I]} \
           --transcriptome=$REF_DENOVO \
           --fastqs=$SAMPLE_DIR/${SAMPLE_LABELS[$I]} \
           --force-cells=10000 \
           --nosecondary

    cellranger count --id=X663_1919_PBMC \
                 --transcriptome=/fh/fast/gottardo_r/vvoillet_working/Reference_genomes/refdata-cellranger-GRCh38-3.0.0_WT1 \
          --libraries=libraries_X663_1919_PBMC.csv \
                 --feature-ref=5GEX_protein_feature_ref_2019-04-15.csv \
                 --expect-cells=8000
    */
}