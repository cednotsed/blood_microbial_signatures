## Extract unmapped read and mates from CRAM files ##
# Input: CRAM file
# Output: fastq file containing read and mates
source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta

COHORT=$1
MUX=$2
SAMPLE=$3
WKDIR=$4
N_THREADS=$5

input=/data/13000026/shared/13000026_${COHORT}/rpd-sg10k-grch38-gatk4-gvcf-freebayes-vcf/*/${SAMPLE}/${SAMPLE}.bqsr.cram
#input=/data/13000026/shared/13000026_${COHORT}/rpd-sg10k-grch38-gatk4-gvcf-freebayes-vcf/${MUX}/${SAMPLE}/${SAMPLE}.bqsr.cram
output1=${WKDIR}/01_bam/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.bam
sorted_bam=${WKDIR}/01_bam/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.qsort.bam
output2=${WKDIR}/01_files/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.1.fastq
output3=${WKDIR}/01_files/${MUX}.${SAMPLE}.unmapped-both-read-and-mate.2.fastq
start=`date +%s`

# Extract unmapped reads from CRAM --> BAM
samtools view -@ $N_THREADS -u -f12 -F256 ${input} \
	> ${output1}

# Convert BAM to fastq
# Query sort BAM file
samtools sort -@ $N_THREADS -n -o ${sorted_bam} ${output1}

# Sorted BAM --> fastq
bedtools bamtofastq -i ${sorted_bam} -fq ${output2} -fq2 ${output3}

end=`date +%s`
runtime=$((end-start))

#echo $runtime > ${WKDIR}/runtime.extraction.log
