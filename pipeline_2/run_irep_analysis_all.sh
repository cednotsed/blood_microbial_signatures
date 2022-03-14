base_dir=/home/projects/14001280/PROJECTS/blood_microbiome/data/irep_data
data_dir=/scratch/users/astar/gis/tancsc/blood_microbiome_files
fastq_dir=$data_dir/05_fastq
ref_dir=$base_dir/genome_references
sam_dir=$data_dir/mapping_results
irep_dir=$data_dir/irep_results
cov_dir=$data_dir/coverage_results


for ref_path in $ref_dir/*.fasta
do
	# Index the reference
	ref_index_dir=$(echo ${ref_path}|sed 's/.fasta//g')
	#bowtie2-build ${ref_path} ${ref_index_dir}	
	ref_name=$(echo $ref_path|sed 's|$ref_dir||g')
	echo $ref_name

	while read fastq_name
	do	
		# Parse file paths
		fastq_1=$(ls $fastq_dir/*.${fastq_name}.*.1.*)
		fastq_2=$(ls $fastq_dir/*.${fastq_name}.*.2.*)
		
		echo $fastq_1

		map_out=$sam_dir/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.sam/g')
		table_path=$irep_dir/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.tsv/g')
		pdf_path=$irep_dir/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.pdf/g')
		
		# Indexing
		#bowtie2-build ${ref_path} ${ref_index_dir}
		
		# Mapping
		#bowtie2 -x ${ref_index_dir} -1 ${fastq_1} -2 ${fastq_2} -S ${map_out} --reorder -p 8
		
		# iRep
		#bPTR -f ${ref_path} -s ${map_out} -o ${table_path} -plot ${pdf_path} -m coverage -ff
	
	done < $base_dir/ids_n125.global_decontaminated.zeroed.txt
done 
