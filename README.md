# scrnaseq-workflows

This is a repo for developing workflows for scRNAseq processes. 


# Process Notes

This has process updates and status for the scRNAseq workflow work. It's intended to be informative and not polished/pretty.


### To Do, Current

* Convert workflow B to Snakemake, document the steps
* Convert workflow B to Nextflow, document the steps

### Upcoming



* Convert workflow A to Snakemake, document the steps
* Convert workflow A to Nextflow, document the steps

* Chat with Rob & Valentin, get their feedback
* Evaluate everything - *use matrix prioritization for scoring?*



### Done

**Installations**

* [Install Snakemake](https://github.com/FredHutch/scrnaseq-workflows/blob/master/snakemake/Notes.md)
* [Install Cromwell](https://github.com/FredHutch/scrnaseq-workflows/blob/master/cromwell/Notes.md)
* [Install Nextflow](https://github.com/FredHutch/scrnaseq-workflows/tree/master/nextflow)

**Hello World**

* [Hello-world for Snakemake](https://github.com/FredHutch/scrnaseq-workflows/blob/master/snakemake/Notes.md)
* [Hello-world for Slurm/Gizmo](https://github.com/FredHutch/scrnaseq-workflows/tree/master/slurm)
* [Hello-world for Nextflow](https://github.com/FredHutch/scrnaseq-workflows/tree/master/nextflow)
* [Hello-world for Cromwell](https://github.com/FredHutch/scrnaseq-workflows/tree/master/cromwell)

**Re-run Existing Scripts**

* [Re-run the scRNAseq workflow scripts RobA (workflow A) provided](https://github.com/FredHutch/scrnaseq-workflows/tree/master/repro)
   * Use https://www.biostars.org/p/174331/ to get the hg38 files?
* [Re-run the scRNAseq workflow scripts Valentin (workflow B) provided](https://github.com/FredHutch/scrnaseq-workflows/tree/master/repro)

**Convert Existing Scripts**

TBD...

**Abandoned, not as useful**

* Convert workflow A to Cromwell, document the steps
* Convert workflow B to Cromwell, document the steps
* Convert workflow A to Slurm, document the steps
* Convert workflow B to Slurm, document the steps



# Discussion Resources

* https://www.reddit.com/r/bioinformatics/comments/99q70h/anyone_using_cwl_or_wdl_on_an_hpc_cluster/
* https://www.reddit.com/r/bioinformatics/comments/a4fq4i/given_the_experience_of_others_writing/
* https://twitter.com/AlbertVilella/status/1069534511359279104
* https://www.reddit.com/r/bioinformatics/comments/4jyjwk/your_favorite_workflow_manager/
* https://www.reddit.com/r/bioinformatics/comments/4gvou4/experiences_with_workflow_specification_and/
* https://www.biostars.org/p/219748/
* https://www.biostars.org/p/321841/
* https://www.reddit.com/r/bioinformatics/comments/73am0k/ncbi_hackathons_discussions_on_bioinformatics/ <- super useful
* https://www.biostars.org/p/258436/
* https://www.biostars.org/p/91301/
* https://www.biostars.org/p/91301/ <- another critically useful one

* CWL is too much of a wire protocol to be much use
* Not much adoption of Cromwell.

* https://gitter.im/nextflow-io/nextflow <- nextflow chat