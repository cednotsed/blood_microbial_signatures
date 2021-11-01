#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=12:mem=48G
#PBS -l walltime=01:00:00
#PBS -P 14001280
# Script to check map unclassified reads to ecoli 16s

source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
REFERENCE=/home/projects/14001280/PROJECTS/blood_microbiome/database/ecoli_NC_000913.3_MG1655/ecoli_NC_000913.3_MG1655_16S.fasta
N_THREADS=12

RESDIR=${WKDIR}/results/mapping_out
query_dir=/scratch/users/astar/gis/tancsc/blood_microbiome_files/06_unclassified_fastq
query_fastq1=${RESDIR}/concat.1.fastq
query_fastq2=${RESDIR}/concat.2.fastq
input1=${RESDIR}/query.1.fasta
input2=${RESDIR}/query.2.fasta
output=${RESDIR}/subset_9999.unclassified.n50000.ecoli_16s.sam

mkdir ${RESDIR}
#cat ${query_dir}/*._1.*.fastq > ${query_fastq1}
#cat ${query_dir}/*._2.*.fastq > ${query_fastq2}

seqtk sample -s100 ${query_fastq1} 50000 |seqtk seq -a > ${input1}
seqtk sample -s100 ${query_fastq2} 50000 |seqtk seq -a > ${input2}
echo done concatenating

bwa mem \
	-t ${N_THREADS} \
	${REFERENCE} \
	${input1} ${input2}> ${output}
