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
query_fastq1=${RESDIR}/concat.1.fastq
query_fastq2=${RESDIR}/concat.2.fastq
query=${RESDIR}/concat.n10.fasta
output=${RESDIR}/subset_100.blastx.tsv

mkdir ${RESDIR}
cat ${query_dir}/*._1.*.fastq > ${query_fastq1}
cat ${query_dir}/*._2.*.fastq > ${query_fastq2}

seqtk sample -s100 ${query_fastq1} 10 |seqtk seq -a > ${RESDIR}/query.1.fasta
seqtk sample -s100 ${query_fastq2} 10 |seqtk seq -a > ${RESDIR}/query.2.fasta

cat ${RESDIR}/query.1.fasta ${RESDIR}/query.2.fasta > ${query}

rm ${RESDIR}/query.1.fasta ${RESDIR}/query.2.fasta ${query_fastq1} ${query_fastq2}
echo done concatenating

diamond blastx \
	-q ${query} \
	-d ${DB} \
	-o ${RESDIR}/subset_100_unclassified.tsv \
	-b 9 \
	-c 5 \
	--outfmt 6 \
	--ultra-sensitive



