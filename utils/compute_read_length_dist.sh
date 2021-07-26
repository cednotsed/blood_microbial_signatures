#!/bin/sh
# compute reads length distribution from a fastq file
input_dir='/home/projects/14001280/PROJECTS/blood_microbiome/data/temp_files/02_fastq/'
fastq=MUX5347.WHB1033.unmapped-both-read-and-mate.1.trimmed.fastq
cat ${input_dir}/${fastq} |awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' | sort -n
