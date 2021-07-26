# Index human reference

#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=2:mem=8G
#PBS -l walltime=10:00:00
#PBS -P 14001280
source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta

REFERENCE=/home/projects/14001280/PROJECTS/blood_microbiome/database/GRCh38_reference/GRCh38_latest_genomic.fna

bwa index ${REFERENCE}
