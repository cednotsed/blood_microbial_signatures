sample_list_dir=../data/irep_data/sample_lists
output_dir=../data/irep_data/libraries

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
for file_list in $sample_list_dir/Achromobacter_xylosoxidans_NZ_CP043820.1.txt $sample_list_dir/Prevotella_oral_taxon_299_NC_022124.1.txt $sample_list_dir/Moraxella_osloensis_NZ_CP014234.1.txt $sample_list_dir/Gardnerella_vaginalis_NZ_PKJK01000001.1.txt
do
   echo $file_list

   while read file
   do
       scp tancsc@aspire.nscc.sg:/scratch/users/astar/gis/tancsc/blood_microbiome_files_2/05_fastq/*.$file.* $output_dir
   done < $file_list

done
