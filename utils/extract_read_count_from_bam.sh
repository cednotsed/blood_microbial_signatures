#npm data
wkdir=../results/irep_analysis/raw_output/noncontams

# Poore data
#wkdir=../results/poore_et_al/raw_output

bam_dir=$wkdir/bam_files
output=$wkdir/microbial_mapped_read_counts.csv

echo bam_file,pairs_mapped > $output

for bam_file in $bam_dir/*.bam
do
	echo $bam_file
	prefix_out=$(echo $bam_file| sed "s|$bam_dir/||g")
	read_count=$(samtools flagstat $bam_file|grep "properly paired"| awk -F " " '{print $1}')
	echo $prefix_out,$read_count >> $output
done
