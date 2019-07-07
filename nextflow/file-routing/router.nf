#!/usr/bin/env nextflow

params.folder = '/Users/dnambi/Documents/GitHub/scrnaseq-workflows/nextflow/file-routing/scratch'

process createSampleFiles {

    output:
    dir '*/*.txt' into sample_files

    """
    mkdir -p a
    mkdir -p b
    echo 'sample1' > 'a/alpha.txt'
    echo 'sample2' > 'b/beta.txt'
    echo 'sample3' > 'a/echo.txt'
    """
}



process echoFiles {
    echo true

    input:
    file x from sample_files.collect()

    output:
    stdout result

    """
    CURRENTPROC=\$\$
    echo "Current proc is \$CURRENTPROC"
    echo "File is \$PWD/${x}"
    echo "\$CURRENTPROC \$(cat ${x})"
    echo "Raw file:"
    cat ${x}
    """
}

