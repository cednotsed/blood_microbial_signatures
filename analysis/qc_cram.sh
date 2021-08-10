#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=32G
#PBS -l walltime=10:00:00
#PBS -P 14001280

## Get mapping statistics from CRAM files ##
source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
RESDIR=${WKDIR}/results/full_run_n9706/CRAM_mapping_statistics
n_subset=9999
N_THREADS=24

mkdir ${RESDIR}
mkdir ${RESDIR}/log_files
while read line
do
        COHORT=$(echo $line | awk '{split($0, a, ","); print a[1]}')
        MUX=$(echo $line | awk '{split($0, a, ","); print a[2]}')
        SAMPLE=$(echo $line | awk '{split($0, a, ","); print a[3]}')

        echo $COHORT $MUX $SAMPLE

	input=/data/13000026/shared/13000026_${COHORT}/rpd-sg10k-grch38-gatk4-gvcf-freebayes-vcf/*/${SAMPLE}/${SAMPLE}.bqsr.cram
	output1=${RESDIR}/log_files/${MUX}.${SAMPLE}.${COHORT}.flagstat.txt
	output2=${RESDIR}/log_files/${MUX}.${SAMPLE}.${COHORT}.stats.txt

	samtools flagstat -@ ${N_THREADS} ${input} > ${output1}
	samtools stats -@ ${N_THREADS} ${input} > ${output2}

done < ${WKDIR}/data/subset_list_${n_subset}.csv

## Run MultiQC ##
multiqc ${RESDIR} -o ${RESDIR}
