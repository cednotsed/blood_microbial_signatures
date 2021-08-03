#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=48G
#PBS -l walltime=50:00:00
#PBS -P 14001280

source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

n_subset=100
WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome/data/temp_files_${n_subset}/06_reports
RESULTS=/home/projects/14001280/PROJECTS/blood_microbiome/results/multiqc_kraken2

multiqc ${WKDIR} -o ${RESULTS}
