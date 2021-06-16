# Quality filtering of reads below Qxx
source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta

COHORT=$1
MUX=$2
SAMPLE=$3
WKDIR=$4

input1=${WKDIR}/02_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.trimmed.fastq
input2=${WKDIR}/02_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.trimmed.fastq
output1=${WKDIR}/03_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.trimmed.filtered.fastq
output2=${WKDIR}/03_fastq/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.trimmed.filtered.fastq

# Filter reads with less than average of Q20
start=`date +%s`

bbduk.sh \
	in1=${input1} \
	in2=${input2} \
	out1=${output1} \
	out2=${output2} \
        maq=20 \
	overwrite=t

end=`date +%s`
runtime=$((end-start))

#echo $runtime > ${WKDIR}/runtime.filtering.log
