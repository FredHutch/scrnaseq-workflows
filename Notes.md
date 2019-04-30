# scRNA-seq Notes

## Script Notes

After doing some basic setup, it runs 3 steps:

1. cellranger fastq
2. cellranger count 
3. cellranger agg

The first 2 run in a for loop that seems *perfect* to parallelize. The 3rd step runs in a loop as well, although parallel-ization may be a little interesting if it's doing aggregations.

So, we're looking for a system that'll take some parameters/collections as inputs, start up a set of parallel jobs, wait for them to complete, then do *another* set of parallel jobs, etc. A pretty classic batch-computing workflow setup.



## Workflow Tool Options

If we're looking for a kind of workflow tool, there are a few options available...

### Slurm + Shell Scripts

This is the simplest, since we don't use any new tools. It would be the fastest to try out, and to validate that

However, it doesn't allow for any sort of management/automation/service work, so extending this to other researchers would require them to be familiar with Rhino/Gizmo/Slurm basics. 


### Snakemake

* [Existing Snakemake code](https://bitbucket.org/robert_amezquita/seqsnake/src)
* This is probably the lightest-weight workflow system we could use 'in front of' Slurm
* We could use basic JSON for parameters/object arrays, and use Snakemake to decompose them into the parallel commands to run. 
* Easy to try out
* Same management/automation/service headaches as basic Slurm/Shell scripts, though. Adoption by others would be tricky
* [Snakemake docs](https://snakemake.readthedocs.io/en/stable/)


### Cromwell

* Cromwell kinda-sorta works with Slurm, but we can't use Docker containers here. Could make it work with modules (per Dan)
* The service Scicomp is building from Cromwell is AWS-only, at least for now. 
* We could run Cromwell locally (as it was originally designed to do), and use it as a front-end to connect to Slurm. That would put the burden on researchers to do the install, though.


### Nextflow

* GitHub - https://github.com/nextflow-io/nextflow#quick-start
   * This supports Slurm as a back-end. That could work well.
* Nextflow might work well for this, since it supports Slurm (or so we've been told)
* However, we don't have a license yet, and it could be pricey. So there would be unavoidable delay as that gets worked out
* Sam Minot is driving these conversations.
   * "Pablo has helpfully provided the slides from his talk last week on Nextflow and Lifebit for your reference or review — https://drive.google.com/file/d/1orWXkoUdziDCZKOd-dIfj5WaLvWhWBcf/view "






## Background, FH On-Premises HPC

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

