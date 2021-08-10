#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=96G
#PBS -l walltime=48:00:00
#PBS -P 14001280

## Get mapping statistics from CRAM files ##
source ~/miniconda3/etc/profile.d/conda.sh
conda activate blast_env

WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
RESDIR=${WKDIR}/results/blastx_kraken2_unclassified_reads
DB=${WKDIR}/database/blast_nr_database_020821/nr
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

blastx -db ${DB} \
	-query ${query} \
	-out ${output} \
	-outfmt 6 \
	-evalue 200000 \
	-num_alignments 1000000000 \
	-num_threads ${N_THREADS}



