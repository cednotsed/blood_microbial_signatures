#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=12:mem=48G
#PBS -l walltime=12:00:00
#PBS -P 14001280 
#PBS -N sam_mapping2

source ~/miniconda3/etc/profile.d/conda.sh
conda activate metagenomics

wkdir=/home/projects/14001280/PROJECTS/blood_microbiome/
bam_dir=/data/13000026/shared/13000026_*/rpd-sg10k-grch38-gatk4-gvcf-freebayes-vcf/*/*/
output=$wkdir/results/irep_analysis/raw_output/map_to_human_read_counts2.csv
sample_list=$wkdir/data/irep_data/sample_lists/all_samples.txt

echo npm_research_id,pairs_mapped > $output

while read id 
do
	bam_file=$(ls $bam_dir/$id.bqsr.cram)
	echo $bam_file
	#id=$(echo $bam_file| sed "s|${bam_subdir}||g"| sed "s|\\_$prefix||g"| sed "s|\\.bam||g"| sed "s|/||g")
	echo $id
	start=$(date +%s)
	read_count=$(samtools flagstat -@ 12 $bam_file|grep "properly paired"| awk -F " " '{print $1}')
	echo $id,$read_count >> $output
	end=$(date +%s)
	echo $((end-start))
done < $sample_list

