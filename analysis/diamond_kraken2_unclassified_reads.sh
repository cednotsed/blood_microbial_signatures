#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=96G
#PBS -l walltime=48:00:00
#PBS -P 14001280

## Get mapping statistics from CRAM files ##
source ~/miniconda3/etc/profile.d/conda.sh
conda activate blast_env

WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
RESDIR=${WKDIR}/results/diamond_kraken2_unclassified_reads
DB=${WKDIR}/database/diamond_nr_database_090821/nr_database_090821
N_THREADS=24

query_dir=${WKDIR}/data/temp_files_100/06_unclassified_fastq
query_fastq=${RESDIR}/concat.fastq
query=${RESDIR}/concat.fasta
output=${RESDIR}/subset_100.blastx.tsv

mkdir ${RESDIR}
cat ${query_dir}/*.fastq > ${query_fastq}
seqtk seq -a ${query_fastq} > ${query}
rm ${query_fastq}
echo done concatenating

diamond blastx \
	-q ${query} \
	-d ${DB} \
	-o ${RESDIR}/subset_100_unclassified.tsv \
	-b 20 \
	-c 5 \
	--outfmt 6 \
	--ultra-sensitive



