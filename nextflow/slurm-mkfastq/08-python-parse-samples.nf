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

process singleRun {
    echo = true

    input:
    file run from run_ch.flatMap()

    """
    GROUP_LABEL="\$(cat $run | jq -r '.group_label')"
    RAW_LOCATION="\$(cat $run | jq -r '.raw_location')"
    CSV_LOCATION="\$(cat $run | jq -r '.csv_location')"
    FASTQ_OUTPUT_DIR="\$(cat $run | jq -r '.fastq_output_dir')"

    echo "Group label is \$GROUP_LABEL"
    echo "Raw location is \$RAW_LOCATION"
    echo "Csv is \$CSV_LOCATION"
    echo "Fastq output goes to \$FASTQ_OUTPUT_DIR"
    """
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
