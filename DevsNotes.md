# scRNA-seq Notes


## Workflow Tool Options

If we're looking for a kind of workflow tool, there are a few options available...

### Slurm + Shell Scripts

This is the simplest, since we don't use any new tools. It would be the fastest to try out, and to validate that

However, it doesn't allow for any sort of management/automation/service work, so extending this to other researchers would require them to be familiar with Rhino/Gizmo/Slurm basics. 

### Cromwell

* Cromwell kinda-sorta works with Slurm, but we can't use Docker containers here. Could make it work with modules (per Dan)
* The service Scicomp is building from Cromwell is AWS-only, at least for now. 
* We could run Cromwell locally (as it was originally designed to do), and use it as a front-end to connect to Slurm. That would put the burden on researchers to do the install, though.


### Nextflow

* Nextflow might work well for this, since it supports Slurm (or so we've been told)
* However, we don't have a license yet, and it could be pricey. So there would be unavoidable delay as that gets worked out
* Sam Minot is driving these conversations.
   * "Pablo has helpfully provided the slides from his talk last week on Nextflow and Lifebit for your reference or review — https://drive.google.com/file/d/1orWXkoUdziDCZKOd-dIfj5WaLvWhWBcf/view "


### Snakemake







### Rob's Code

* What is cellranger?
* What is chip-seq?
* What is Salmon/alevin?
* What is snakemake?


### Background, FH On-Premises HPC

* [Overview of FH Compute](https://sciwiki.fredhutch.org/computing/comp_index/)
* What is gizmo & rhino?
   * Gizmo is the HPC cluster. Not interactive
   * Rhino is Interactive linux for small computation
   * See [Resource Overview](https://sciwiki.fredhutch.org/computing/resource_overview/)
* What is slurm?
   * A parallel processing engine, https://sciwiki.fredhutch.org/compdemos/cluster_parallel/
   * First, read [Using Slurm on FH Systems](https://sciwiki.fredhutch.org/computing/cluster_usingSlurm/)
   * Check out [Slurm examples](https://github.com/FredHutch/slurm-examples)
* What is sbatch?
   * A [Slurm command](https://sciwiki.fredhutch.org/computing/cluster_usingSlurm/)
* What is singularity?
   * Can [run Docker containers](https://sciwiki.fredhutch.org/compdemos/Singularity/)

