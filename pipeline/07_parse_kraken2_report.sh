#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=12:mem=48G
#PBS -l walltime=10:00:00
#PBS -P personal-tancsc
#PBS -N parse_kraken2_reports_P

# Parse Kraken2 reports
source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

n_subset=9999
SCRIPTS=/home/projects/14001280/PROJECTS/blood_microbiome/pipeline
#WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome/data/temp_files_${n_subset}
WKDIR=/scratch/users/astar/gis/tancsc/blood_microbiome_files

input_dir=${WKDIR}/kraken_raw
output_dir=${WKDIR}/07_abundance_matrix
rank='P'
#prefix=abundance_matrix.subset_${n_subset}
prefix=abundance_matrix.raw_fastqs.subset_${n_subset}
delim='.'


python ${SCRIPTS}/07_parse_kraken2_report.py \
	--i ${input_dir} \
	--o ${output_dir} \
	--rank $rank \
	--prefix $prefix \
	--delim $delim

