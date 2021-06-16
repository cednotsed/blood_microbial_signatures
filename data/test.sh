cohort='HELIOS'
mux='MUX9693'
sample='WHB10000'
wkdir='/home/users/astar/gis/tancsc/workspace/blood_microbiome/data'

samtools view -u -s 0.002 -@ 20 -b -f12 -F256 /data/13000026/shared/13000026_${cohort}/rpd-sg10k-grch38-gatk4-gvcf-freebayes-vcf/${mux}/${sample}/${sample}.bqsr.cram |
	samtools bam2fq - > ./unmapped-both-read-and-mate.fq.gz
