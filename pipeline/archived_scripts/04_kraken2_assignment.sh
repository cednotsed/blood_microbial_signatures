base_dir="/mnt/c/Users/Cedric/Desktop/year_3/BIOC0023/BIOC0023_dissertation"
mkdir ${base_dir}/data/04_kraken2_output
for file in ${base_dir}/data/fastq.01.parsed/*.fastq
do
	#echo $file
    new_filep=$(echo $file| sed "s|.trimmed.joined.concat.filtered.fastq|.tsv|g" | sed "s|fastq.01.parsed|04_kraken2_output|g")
	echo ${new_filep}
    kraken2 \
        --db ${base_dir}/kraken2_db/16S_SILVA138_k2db \
        --report ${new_filep} \
        ${file}
done
