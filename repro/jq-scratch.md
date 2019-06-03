# JQ scratch


* Copy the process10x.json file to rhino

```
cd /fh/fast/_HDC/cortex/dnambi/workflows/v2
cat process10x.json | jq '.runs'
cat process10x.json | jq '.samples'
cat process10x.json | jq '.["base-working-dir"]'

cat process10x.json | jq -r '.["base-working-dir"]'

WORKINGDIR=$(cat process10x.json | jq -r '.["base-working-dir"]')

cat process10x.json | jq -r '.samples[] .sample_label'

cat process10x.json | jq -r '.runs[] | .group_label,.raw_location'
```