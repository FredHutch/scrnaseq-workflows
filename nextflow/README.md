# Nextflow Notes


## Installation

* Based on https://bioconda.github.io/recipes/nextflow/README.html

```
conda config --add channels bioconda

conda install nextflow



```

## Nextflow Tutorial ('Hello World')

* Based on https://www.nextflow.io/docs/latest/getstarted.html#your-first-script

```
# save tutorial.nf
nextflow tutorial.nf
nextflow tutorial.nf -resume   # re-do the workflow, but re-run any changed parts
nextflow tutorial.nf --str 'Bonjour le monde'   # double-dashes replace the 'str' parameter with the value you enter
```

### Ideas

* Uses the dataflow programming model
* A nextflow pipeline script is made by joining together different processes. Each process is written in any language that can run on Linux (Bash, Python, etc)
* Processes communicate only via FIFO queues called 'channels'


````
// Script parameters
params.query = "/some/data/sample.fa"
params.db = "/some/path/pdb"

db = file(params.db)
query_ch = Channel.fromPath(params.query)

process blastSearch {
    input:
    file query from query_ch

    output:
    file "top_hits.txt" into top_hits_ch

    """
    blastp -db $db -query $query -outfmt 6 > blast_result
    cat blast_result | head -n 10 | cut -f 2 > top_hits.txt
    """
}
````

* into top_hits_ch <- sends something into a channel
* 



# Resources

* https://github.com/nf-core/chipseq
* https://github.com/nf-core/rnaseq
* https://github.com/nf-core/scrnaseq


## Sam Minot's Talk

* Entire talk - https://www.minot.bio/slides 
* https://github.com/FredHutch/reproducible-workflows
* https://github.com/nf-core
* https://sciwiki.fredhutch.org/compdemos/nextflow/
* https://biocontainers.pro/#/registry <- pre-built Docker containers

* Run one workflow from one working directory on your machine/Rhino. That way it makes concurrent workflows relatively easy to do 
* Use tmux or screen for whatever is running your workflow script (for example, on Rhino)

We now have a working module for Nextflow on rhino / gizmo! You can run
```ml nextflow/19.04.1```
to load a working version of Nextflow that is able to run jobs on AWS
































