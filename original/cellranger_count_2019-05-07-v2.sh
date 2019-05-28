#!/bin/bash
#SBATCH --partition=largenode
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --time=24:00:00
#SBATCH --mem=256000
#SBATCH --tmp=256000
#SBATCH -o ./slurm_cellranger_count_2019-05-07
#SBATCH -J cellranger_count_2019-05-07

export PATH=/fh/fast/gottardo_r/vvoillet_working/software/cellranger-3.0.2:$PATH
export PATH=/fh/fast/gottardo_r/vvoillet_working/software/bcl2fastq_buildInstall/bin:$PATH

echo "Start of program `date`"

cd /fh/fast/gottardo_r/vvoillet_working/10xGenomics_KellyPaulson_CITE-seq_x663/cellranger/count

TRANSCRIPTOME=/fh/fast/gottardo_r/vvoillet_working/Reference_genomes/refdata-cellranger-GRCh38-3.0.0_WT1
FEATUREREF=5GEX_protein_feature_ref_2019-04-15.csv


#- X663_1919_PBMC
cellranger count --id=X663_1919_PBMC \
                 --transcriptome=$TRANSCRIPTOME \
		  --libraries=libraries_X663_1919_PBMC.csv \
                 --feature-ref=$FEATUREREF \
                 --expect-cells=8000

#- X663_11518_Marrow
cellranger count --id=X663_11518_Marrow \
                 --transcriptome=$TRANSCRIPTOME \
                 --libraries=libraries_X663_11518_Marrow.csv \
                 --feature-ref=$FEATUREREF \
                 --expect-cells=8000

#- X663_11518_PBMC
cellranger count --id=X663_11518_PBMC \
                 --transcriptome=$TRANSCRIPTOME \
                 --libraries=libraries_X663_11518_PBMC.csv \
                 --feature-ref=$FEATUREREF \
                 --expect-cells=8000

#- X663_13019_Marrow
cellranger count --id=X663_13019_Marrow \
                 --transcriptome=$TRANSCRIPTOME \
                 --libraries=libraries_X663_13019_Marrow.csv \
                 --feature-ref=$FEATUREREF \
                 --expect-cells=8000

#- X663_13019_PBMC
cellranger count --id=X663_13019_PBMC \
                 --transcriptome=$TRANSCRIPTOME \
                 --libraries=libraries_X663_13019_PBMC.csv \
                 --feature-ref=$FEATUREREF \
                 --expect-cells=8000

echo "End of program `date`"
