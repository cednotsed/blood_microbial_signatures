# Script to check human contamination after extracting unmapped reads from CRAM files

source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta

COHORT=SSMP
MUX=SSMP_060_to_069
SAMPLE=SSM063
WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
REFERENCE=/home/projects/14001280/PROJECTS/blood_microbiome/database/GRCh38_reference/GRCh38_latest_genomic.fna
input1=${WKDIR}/data/temp_files_10/01_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.fastq
input2=${WKDIR}/data/temp_files_10/01_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.fastq
output=${WKDIR}/results/map_to_human_out/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.sam

bwa mem \
	-t 22 \
	${REFERENCE} \
	${input1} ${input2}> ${output}
