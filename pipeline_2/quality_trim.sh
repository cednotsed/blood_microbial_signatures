# Quality trimming of reads
# Trim off 5' and 3' bases < 15
# Trim 5' and 3' Ns
source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta

COHORT=$1
MUX=$2
SAMPLE=$3
WKDIR=$4
N_THREADS=$5
STEP=$6

PREVIOUS_STEP=$(($STEP - 1))

input1=${WKDIR}/0${PREVIOUS_STEP}_fastq/${MUX}.${SAMPLE}.*.1.fastq
input2=${WKDIR}/0${PREVIOUS_STEP}_fastq/${MUX}.${SAMPLE}.*.2.fastq
input1=$(eval ls $input1)
input2=$(eval ls $input2)

output1=$(echo ${input1}| sed "s|\.1\.fastq|\.trimmed\.1\.fastq|g"| sed "s|0${PREVIOUS_STEP}_|0${STEP}_|g")
output2=$(echo ${input2}| sed "s|\.2\.fastq|\.trimmed\.2\.fastq|g"| sed "s|0${PREVIOUS_STEP}_|0${STEP}_|g")

bbduk.sh \
        threads=${N_THREADS} \
	in1=${input1} \
	in2=${input2} \
	out1=${output1} \
	out2=${output2} \
	qtrim=rl \
	trimq=10 \
	overwrite=t

