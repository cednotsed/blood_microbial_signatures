# Remove low complexity sequences
source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta

COHORT=$1
MUX=$2
SAMPLE=$3
WKDIR=$4

input1=${WKDIR}/03_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.trimmed.filtered.fastq
input2=${WKDIR}/03_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.trimmed.filtered.fastq
output1=${WKDIR}/04_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.trimmed.filtered.low_complexity.fastq
output2=${WKDIR}/04_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.trimmed.filtered.low_complexity.fastq

start=`date +%s`
bbduk.sh in1=${input1} in2=${input2} out1=${output1} out2=${output2} \
	entropy=0.5 \
	entropywindow=50 \
	entropyk=5 \
	overwrite=t

#kz --filter --threshold 0.55 < ${input} > ${output}
