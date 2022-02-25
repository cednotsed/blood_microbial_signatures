#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=12:mem=48G
#PBS -l walltime=05:00:00
#PBS -P 14001280
# Script to check map unclassified reads to ecoli 16s

source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
REFERENCE=/home/projects/14001280/PROJECTS/blood_microbiome/database/staph_aureus_NC_007795.1/NC_007795.1.fasta
N_THREADS=12

RESDIR=${WKDIR}/results/mapping_out
input=${WKDIR}/results/unclassified_read_assembly/MUX10275.WHB7521.raw_assemblies.fa
output=${RESDIR}/MUX10275.WHB7521.unclassified_assembly.staph_aureus.sam

bwa mem \
	-t ${N_THREADS} \
	${REFERENCE} \
	${input} > ${output}
