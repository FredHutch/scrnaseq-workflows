#!/usr/bin/env nextflow

params.jsonloc = 'process10x.json'
json_file = file(params.jsonloc)

process parseJsonInput {
    echo true

    input:
    stdin json_input from json_file

    '''
    #!/usr/bin/env python
    import sys
    import json

    file_loc = sys.stdin.readlines()
    input_dict = {}
    with open(file_loc[0], 'r') as f:
        input_dict = json.loads(f.read())
    
    for run in input_dict.get('runs',[]):
        print ('{}'.format(run.get('group_label')))
    '''
}