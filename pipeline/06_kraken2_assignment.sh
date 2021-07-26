# Kraken2 taxonomic classification of reads
source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

COHORT=$1
MUX=$2
SAMPLE=$3
WKDIR=$4
N_THREADS=$5
TMPDIR=/home/projects/14001280/PROJECTS/blood_microbiome/data/kraken2_classification_temp_output/temp_out.txt

#DB=/home/projects/14001280/PROJECTS/blood_microbiome/database/minikraken2_v2_8GB_201904_UPDATE
DB=/home/projects/14001280/software/genomeDB/misc/softwareDB/kraken2/standard-20190108

input1=${WKDIR}/05_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.trimmed.filtered.low_complexity.decontaminated.fastq
input2=${WKDIR}/05_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.trimmed.filtered.low_complexity.decontaminated.fastq
output1=${WKDIR}/06_reports/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.trimmed.filtered.low_complexity.decontaminated.tsv
output2=${WKDIR}/06_unclassified_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.#.trimmed.filtered.low_complexity.decontaminated.unclassified.fastq

start=`date +%s`

kraken2 \
	--threads $N_THREADS \
        --db ${DB} \
	--paired \
        --report ${output1} \
	--output ${TMPDIR}/temp_output \
	--unclassified-out ${output2} \
	${input1} ${input2} 

end=`date +%s`
runtime=$((end-start))

echo $runtime
