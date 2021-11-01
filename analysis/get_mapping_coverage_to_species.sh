#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=6:mem=12G
#PBS -l walltime=05:00:00
#PBS -P 14001280
# Map sample fastqs to species of choice and get coverage info

source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
REFERENCE=/home/projects/14001280/PROJECTS/blood_microbiome/database/moraxella_osloensis/GCF_001553955.1_ASM155395v1_genomic.fna
N_THREADS=6

RESDIR=${WKDIR}/results/decontamination/case_studies/moraxella_osloensis
query_dir=/scratch/users/astar/gis/tancsc/blood_microbiome_files/05_fastq

while read SAMPLE
do
	#SAMPLE=WHB1091
	input1=$(eval ls ${query_dir}/*${SAMPLE}.*.1.*.fastq)
	input2=$(eval ls ${query_dir}/*${SAMPLE}.*.2.*.fastq)
	output_prefix=${RESDIR}/${SAMPLE}.moraxella_osloensis

	bwa mem \
		-t ${N_THREADS} \
		${REFERENCE} \
		${input1} ${input2}> ${output_prefix}.sam
	
	samtools view -S -b ${output_prefix}.sam | samtools sort > ${output_prefix}.sorted.bam
	bedtools genomecov -ibam ${output_prefix}.sorted.bam -d > ${output_prefix}.coverage.tsv

done < ${WKDIR}/results/decontamination/case_studies/samples_with_moraxella_osloensis_gt_100.txt
