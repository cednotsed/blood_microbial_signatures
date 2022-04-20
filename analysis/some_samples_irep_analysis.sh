n_threads=4
base_dir=/mnt/c/Users/Cedric/Desktop/git_repos/blood_microbiome
fastq_dir=${base_dir}/data/irep_data/libraries
ref_dir=${base_dir}/data/irep_data/genome_references
sample_dir=${base_dir}/data/irep_data/sample_lists
result_dir=../results/irep_analysis/raw_output


mkdir $result_dir

for sample_list in $sample_dir/*.txt
do
	ref_prefix=$(echo $sample_list|sed "s|${sample_dir}||g"| sed "s|/||g"| sed "s|.txt||g")
	ref_path=$(ls ${ref_dir}/$ref_prefix.fasta)
	ref_index_dir=$(echo $ref_dir/$ref_prefix)
	table_path=${result_dir}/irep_out/bPTR_$ref_prefix.tsv
	pdf_path=${result_dir}/irep_out/bPTR_$ref_prefix.pdf

	echo $sample_list
	echo $ref_prefix
	echo $ref_index_dir
	echo $pdf_path
	mkdir ${result_dir}/sam_files/$ref_prefix

    # Index reference
    bowtie2-build ${ref_path} ${ref_index_dir}

	while read fastq_name
	do
		# Retrieve fastq files
		fastq_1=$(ls ${fastq_dir}/*.${fastq_name}.*.1.*)
		fastq_2=$(ls ${fastq_dir}/*.${fastq_name}.*.2.*)

		# Parse file paths
		map_out=${result_dir}/sam_files/$ref_prefix/${fastq_name}_${ref_prefix}.sam

		echo $map_out
		echo $fastq_1

		# Mapping
		bowtie2 -x ${ref_index_dir} -1 ${fastq_1} -2 ${fastq_2} -S ${map_out} --reorder --threads ${n_threads}

	done < ${sample_list}

	# Run iRep on SAM files
	bPTR -f ${ref_path} -s ${result_dir}/sam_files/$ref_prefix/*.sam -o ${table_path} -plot ${pdf_path} -m coverage -ff -t $n_threads
done
