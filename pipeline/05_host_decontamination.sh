source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta

COHORT=$1
MUX=$2
SAMPLE=$3
WKDIR=$4

input1=${WKDIR}/04_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.trimmed.filtered.low_complexity.fastq
input2=${WKDIR}/04_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.trimmed.filtered.low_complexity.fastq
output1=${WKDIR}/05_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.trimmed.filtered.low_complexity.decontaminated.fastq
output2=${WKDIR}/05_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.trimmed.filtered.low_complexity.decontaminated.fastq

cp ${input1} ${output1}
cp ${input2} ${output2}
