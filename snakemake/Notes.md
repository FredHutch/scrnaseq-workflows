# Snakemake Notes


## Installation

* Based on https://snakemake.readthedocs.io/en/stable/getting_started/installation.html

```
conda update conda  # get the latest code for conda

conda install -c bioconda -c conda-forge snakemake
```

## Snakemake Tutorial ('Hello World')

from https://snakemake.readthedocs.io/en/stable/tutorial/setup.html#step-4-activating-the-environment

### Scripts

* From https://snakemake.readthedocs.io/en/stable/tutorial/basics.html

```
mkdir snakemake-tutorial
cd snakemake-tutorial


wget https://bitbucket.org/snakemake/snakemake-tutorial/get/v5.2.3.tar.bz2
tar -xf v5.2.3.tar.bz2 --strip 1

conda env create --name snakemake-tutorial --file environment.yaml

conda activate snakemake-tutorial
```

```
snakemake -np mapped_reads/A.bam # dry-run because of -n
snakemake -p mapped_reads/A.bam    #runs it, prints the commands because of -p
```

*Generalize bwa_map, then:*

```
snakemake -np mapped_reads/B.bam
```

*Run on multiple output files*

```
snakemake -np mapped_reads/A.bam mapped_reads/B.bam
# or
snakemake -np mapped_reads/{A,B}.bam
```

*Multi-job dependencies*

```
snakemake -np sorted_reads/B.bam
```

*Show the DAG*

```
snakemake --dag sorted_reads/{A,B}.bam.bai | dot -Tsvg > dag.svg
```


*Aggregate inputs*

```
expand("sorted_reads/{sample}.bam", sample=SAMPLES) #goes into snakemake file
# creates ["sorted_reads/A.bam", "sorted_reads/B.bam"]
```

*Use a [custom script](https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html#snakefiles-external-scripts)*

```
rule plot_quals:
    input:
        "calls/all.vcf"
    output:
        "plots/quals.svg"
    script:
        "scripts/plot-quals.py"

# all properties of Snakemake are available as a global object, i.e.:

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pysam import VariantFile

quals = [record.qual for record in VariantFile(snakemake.input[0])]
plt.hist(quals)

plt.savefig(snakemake.output[0])
```

*Protected files - long-running process*

Use protected()

```
rule NAME:
    input:
        "path/to/inputfile"
    output:
        protected("path/to/outputfile")
    shell:
        "somecommand {input} {output}"
```

*Temporary file - delete after run (garbage collect)*

Use temp()

```
rule NAME:
    input:
        "path/to/inputfile"
    output:
        temp("path/to/outputfile")
    shell:
        "somecommand {input} {output}"
```

*Directories as outputs*

```
rule NAME:
    input:
        "path/to/inputfile"
    output:
        directory("path/to/outputdir")
    shell:
        "somecommand {input} {output}"
```

*Ignore timestamps, always re-run*

Use 'ancient'

```
rule NAME:
    input:
        ancient("path/to/inputfile")
    output:
        "path/to/outputfile"
    shell:
        "somecommand {input} {output}"
```


### Learned

* You specify the *output file* you want, and snakemake reverse-engineers the DAG to figure out what inputs to run. Intriguing.

* Snakemake figures out rules based on directory inputs and file matching. You don't explicitly specify the rules to run (hmmm, interesting...)


## Snakemake + Slurm

* https://bioinformatics.stackexchange.com/questions/4977/running-snakemake-on-cluster
* https://snakemake.readthedocs.io/en/stable/snakefiles/configuration.html