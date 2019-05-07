# Snakemake Notes


## Installation

* Based on https://snakemake.readthedocs.io/en/stable/getting_started/installation.html

```
conda update conda  # get the latest code for conda

conda install -c bioconda -c conda-forge snakemake
```

## Snakemake Tutorial ('Hello World')

from https://snakemake.readthedocs.io/en/stable/tutorial/setup.html#step-4-activating-the-environment

```
mkdir snakemake-tutorial
cd snakemake-tutorial


wget https://bitbucket.org/snakemake/snakemake-tutorial/get/v5.2.3.tar.bz2
tar -xf v5.2.3.tar.bz2 --strip 1

conda env create --name snakemake-tutorial --file environment.yaml

conda activate snakemake-tutorial

snakemake --help
```