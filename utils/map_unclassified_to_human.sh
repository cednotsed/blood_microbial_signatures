# Script to check human contamination after extracting unmapped reads from CRAM files

source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta

WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome
REFERENCE=/home/projects/14001280/PROJECTS/blood_microbiome/database/GRCh38_reference/GRCh38_latest_genomic.fna
input1=${WKDIR}/data/temp_files_100/06_unclassified_fastq/subset_100_unclassified.1.fastq
input2=${WKDIR}/data/temp_files_100/06_unclassified_fastq/subset_100_unclassified.2.fastq
output=${WKDIR}/results/map_to_human_out/subset_100_unclassified.sam

cat ${WKDIR}/data/temp_files_100/06_unclassified_fastq/*.1.fastq > ${input1}
cat ${WKDIR}/data/temp_files_100/06_unclassified_fastq/*.2.fastq > ${input2}

bwa mem \
	-t 22 \
	${REFERENCE} \
	${input1} ${input2}> ${output}

rm ${input1} ${input2}
