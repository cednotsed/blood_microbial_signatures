# Directories
base_dir="/mnt/c/Users/Cedric/Desktop/year_3/BIOC0023/BIOC0023_dissertation"
out_dir="${base_dir}/data/fastq.02.parsed"
input_dir="${base_dir}/data/fastq.01.parsed"

# Params
n_threads=10

for file in ${input_dir}/*.fastq
do
	output=$(echo $file | sed "s|filtered.fastq|filtered.komplexity.fastq|g")
	output=$(echo $output | sed "s|fastq.01|fastq.02|g")


done
