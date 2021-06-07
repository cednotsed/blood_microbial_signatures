for i in *.fastq; do echo $i$'\t'$(echo $(cat $i|wc -l)/4|bc); done > ../read.counts.parsed.txt
