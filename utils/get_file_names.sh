prefix=subset_100
in_dir=/home/projects/14001280/PROJECTS/blood_microbiome/data/temp_files
out_dir=/home/projects/14001280/PROJECTS/blood_microbiome/results/temp_file_lists

ls ${in_dir}/01_bam | awk '{split($0,a,"."); print a[1],a[2]}' > ${out_dir}/01_bam_files.txt
ls ${in_dir}/06_reports | awk '{split($0,a,"."); print a[1],a[2]}' > ${out_dir}/06_report_files.txt

