#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=48G
#PBS -l walltime=120:00:00
#PBS -P personal-tancsc
#PBS -N kraken_only_full_24n_48g
## Extract unmapped read and mates from CRAM files ##
# Input: CRAM file
# Output: fastq file containing read and mates

source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

WKDIR=/scratch/users/astar/gis/tancsc/blood_microbiome_files
N_THREADS=24
TMPDIR=/home/projects/14001280/PROJECTS/blood_microbiome/data/kraken2_classification_temp_output/temp_out.txt

#DB=/home/projects/14001280/PROJECTS/blood_microbiome/database/minikraken2_v2_8GB_201904_UPDATE
#DB=/home/projects/14001280/software/genomeDB/misc/softwareDB/kraken2/standard-20190108
DB=/home/projects/14001280/PROJECTS/blood_microbiome/database/k2_pluspf_20210517

for input1 in ${WKDIR}/05_fastq/*.1.fastq
do
	input2=$(echo ${input1}| sed "s|\.1\.fastq|.2.fastq|g")
	output1=$(echo ${input1}| sed "s|\.1\.fastq|.tsv|g"| sed "s|05_fastq|kraken_plusPF|g")
	output2=$(echo ${input1}| sed "s|\.1\.fastq|.unclassified.#.fastq|g"| sed "s|05_fastq|kraken_plusPF_unclassified|g")
	echo $input1
	echo $input2
	echo $output1
	echo $output2

	kraken2 \
        	--threads $N_THREADS \
        	--db ${DB} \
        	--paired \
        	--report ${output1} \
        	--output ${TMPDIR}/temp_output \
        	--unclassified-out ${output2} \
        	${input1} ${input2}
done

