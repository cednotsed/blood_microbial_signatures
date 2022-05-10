#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=8:mem=16G
#PBS -l walltime=02:00:00
#PBS -P 14001280
#PBS -N map_cutibact

source ~/miniconda3/etc/profile.d/conda.sh
conda activate metagenomics


base_dir=/home/projects/14001280/PROJECTS/blood_microbiome
fastq_dir=$base_dir/data/pipeline_2_PlusPF/05_fastq
ref_dir=$base_dir/data/irep_data/genome_references_individual
result_dir=$base_dir/results/prevalence_estimates/cutibacterium_acnes
map_dir=$result_dir/sam_files
count_output=$result_dir/cutibacterium_acnes_mapping_counts_all.csv


for ref_path in $ref_dir/*.fasta
do
	# Index the reference
	ref_index_dir=$(echo ${ref_path}|sed 's/.fasta//g')
	bowtie2-build ${ref_path} ${ref_index_dir}	
	
	ref_name=$(echo $ref_path|sed 's|$ref_dir||g')
	echo $ref_name
	
	echo npm_research_id,pairs_mapped > $count_output

	for fastq_1 in $fastq_dir/*.1.*
	do	
		# Parse file paths
		fastq_2=$(echo $fastq_1|sed "s|\\.1\\.|\\.2\\.|g")
		
		#echo $fastq_1
		#echo $fastq_2
		
		id=$(echo $fastq_1|sed "s|$fastq_dir||g"|cut -d. -f2)
		#echo $id		

		# Mapping
		map_out=$map_dir/$id.sam
		bowtie2 -x ${ref_index_dir} -1 ${fastq_1} -2 ${fastq_2} -S ${map_out} --reorder -p 8

		# Extract read counts
                read_count=$(samtools flagstat $map_out|grep "properly paired"| awk -F " " '{print $1}')
                echo $id,$read_count >> $count_output
		
	
	done
done 
