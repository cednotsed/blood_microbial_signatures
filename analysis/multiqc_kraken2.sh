#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=8:mem=32G
#PBS -l walltime=30:00:00
#PBS -P 14001280

source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

n_subset=9999
#WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome/data/temp_files_${n_subset}/06_reports
#RESDIR=/home/projects/14001280/PROJECTS/blood_microbiome/results/multiqc_kraken2

WKDIR=/scratch/users/astar/gis/tancsc/blood_microbiome_files
RESDIR=/home/projects/14001280/PROJECTS/blood_microbiome/results/full_run_n9706/multiqc_kraken2_reports

mkdir ${RESDIR}

multiqc ${WKDIR} -o ${RESDIR}
