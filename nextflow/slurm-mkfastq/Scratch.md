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


cat runsample.json | jq -r '.group_label'

```


```
RUN='runsample.json'
GROUP_LABEL="$(cat $RUN | jq -r '.group_label')"
RAW_LOCATION="$(cat $RUN | jq -r '.raw_location')"
CSV_LOCATION="$(cat $RUN | jq -r '.csv_location')"
FASTQ_OUTPUT_DIR="$(cat $RUN | jq -r '.fastq_output_dir')"

echo "Group label is $GROUP_LABEL"
echo "Raw location is $RAW_LOCATION"
echo "Csv is $CSV_LOCATION"
echo "Fastq output goes to $FASTQ_OUTPUT_DIR"

```