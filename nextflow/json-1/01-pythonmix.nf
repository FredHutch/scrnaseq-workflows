#!/usr/bin/env nextflow

params.str = 'Hello world!'

process splitLetters {

    output:
    file 'chunk_*' into letters mode flatten

    """
    printf '${params.str}' | split -b 6 - chunk_
    """
}


process convertToUpper {
    echo true

    input:
    stdin x from letters

    '''
    #!/usr/bin/env python
    import sys
    for file_loc in sys.stdin: #.readlines()
        #print('Now reading {}'.format(file_loc))
        with open(file_loc, 'r') as f:
            print(f'{f.read()}')
    '''
}