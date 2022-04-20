sample_list_dir=../data/irep_data/sample_lists
output_dir=../data/irep_data/libraries

for file_list in $sample_list_dir/*.txt
do
	while read file
	do
		scp tancsc@aspire.nscc.sg:/scratch/users/astar/gis/tancsc/blood_microbiome_files_2/05_fastq/*.$file.* $output_dir
	done < $file_list

done
