#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=8:mem=20G
#PBS -l walltime=03:00:00
#PBS -P 14001280
#PBS -N irep_test_run

n_threads=8
base_dir=/home/projects/14001280/PROJECTS/blood_microbiome
fastq_dir=/scratch/users/astar/gis/tancsc/blood_microbiome_files/05_fastq
ref_dir=${base_dir}/data/irep_data/genome_references
result_dir=/home/projects/14001280/PROJECTS/blood_microbiome/results/irep_analysis/raw_output

mkdir $result_dir

for ref_path in $ref_dir/*.fasta
do
        ref_name=$(echo $ref_path|sed "s|${ref_dir}||g"| sed "s|/||g")
        result_subdir=$(echo $ref_name|sed 's/.fasta//g')

        mkdir ${result_dir}/bam_files/$result_subdir


        while read fastq_name
        do
                echo $fastq_name

		# Retrieve fastq files
                fastq_1=$(ls ${fastq_dir}/*.${fastq_name}.*.1.*)
                fastq_2=$(ls ${fastq_dir}/*.${fastq_name}.*.2.*)

                # Parse file paths
                sam_out=${result_dir}/sam_files/$result_subdir/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.sam/g')
		bam_out=$(echo $sam_out | sed 's|\.sam|\.bam|g'| sed 's|sam_files|bam_files|g')
		echo $bam_out
                # Mapping
                samtools view -@ $n_threads -bS $sam_out|samtools sort - > $bam_out
		samtools index $bam_out
	
	done < $base_dir/data/irep_data/test.txt
done	
