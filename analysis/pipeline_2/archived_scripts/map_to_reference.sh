

# Parse file paths
ref_path=../data/irep_data/genome_references/${ref_name}
ref_index_dir=$(echo ${ref_path}|sed 's/.fasta//g')

fastq_1=$(ls ../data/irep_data/libraries/*.${fastq_name}.*.1.*)
fastq_2=$(ls ../data/irep_data/libraries/*.${fastq_name}.*.2.*)

result_dir=../results/irep_analysis
map_out=${result_dir}/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.sam/g')

table_path=${result_dir}/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.tsv/g')
pdf_path=${result_dir}/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.pdf/g')

# Indexing
#bowtie2-build ${ref_path} ${ref_index_dir}

# Mapping
bowtie2 -x ${ref_index_dir} -1 ${fastq_1} -2 ${fastq_2} -S ${map_out} --reorder -p 8

# iRep
bPTR -f ${ref_path} -s ${map_out} -o ${table_path} -plot ${pdf_path} -m coverage -ff
