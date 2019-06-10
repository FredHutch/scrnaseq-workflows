# JSON-1 scratch



**Docs**

* [JQ Tutorial](https://stedolan.github.io/jq/tutorial/)
* [Channels](https://www.nextflow.io/docs/latest/channel.html)
* [Process](https://www.nextflow.io/docs/latest/process.html)
* [RNA-seq example](https://www.nextflow.io/example4.html)
* [Basic pipeline](https://www.nextflow.io/example1.html)
* [Mixed languages](https://www.nextflow.io/example2.html)

```
cd /Users/dnambi/Documents/GitHub/scrnaseq-workflows/nextflow/json-1
cat process10x.json | jq '.runs'
cat process10x.json | jq '.samples'
cat process10x.json | jq '.["base-working-dir"]'

cat process10x.json | jq -r '.["base-working-dir"]'

WORKINGDIR=$(cat process10x.json | jq -r '.["base-working-dir"]')

cat process10x.json | jq -r '.samples[] .sample_label'

cat process10x.json | jq -r '.runs[] | .group_label,.raw_location'

cat process10x.json | jq -r '.runs[] | [.group_label,.raw_location,.csv_location,.fastq_output_dir] | @tsv'


cat process10x.json | jq -r '.runs[] | [.group_label,.raw_location,.csv_location,.fastq_output_dir] | @tsv' | awk '{ print $3 }'
```