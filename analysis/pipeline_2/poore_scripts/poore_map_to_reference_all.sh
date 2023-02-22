base_dir=/mnt/c/Users/Cedric/Desktop/git_repos/blood_microbiome
fastq_dir=$base_dir/data/poore_et_al/pipeline_2_output/05_fastq
ref_dir=$base_dir/data/poore_et_al/genome_references_poore
result_dir=$base_dir/results/poore_et_al/raw_output
sam_dir=$result_dir/sam_files

for ref_path in $ref_dir/Toxo*.fasta
do
    # Index the reference
    ref_index_dir=$(echo $ref_path|sed "s|\\.fasta||g")
    bowtie2-build ${ref_path} ${ref_index_dir}

	prefix=$(echo $ref_path|sed "s|$ref_dir||g"| sed "s|/||g"| sed "s|\\.fasta||g")
	count_output=$result_dir/${prefix}.counts.csv
	map_dir=$sam_dir/$prefix
	mkdir $map_dir

	echo id,reads_mapped > $count_output

	for fastq_1 in $fastq_dir/*.1.*
    do
        # Parse file paths
        fastq_2=$(echo $fastq_1|sed "s|\\.1\\.|\\.2\\.|g")

        id=$(echo $fastq_1|sed "s|$fastq_dir||g"|cut -d. -f2)

		# Mapping
		map_out=$map_dir/$id.sam
		echo $map_out
        bowtie2 -x ${ref_index_dir} -1 ${fastq_1} -2 ${fastq_2} -S ${map_out} --reorder -p 8

        read_count=$(samtools flagstat $map_out|grep "properly paired"| awk -F " " '{print $1}')
        echo $id,$read_count >> $count_output

     done
done
