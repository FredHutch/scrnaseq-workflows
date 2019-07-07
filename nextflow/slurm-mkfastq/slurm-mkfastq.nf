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


process parseJsonInput {
    input:
    stdin json_input from json_file

    output:
    file 'runs*' into run_ch

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
    '''
}

process rangerMkfastq {
    echo = true

    input:
    file run from run_ch.flatMap()

    output:
    file 'samples*' into sample_ch
    # filter/categorize this by sample info

    """
    GROUP_LABEL="\$(cat $run | jq -r '.group_label')"
    RAW_LOCATION="\$(cat $run | jq -r '.raw_location')"
    CSV_LOCATION="\$(cat $run | jq -r '.csv_location')"
    FASTQ_OUTPUT_DIR="\$(cat $run | jq -r '.fastq_output_dir')"

    echo "Group label is \$GROUP_LABEL"
    echo "Raw location is \$RAW_LOCATION"
    echo "Csv is \$CSV_LOCATION"
    echo "Fastq output goes to \$FASTQ_OUTPUT_DIR"
    echo "cellranger mkfastq --id=\$GROUP_LABEL --run=\$RAW_LOCATION --simple-csv=$CSV_LOCATION --output-dir=\$FASTQ_OUTPUT_DIR --delete-undetermined"


    """
}

process collateSampleFiles {
    echo = true

    input:
    file fastq from sample_ch

    """
    GROUP_LABEL="\$(cat $run | jq -r '.group_label')"
    RAW_LOCATION="\$(cat $run | jq -r '.raw_location')"
    CSV_LOCATION="\$(cat $run | jq -r '.csv_location')"
    FASTQ_OUTPUT_DIR="\$(cat $run | jq -r '.fastq_output_dir')"

    echo "Group label is \$GROUP_LABEL"
    echo "Raw location is \$RAW_LOCATION"
    echo "Csv is \$CSV_LOCATION"
    echo "Fastq output goes to \$FASTQ_OUTPUT_DIR"
    echo "cellranger mkfastq --id=\$GROUP_LABEL --run=\$RAW_LOCATION --simple-csv=$CSV_LOCATION --output-dir=\$FASTQ_OUTPUT_DIR --delete-undetermined"


    """
}
