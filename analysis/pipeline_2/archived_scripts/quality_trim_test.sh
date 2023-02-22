# Quality trimming of reads
# Trim off 5' and 3' bases < 15
# Trim 5' and 3' Ns
source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta
MUX5301.WHH5001.unmapped-both-read-and-mate.no_Ns.2.fastq
MUX=MUX5301
SAMPLE=WHH5001
WKDIR=../data/temp_files_10.pipeline_2
N_THREADS=10
STEP=2

PREVIOUS_STEP=$(($STEP - 1))

input1=${WKDIR}/0${PREVIOUS_STEP}_files/${MUX}.${SAMPLE}.*.1.fastq
input2=${WKDIR}/0${PREVIOUS_STEP}_files/${MUX}.${SAMPLE}.*.2.fastq
input1=$(eval ls $input1)
input2=$(eval ls $input2)

output1=test.1.fastq
output2=test.2.fastq
cp ${input1} ./
cp ${input2} ./

bbduk.sh \
        threads=${N_THREADS} \
	in1=${input1} \
	in2=${input2} \
	out1=${output1} \
	out2=${output2} \
	maq=5 \
	minlength=2 \
	overwrite=t

