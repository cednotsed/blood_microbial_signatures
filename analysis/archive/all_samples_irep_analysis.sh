#!/bin/bash
#PBS -q normal
#PBS -l select=1:ncpus=16:mem=64G
#PBS -l walltime=20:00:00
#PBS -P 14001280
#PBS -N irep_n150_long

source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

n_threads=8
#base_dir=/home/projects/14001280/PROJECTS/blood_microbiome
#fastq_dir=/scratch/users/astar/gis/tancsc/blood_microbiome_files_2/05_fastq
#ref_dir=${base_dir}/data/irep_data/genome_references
#result_dir=/home/projects/14001280/PROJECTS/blood_microbiome/results/irep_analysis/raw_output

base_dir=/mnt/c/Users/Cedric/Desktop/git_repos/blood_microbiome
fastq_dir=${base_dir}/data/ta/05_fastq
ref_dir=${base_dir}/data/irep_data/genome_references
result_dir=../results/irep_analysis/raw_output


mkdir $result_dir

for ref_path in $ref_dir/*.fasta
do
	ref_name=$(echo $ref_path|sed "s|${ref_dir}||g"| sed "s|/||g")
	ref_index_dir=$(echo ${ref_path}|sed 's/.fasta//g')
	result_subdir=$(echo $ref_name|sed 's/.fasta//g')
        table_path=${result_dir}/irep_out2/$(echo bPTR_${ref_name} | sed 's/.fasta/.tsv/g')
        pdf_path=${result_dir}/irep_out2/$(echo bPTR_${ref_name} | sed 's/.fasta/.pdf/g')

	mkdir ${result_dir}/sam_files/$result_subdir

        # Index reference
        #bowtie2-build ${ref_path} ${ref_index_dir}

	while read fastq_name
	do
		# Retrieve fastq files
		fastq_1=$(ls ${fastq_dir}/*.${fastq_name}.*.1.*)
		fastq_2=$(ls ${fastq_dir}/*.${fastq_name}.*.2.*)

		# Parse file paths
		map_out=${result_dir}/sam_files/$result_subdir/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.sam/g')

		# Mapping
		bowtie2 -x ${ref_index_dir} -1 ${fastq_1} -2 ${fastq_2} -S ${map_out} --reorder --threads ${n_threads}

	done < $base_dir/data/irep_data/sample_lists/samples_for_coverage_analysis.n2.txt

	# Run iRep on SAM files
	bPTR -f ${ref_path} -s ${result_dir}/sam_files/$result_subdir/*.sam -o ${table_path} -plot ${pdf_path} -m coverage -ff -t $n_threads
done
