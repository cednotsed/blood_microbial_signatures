#cutadapt -a FWDPRIMER...RCREVPRIMER -A REVPRIMER...RCFWDPRIMER
#-a CCTACGGGNGGCWGCAG...GGATTAGATACCCBDGTAGTC
#-A	GACTACHVGGGTATCTAATCC...CTGCWGCCNCCCGTAGG

# Directories
base_dir="/mnt/c/Users/Cedric/Desktop/year_3/BIOC0023/BIOC0023_dissertation"
out_dir="${base_dir}/data/fastq.01.parsed"
input_dir="${base_dir}/data/fastq"

# Params
n_threads=10

for file in ${input_dir}/*R1_*.fastq
do
    input_R1=$(echo $file | sed "s|${input_dir}/||g")
    input_R2=$(echo ${input_R1} | sed "s|R1_001.fastq|R2_001.fastq|g")
    output_R1=$(echo ${input_R1} | sed "s|R1_001.fastq|R1_001.trimmed.fastq|g")
    output_R2=$(echo ${input_R2} | sed "s|R2_001.fastq|R2_001.trimmed.fastq|g")
    id=$(echo ${output_R2} | sed "s|_R2_001.trimmed.fastq||g")
#    # A) Trim primers
#	# In order of parameters: number of threads, trim leading and trailing bases below Q15, minimum sequence overlap to trim adapter
#	# trim flanking Ns
#	# F...R_RC
#	# R...F_RC
#	# discard reads without primer
#    cutadapt \
#		--cores $n_threads \
#        -q 15,15 \
#		--overlap 5\
#        --trim-n \
#        -a ^CCTACGGGNGGCWGCAG...GGATTAGATACCCBDGTAGTC \
#        -A ^GACTACHVGGGTATCTAATCC...CTGCWGCCNCCCGTAGG \
#        --discard-untrimmed \
#        -o $out_dir/$output_R1 \
#        -p $out_dir/$output_R2 \
#        $input_dir/$input_R1 $input_dir/$input_R2
#
#    # B) Merge reads at at 85% identity
#    fastq-join $out_dir/$output_R1 $out_dir/$output_R2 -o $out_dir/${id}.%.fastq -p 15
#
#    # Concat joined reads and forward unjoined reads
#    cat ${out_dir}/${id}.join.fastq ${out_dir}/${id}.un1.fastq > ${out_dir}/${id}.trimmed.joined.concat.fastq
#    rm ${out_dir}/${id}.un2.fastq ${out_dir}/${id}.un1.fastq ${out_dir}/${id}.join.fastq ${out_dir}/*.trimmed.fastq
#
#    # Q20 read filtering
#    bbduk.sh in=${out_dir}/${id}.trimmed.joined.concat.fastq \
#        out=${out_dir}/${id}.trimmed.joined.concat.filtered.fastq \
#        maq=20 \
#		overwrite=t
#
#    rm ${out_dir}/${id}.trimmed.joined.concat.fastq

    # Remove if less than 10k reads
    counts=$(echo $(cat ${out_dir}/${id}.trimmed.joined.concat.filtered.fastq| wc -l) / 4| bc)

    if [ $counts -lt 10000 ]
        then
            echo $id
            #rm ${out_dir}/${id}.trimmed.joined.concat.filtered.fastq
    fi

done
