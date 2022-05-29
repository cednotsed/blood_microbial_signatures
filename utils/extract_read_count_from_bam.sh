#npm data
wkdir=../results/irep_analysis/raw_output

# Poore data
wkdir=../results/poore_et_al/raw_output

bam_dir=$wkdir/bam_files
output=$wkdir/mapping_read_counts.csv

echo prefix,npm_research_id,pairs_mapped > $output
for bam_subdir in $bam_dir/*
do
	for bam_file in $bam_subdir/*.bam
	do
		echo $prefix
		prefix=$(echo $bam_subdir | sed "s|$bam_dir||g"| sed "s|/||g")
		id=$(echo $bam_file| sed "s|$bam_subdir||g"| sed "s|_$prefix||g"| sed "s|.bam||g"| sed "s|/||g")
		read_count=$(samtools flagstat $bam_file|grep "properly paired"| awk -F " " '{print $1}')
		echo $prefix,$id,$read_count >> $output

	done
done
		#samtools flagstat WHB3658_Achromobacter_xylosoxidans_NZ_CP043820.1.bam|awk -F " " '{print $1}'
