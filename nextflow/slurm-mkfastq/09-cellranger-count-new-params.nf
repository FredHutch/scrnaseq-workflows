#!/usr/bin/env nextflow

params.base_raw_dir = ''
params.base_sample_dir = ''
params.base_working_dir = ''

params.ref_addon = ''
params.ref_name = ''
params.gtf_addon = ''
params.gtf_hg = ''

params.ref_denovo = ''

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


process parseJsonInput {

    input:
    stdin json_input from json_file

    output:
    file 'runs*' into count_ch
    file 'samples*' into sample_ch

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


process rangerCreateTranscriptome {
    
    output:
    stdout transcript_loc into transcript_ch

    """
    echo "\\fake\\transcriptome\\directory"
    """
}


process rangerCount {
    echo = true

    input:
    file params from count_ch.flatMap()
    val transcript_loc from transcript_ch
    val force_cells from params.count_force_cells
    val expect_cells from params.count_expect_cells

    """
    ID="\$(cat $params | jq -r '.group_label')"
    RAW_LOCATION="\$(cat $params | jq -r '.raw_location')"
    CSV_LOCATION="\$(cat $params | jq -r '.csv_location')"
    FASTQ_OUTPUT_DIR="\$(cat $params | jq -r '.fastq_output_dir')"

    echo "ID (label) is \$ID"
    echo "Raw location is \$RAW_LOCATION"
    echo "Csv is \$CSV_LOCATION"
    echo "Fastq output goes to \$FASTQ_OUTPUT_DIR"
    echo "transcriptome location is $transcript_loc"
    echo "force cells is $force_cells"
    echo "expect cells is $expect_cells"

    COMMAND="cellranger count -id=\$ID -transcriptome=$transcript_loc"\
        " -fastqs=\$FASTQ_OUTPUT_DIR"
    COMMAND
        "
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

process singleSample {
    echo = true

    input:
    file sample from sample_ch.flatMap()

    """
    SAMPLE_LABEL="\$(cat $sample)"

    echo "Sample label is \$SAMPLE_LABEL"
    """
}
