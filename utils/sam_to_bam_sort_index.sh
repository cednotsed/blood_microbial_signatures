base_dir=/mnt/c/Users/Cedric/Desktop/git_repos/blood_microbiome
sam_dir=$base_dir/results/irep_analysis/raw_output/sam_files
bam_dir=$base_dir/results/irep_analysis/raw_output/bam_files

for sub_path in $sam_dir/*
do
	ref_prefix=$(echo $sub_path|sed "s|$sam_dir||g"| sed "s|/||g")
	echo $ref_prefix
	mkdir $bam_dir/$ref_prefix

	for sam in $sam_dir/$ref_prefix/*.sam
	do
		echo $sam
		out_file=$bam_dir/$ref_prefix/$(echo $sam| sed "s|$sam_dir/$ref_prefix||g"| sed "s|\\.sam|\\.bam|g"| sed "s|/||g")
		echo $out_file
		samtools sort $sam|samtools view -bS > $out_file
		samtools index $out_file
	done
done
