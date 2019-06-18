#!/usr/bin/env nextflow

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


run_ch
    .flatMap()
    .subscribe { println "File: ${it.name} => ${it.text}" }