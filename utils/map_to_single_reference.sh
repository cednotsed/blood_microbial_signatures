fastq_dir=../data/irep_data/libraries
id=0416-0024
ref_prefix=Staphylococcus_haemolyticus_plasmid_pSH108
ref_dir=../data/irep_data/genome_references_individual
ref_path=$(ls ${ref_dir}/$ref_prefix.fasta)
ref_index_dir=$(echo $ref_dir/$ref_prefix)
fastq1=$fastq_dir/*.$id.*.1.fastq
fastq2=$fastq_dir/*.$id.*.2.fastq
map_out=../results/irep_analysis/raw_output_individual/$id.$ref_prefix.sam
n_threads=9

bowtie2-build ${ref_path} ${ref_index_dir}
bowtie2 -x ${ref_index_dir} -1 ${fastq1} -2 ${fastq2} -S ${map_out} --reorder --threads ${n_threads}

