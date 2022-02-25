#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=32G
#PBS -l walltime=05:00:00
#PBS -P 14001280

source ~/miniconda3/etc/profile.d/conda.sh
conda activate blast_env

WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
RESDIR=${WKDIR}/results/blastx_kraken2_unclassified_reads
DB=${WKDIR}/database/blast_landmark_database_250821/landmark
N_THREADS=24

query_dir=${WKDIR}/data/temp_files_100/06_unclassified_fastq
query_fastq1=${RESDIR}/concat.1.fastq
query_fastq2=${RESDIR}/concat.2.fastq
query=${RESDIR}/concat.n1000.fasta
output=${RESDIR}/subset_1000.blastx.landmark.tsv

# Convert fastq to fasta + subset
#mkdir ${RESDIR}
#cat ${query_dir}/*._1.*.fastq > ${query_fastq1}
#cat ${query_dir}/*._2.*.fastq > ${query_fastq2}

#seqtk sample -s100 ${query_fastq1} 1000 |seqtk seq -a > ${RESDIR}/query.1.fasta
#seqtk sample -s100 ${query_fastq2} 1000 |seqtk seq -a > ${RESDIR}/query.2.fasta

#cat ${RESDIR}/query.1.fasta ${RESDIR}/query.2.fasta > ${query}

#rm ${RESDIR}/query.1.fasta ${RESDIR}/query.2.fasta ${query_fastq1} ${query_fastq2}
#echo done concatenating

# BLASTx
blastx -db ${DB} \
        -query ${query} \
        -out ${output} \
        -outfmt 6 \
        -evalue 200000 \
        -num_alignments 1000000000 \
        -num_threads ${N_THREADS}
