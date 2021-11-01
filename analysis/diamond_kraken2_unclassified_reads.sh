#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=12:mem=48G
#PBS -l walltime=48:00:00
#PBS -P 14001280

## Get mapping statistics from CRAM files ##
source ~/miniconda3/etc/profile.d/conda.sh
conda activate blast_env

WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
#DB=${WKDIR}/database/diamond_nr_database_090821/nr_database_090821
DB=${WKDIR}/database/diamond_uniref50_database_MH/uniref50_201901
N_THREADS=24

query_dir=/scratch/users/astar/gis/tancsc/blood_microbiome_files/06_unclassified_fastq
RESDIR=${WKDIR}/results/diamond_kraken2_unclassified_reads
query_fastq1=${RESDIR}/concat.1.fastq
query_fastq2=${RESDIR}/concat.2.fastq
query=${RESDIR}/concat.n50000.fasta
output=${RESDIR}/subset_9999.n50000.dmnd_blastx.tsv

#RESDIR=${WKDIR}/results/unclassified_read_assembly/MUX10275.WHB7521.blastx_uniref50
#query=${WKDIR}/results/unclassified_read_assembly/MUX10275.WHB7521.raw_assemblies.fa
#output=${RESDIR}/MUX10275.WHB7521.blastx_uniref50.tsv

mkdir ${RESDIR}
cat ${query_dir}/*._1.*.fastq > ${query_fastq1}
cat ${query_dir}/*._2.*.fastq > ${query_fastq2}

seqtk sample -s100 ${query_fastq1} 50000 |seqtk seq -a > ${RESDIR}/query.1.fasta
seqtk sample -s100 ${query_fastq2} 50000 |seqtk seq -a > ${RESDIR}/query.2.fasta

cat ${RESDIR}/query.1.fasta ${RESDIR}/query.2.fasta > ${query}

rm ${RESDIR}/query.1.fasta ${RESDIR}/query.2.fasta ${query_fastq1} ${query_fastq2}
echo done concatenating

diamond blastx \
	-q ${query} \
	-d ${DB} \
	-o ${output} \
	-b 9 \
	-c 5 \
	--outfmt 6 \
	--ultra-sensitive



