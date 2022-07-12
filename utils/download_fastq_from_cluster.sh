sample_list_dir=../data/irep_data/sample_lists
output_dir=../data/irep_data/libraries
cluster_dir=/scratch/users/astar/gis/tancsc/blood_microbiome_files_2/05_fastq

#sample_list_dir=../results/poore_et_al
#output_dir=../data/poore_et_al/poore_libraries
#cluster_dir=/home/projects/14001280/PROJECTS/blood_microbiome/data/poore_et_al/pipeline_2_output/05_fastq


#for file_list in $sample_list_dir/Achromobacter_xylosoxidans_NZ_CP043820.1.txt $sampl
#do
#	echo $file_list
#
#	while read file
#	do
#		scp tancsc@aspire.nscc.sg:/scratch/users/astar/gis/tancsc/blood_microbiome_files_2/05_fastq/*.$file.* $output_dir
#	done < $file_list
#
#done
for file_list in $sample_list_dir/*.txt
do
   echo $file_list

   while read file
   do
       scp tancsc@aspire.nscc.sg:$cluster_dir/*.$file.* $output_dir
   done < $file_list

done
