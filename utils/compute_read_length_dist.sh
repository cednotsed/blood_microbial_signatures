#!/bin/sh
# compute reads length distribution from a fastq file
input_dir='/mnt/c/Users/Cedric/Desktop/year_3/BIOC0023/BIOC0023_dissertation/data/fastq.01.parsed'

cat ${input_dir}/*.fastq |awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}'
