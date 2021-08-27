# Script to check human contamination after extracting unmapped reads from CRAM files

source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta

COHORT=SERI
MUX=MUX3529
SAMPLE=WHH985
WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
REFERENCE=/home/projects/14001280/PROJECTS/blood_microbiome/database/ecoli_NC_000913.3_MG1655/ecoli_NC_000913.3_MG1655_16S.fasta
input1=${WKDIR}/data/temp_files_10.pipeline_2/01_files/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.fastq
input2=${WKDIR}/data/temp_files_10.pipeline_2/01_files/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.fastq
output=${WKDIR}/results/map_to_ecoli_out/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.sam

bwa mem \
	-t 22 \
	${REFERENCE} \
	${input1} ${input2}> ${output}
