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

input=${WKDIR}/01_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.*.fastq
output1=${WKDIR}/02_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.trimmed.fastq
output2=${WKDIR}/02_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.trimmed.fastq

input1=${WKDIR}/01_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.fastq
input2=${WKDIR}/01_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.fastq
# Params
n_threads=10

start=`date +%s`

# Trim off 5' and 3' bases < 15
# Trim 5' and 3' Ns
#cutadapt \
#	--cores $N_THREADS \
#        -q 10,10 \
#	--minimum-length 75 \
#        --trim-n \
#        -o ${output1} \
#	-p ${output2} \
#        ${input}
#
#end=`date +%s`
#runtime=$((end-start))

#echo $runtime > ${WKDIR}/runtime.trimming.log

cp ${input1} ${output1}
cp ${input2} ${output2}

