#cutadapt -a FWDPRIMER...RCREVPRIMER -A REVPRIMER...RCFWDPRIMER
#-a CCTACGGGNGGCWGCAG...GGATTAGATACCCBDGTAGTC
#-A	GACTACHVGGGTATCTAATCC...CTGCWGCCNCCCGTAGG

# Directories
base_dir="/mnt/c/Users/Cedric/Desktop/year_3/BIOC0023/BIOC0023_dissertation"
out_dir="${base_dir}/data/fastq.01.parsed"
mkdir ${out_dir}
input_dir="${base_dir}/data/test_fastq"

# Params
n_threads=10

for file in ${input_dir}/*R1_*.fastq
do
    input_R1=$(echo $file | sed "s|${input_dir}/||g")
    input_R2=$(echo ${input_R1} | sed "s|R1_001.fastq|R2_001.fastq|g")
    output_R1=$(echo ${input_R1} | sed "s|R1_001.fastq|R1_001.trimmed.fastq|g")
    output_R2=$(echo ${input_R2} | sed "s|R2_001.fastq|R2_001.trimmed.fastq|g")
    id=$(echo ${output_R2} | sed "s|_R2_001.trimmed.fastq||g")

    # A) Trim primers, remove sequences not flanked by primersi
	# Trim leading and trailing bases below Q15
	# Remove flanking Ns
	# External F, external R, internal F, internal R, sequencing adapter F, sequencing adapter R
	# Go through 3 rounds of trimming
	# Output R1, Output R2
	# Input R1 and R2
    cutadapt \
		--cores $n_threads \
        -q 15,15 \
        --trim-n \
        -a ACGGCCNNRACTCCTAC \
        -A TTACGGNNTGGACTACHV \
		-a CCTACGGGNGGCWGCAG \
		-A GACTACHVGGGTATCTAATCC \
		-a TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG \
		-A GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG \
		--times 3 \
        -o $out_dir/$output_R1 \
        -p $out_dir/$output_R2 \
        $input_dir/$input_R1 $input_dir/$input_R2

	echo "cutadapt done!!!"

	# B) Merge reads at at 85% identity <F3><F2>
    fastq-join $out_dir/$output_R1 $out_dir/$output_R2 -o $out_dir/${id}.%.fastq -p 15

    # Concat joined reads and forward unjoined reads
    cat ${out_dir}/${id}.join.fastq ${out_dir}/${id}.un1.fastq > ${out_dir}/${id}.trimmed.joined.concat.fastq
#    rm ${out_dir}/${id}.un2.fastq ${out_dir}/${id}.un1.fastq ${out_dir}/${id}.join.fastq ${out_dir}/*.trimmed.fastq

	echo "Read joining done!!!"

    # Q20 read filtering
    bbduk.sh in=${out_dir}/${id}.trimmed.joined.concat.fastq \
        out=${out_dir}/${id}.trimmed.joined.concat.filtered.fastq \
        maq=20 \
		overwrite=t

#    rm ${out_dir}/${id}.trimmed.joined.concat.fastq
	echo "Quality filtering done!!!"

#    # Remove if less than 10k reads
#    counts=$(echo $(cat ${out_dir}/${id}.trimmed.joined.concat.filtered.fastq| wc -l) / 4| bc)
#	echo $counts
#
#    if [$counts -lt 10000]
#        then
#            echo ${out_dir}/${id}.trimmed.joined.concat.filtered.fastq
#            rm ${out_dir}/${id}.trimmed.joined.concat.filtered.fastq
#    fi
#	echo "Filtering low read count files done!!!"

	# Get read lengths
	cat ${out_dir}/${id}.trimmed.joined.concat.filtered.fastq|wc -l
done
