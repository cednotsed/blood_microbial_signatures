base_dir='/mnt/c/Users/Cedric/Desktop/year_3/BIOC0023/BIOC0023_dissertation'

for dir in ${base_dir}/data/*fastq*
do
	echo $dir
	new_dir_path=$(echo $dir| sed "s|data|results/read_qc|g")
	mkdir ${new_dir_path}
	echo $new_dir_path
	fastqc \
		-t 10 \
		-o ${new_dir_path} \
		${dir}/*.fastq
done
