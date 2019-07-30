# Nextflow

## Getting Started

* Based on [Bioconda/nextflow](https://bioconda.github.io/recipes/nextflow/README.html)

```
conda config --add channels bioconda
conda install nextflow
```

### Nextflow Tutorial ('Hello World')

* Based on https://www.nextflow.io/docs/latest/getstarted.html#your-first-script

```
# save tutorial.nf
nextflow tutorial.nf
nextflow tutorial.nf -resume   # re-do the workflow, but re-run any changed parts
nextflow tutorial.nf --str 'Bonjour le monde'   # double-dashes replace the 'str' parameter with the value you enter
```

### Concepts

Nextflow uses a dataflow programming model. There are a couple of basic concepts:

**Process**

A process is a step in a workflow that does a single thing, like 'run cellranger mkref' or 'split a JSON file into pieces for future steps'. Processes have 'input', 'output', 'when', and script code sections.

* ```Inputs``` are the input variables/channels to run the step. 
* ```Outputs``` are what is sent from a process to later steps. 
* ```When``` blocks make a process step conditional, so you can have a workflow that does different things based on flags. For example, you could have it be optional to create a denovo reference.

The script block is the actual Python3 or bash code, and is wrapped by either a """ or ''' line.

*Note: In this implementation all script blocks are either Python3 or shell (bash)*.

**Channel**

Processes communicate only via FIFO queues called 'channels'. For example, if you want to pass a folder location from Process A to Process B, you would output it from Process A into a channel, ```examplefolderlocation_ch```, and have Process B use that channel as an input.

*Note: if you write multiple values to a channel, subsequent processes will automatically run in parallel if they can*.


## scRNA-seq Workflow

### Running the Workflow

1. Copy the contents of the slurm-count folder to a folder on Rhino.
1. Change the nextflow.config file to use your email address
1. Change the values of the 'param' variables at the top of the ```slurm-count.nf``` file to use the proper folders for your workflow
1. Run the following command:

```
ml nextflow
screen 
nextflow slurm-count.nf --with-trace >>log.txt 2>&1
```

Then you can run Ctrl-A + D to exit screen, and the job will keep running in the background on Rhino. Read about [screen](https://linuxize.com/post/how-to-use-linux-screen/) if you want to know more. (You can also use tmux if you'd like)

### Components

**Workflow Inputs**

Also known as parameters (*'param'* in workflow parlance), these are the variables you pass in to specify how the workflow should behave

**JSON for variables**

There is a JSON file that contains run and sample information. See the [process10x.json](/slurm-count/process10x.json) file for an example.

**Python3 for parsing**

To parse the JSON and create run and sample channels, we use Python3. It has *very* good JSON handling and that's far easier to see/revise compared to 

**FAST for Storage**

Since this version of Nextflow is running on-premise in FH, it will store everything in FAST. As a result, the files and folders don't need to be passed around via the file() method and channels.

**Running on Gizmo**

Since this version of Nextflow is running on-premise in FH, it will run on Gizmo. Thankfully Nextflow runs on Slurm. 

To run this, you need to run Nextflow from a folder that has the [nextflow.config](/slurm-count/nextflow.config).


### Design

There are 6 process steps in 4 parts. (The parts are there to keep the workflow intuitive)

**Part A: Parse Inputs** - This has a single process, ```parseJsonInput```, that is a Python3 script that parses a JSON input file and outputs the runs and samples into channels.

**Part B: Create a denovo reference** - If needed, 

**Part C: Cellranker Mkfastq** - This has 2 process steps:

```rangerMkfastq``` - Runs cellranger mkfastq with the specified parameters. This will run each mkfastq call in parallel, one per run. 

```flattenSampleDirectories``` - flattens down sample directories

**Part D: Cellranger Count** - This is a single process, ```rangerCount```, that runs cellranger count with the specified parameters. This will run each cellranger count call in parallel, one per run.

*(TBD: Cellranger agg)*



# Resources

* https://github.com/nf-core/chipseq
* https://github.com/nf-core/rnaseq
* https://github.com/nf-core/scrnaseq
* [BICF Cellranger mkfastq Analysis Workflow](https://zenodo.org/record/2652621)
* [10x Genomics scRNA-Seq (cellranger) mkfastq Pipeline](https://git.biohpc.swmed.edu/BICF/Astrocyte/cellranger_mkfastq/blob/master/README.md)
* [Nextflow patterns](https://github.com/nextflow-io/patterns)
* [https://cellgeni.github.io/docs/pipelines.html](https://cellgeni.github.io/docs/index.html)
* [Awesome nextflow pipelines](https://github.com/nextflow-io/awesome-nextflow/)
* [FH Reproducible workflows](https://github.com/FredHutch/reproducible-workflows)

**Misc**

* [How do I iterate over a process n times?](https://www.nextflow.io/docs/latest/faq.html#how-do-i-iterate-over-a-process-n-times)
* [How do I invoke custom scripts and tools?](https://www.nextflow.io/docs/latest/faq.html#how-do-i-invoke-custom-scripts-and-tools)
* [How do I use the same channel multiple times?](https://www.nextflow.io/docs/latest/faq.html#how-do-i-use-the-same-channel-multiple-times)



## Sam Minot's Talk

* Entire talk - https://www.minot.bio/slides 
* https://github.com/FredHutch/reproducible-workflows
* https://github.com/nf-core
* https://sciwiki.fredhutch.org/compdemos/nextflow/
* https://biocontainers.pro/#/registry <- pre-built Docker containers

* Run one workflow from one working directory on your machine/Rhino. That way it makes concurrent workflows relatively easy to do 
* Use tmux or screen for whatever is running your workflow script (for example, on Rhino)

We now have a working module for Nextflow on rhino / gizmo! You can run ```ml nextflow/19.04.1``` to load a working version of Nextflow that is able to run jobs on AWS



### Slurm Notes

* https://github.com/FredHutch/slurm-examples/tree/master/R_and_sh_example
* https://sciwiki.fredhutch.org/compdemos/how_to_beagle/
* https://sciwiki.fredhutch.org/scicomputing/compute_platforms/#gizmo <- very important
* https://sciwiki.fredhutch.org/scicomputing/compute_environments/





























