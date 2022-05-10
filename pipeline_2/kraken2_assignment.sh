# Kraken2 taxonomic classification of reads
source ~/miniconda3/etc/profile.d/conda.sh
conda activate metagenomics

COHORT=$1
MUX=$2
SAMPLE=$3
WKDIR=$4
N_THREADS=$5
STEP=$6
TMPDIR=/home/projects/14001280/PROJECTS/blood_microbiome/data/kraken2_classification_temp_output/temp_out.txt

PREVIOUS_STEP=$(($STEP - 1))

#DB=/home/projects/14001280/PROJECTS/blood_microbiome/database/minikraken2_v2_8GB_201904_UPDATE
#DB=/home/projects/14001280/software/genomeDB/misc/softwareDB/kraken2/standard-20190108

DB=/home/projects/14001280/PROJECTS/blood_microbiome/database/k2_pluspf_20210517

input1=${WKDIR}/0${PREVIOUS_STEP}_fastq/${MUX}.${SAMPLE}.*.1.fastq
input2=${WKDIR}/0${PREVIOUS_STEP}_fastq/${MUX}.${SAMPLE}.*.2.fastq
input1=$(eval ls $input1)
input2=$(eval ls $input2)

output1=${WKDIR}/0${STEP}_reports/${MUX}.${SAMPLE}.tsv
output2=${WKDIR}/0${STEP}_unclassified_fastq/${MUX}.${SAMPLE}.unclassified.#.fastq

kraken2 \
	--threads $N_THREADS \
        --db ${DB} \
	--paired \
        --report ${output1} \
	--output ${TMPDIR}/temp_output \
	--unclassified-out ${output2} \
	${input1} ${input2} 

