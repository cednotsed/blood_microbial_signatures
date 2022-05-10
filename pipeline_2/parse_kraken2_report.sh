#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=12:mem=48G
#PBS -l walltime=10:00:00
#PBS -P personal-tancsc
#PBS -N parse_kraken2_reports_O

# Parse Kraken2 reports
source ~/miniconda3/etc/profile.d/conda.sh
conda activate metagenomics

SCRIPTS=/home/projects/14001280/PROJECTS/blood_microbiome/pipeline_2
#WKDIR=/scratch/users/astar/gis/tancsc/blood_microbiome_files_2
#WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome/results/simulation_out
WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome/data/poore_et_al/pipeline_2_output
STEP=7
PREVIOUS_STEP=6

#WKDIR=$2
#SCRIPTS=$3
#STEP=$4
#PREVIOUS_STEP=$(($STEP - 1))

input_dir=${WKDIR}/0${PREVIOUS_STEP}_reports
output_dir=${WKDIR}/0${STEP}_abundance_matrix
rank='S'
prefix=abundance_matrix
delim='.'

mkdir $output_dir

python ${SCRIPTS}/parse_kraken2_report.py \
	--i ${input_dir} \
	--o ${output_dir} \
	--rank $rank \
	--prefix $prefix \
	--delim $delim

