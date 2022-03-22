dir=/mnt/c/Users/Cedric/Desktop/git_repos/blood_microbiome/results/irep_analysis

for i in $dir/*.sam
do
	out_file=$(echo $i|sed 's/.sam/.bam/g'| sed 's|irep_analysis|irep_analysis/bam_files|g')
	samtools sort $i|samtools view -bS > $out_file
	samtools index $out_file
done
