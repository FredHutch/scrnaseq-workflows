# Slurm Notes

## Slurm Tutorial ('Hello World')

* [R and sh example](https://github.com/FredHutch/slurm-examples/tree/master/R_and_sh_example)
* [Computing Job Management](https://sciwiki.fredhutch.org/scicomputing/compute_jobs/)
* [Parallel Computing on Slurm clusters](https://sciwiki.fredhutch.org/scicomputing/compute_parallel/)


### Scripts

**Hello-world.sh**

* Waits for 5 seconds, prints date before and after

Running the script

```
```

Run the script interactively

```
srun helloworld.sh
```

Run the script and save the output

```
sbatch helloworld.sh helloworldout2
```

^ that doesn't seem to work correctly. 


### Learned



## Further 

* [Array jobs and R using a manifest](https://github.com/FredHutch/slurm-examples/tree/master/ManifestofJobs-R)
* [Convert multi-prog to an array](https://github.com/FredHutch/slurm-examples/tree/master/mp-array)