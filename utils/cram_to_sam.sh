source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta

COHORT=TTSH
MUX=MUX5246
SAMPLE=WHH5065
N_THREADS=20

input=/data/13000026/shared/13000026_${COHORT}/rpd-sg10k-grch38-gatk4-gvcf-freebayes-vcf/${MUX}/${SAMPLE}/${SAMPLE}.bqsr.cram
output1=/home/projects/14001280/PROJECTS/blood_microbiome/results/map_to_human_out/${MUX}.${SAMPLE}.mapped.bam

# Extract mapped human reads from CRAM --> BAM
samtools view -@ $N_THREADS -s 0.00001 -u -f2 -F256 ${input} \
	|samtools sort > ${output1}

