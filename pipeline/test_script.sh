COHORT=$1
MUX=$2
SAMPLE=$3
WKDIR=$4
N_THREADS=$5

echo ${sample}
input=/data/13000026/shared/13000026_${COHORT}/rpd-sg10k-grch38-gatk4-gvcf-freebayes-vcf/${MUX}/${SAMPLE}/${SAMPLE}.bqsr.cram
echo ${input}
