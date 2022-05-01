wkdir=/home/projects/14001280/PROJECTS/blood_microbiome/data/poore_et_al
while read link
do 
	echo $link
	wget --continue -P $wkdir/raw_fastqs $link
done < $wkdir/poore_fastq_links.txt
