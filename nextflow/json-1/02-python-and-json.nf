#!/usr/bin/env nextflow

params.jsonloc = 'process10x.json'
jsonfile = file(params.jsonloc)

process convertToUpper {
    echo true

    input:
    stdin jsoninput from jsonfile

    '''
    #!/usr/bin/env python
    import sys
    import json
    file_loc = sys.stdin.readlines()
    input_dict = {}
    with open(file_loc[0], 'r') as f:
        input_dict = json.loads(f.read())
    print (input_dict.keys())
    '''
}