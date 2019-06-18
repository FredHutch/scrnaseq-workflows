RUN='runsample.json'
GROUP_LABEL="$(cat $RUN | jq -r '.group_label')"
RAW_LOCATION="$(cat $RUN | jq -r '.raw_location')"
CSV_LOCATION="$(cat $RUN | jq -r '.csv_location')"
FASTQ_OUTPUT_DIR="$(cat $RUN | jq -r '.fastq_output_dir')"

echo "Group label is $GROUP_LABEL"
echo "Raw location is $RAW_LOCATION"
echo "Csv is $CSV_LOCATION"
echo "Fastq output goes to $FASTQ_OUTPUT_DIR"
