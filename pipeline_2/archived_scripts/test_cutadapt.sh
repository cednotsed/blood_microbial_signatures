# Trim 5' and 3' Ns
input1=../data/*.1.fastq
input2=../data/test.2.fastq
output1=../data/test.1.filtered.fastq
output2=../data/test.2.filtered.fastq
output3=../data/test.1.filtered.trimmed.fastq
output4=../data/test.2.filtered.trimmed.fastq

bbduk.sh \
	threads=12 \
	in1=$(eval ls $input1) \
	in2=${input2} \
	out1=${output1} \
	out2=${output2} \
	qtrim=rl \
	trimq=1 \
	minlen=2 \
	overwrite=t

#bbduk.sh \
#        threads=12 \
#        in1=${output1} \
#        in2=${output2} \
#        out1=${output3} \
#        out2=${output4} \
#        qtrim=rl \
#        minlen=75 \
#        overwrite=t
#bbduk.sh \
#       in1=${output1} \
#       in2=${output2} \
#       out1=${output3} \
#       out2=${output4} \
#       qtrim=rl \
#       trimq=10 \
#       overwrite=t
