#!/usr/bin/env nextflow

params.base_raw_dir = "/shared/ngs/illumina/mpont"
params.base_working_dir = "/fh/fast/_HDC/cortex/dnambi/workflows/mkfastq"
params.base_sample_dir = "/fh/fast/_HDC/cortex/dnambi/workflows/mkfastq"

params.jsonloc = 'process10x.json'
json_file = file(params.jsonloc)


process parseJsonInput {

    input:
    stdin json_input from json_file

    output:
    file 'runs*' into run_ch
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
    echo "Raw location is \$RAW_LOCATION"
    echo "Csv is \$CSV_LOCATION"
    echo "Fastq output goes to $raw_base\$FASTQ_OUTPUT_DIR"

    ml cellranger
    cellranger mkfastq --id=\$GROUP_LABEL --run=$raw_base/\$RAW_LOCATION --simple-csv=$working_base/\$CSV_LOCATION --output-dir=$working_base/\$FASTQ_OUTPUT_DIR --delete-undetermined
    """
}

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
