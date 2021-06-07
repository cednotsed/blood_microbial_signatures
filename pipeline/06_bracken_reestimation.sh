BASE_DIR=/mnt/c/Users/Cedric/Desktop/year_3/BIOC0023/BIOC0023_dissertation
INPUT_DIR=${BASE_DIR}/data/04_kraken2_output
OUTPUT_DIR=${BASE_DIR}/data/05_bracken_output
KRAKEN2_DB=${BASE_DIR}/kraken2_db/16S_SILVA138_k2db
READ_LEN=250
LEVEL=G
THRESHOLD=10

for report in $INPUT_DIR/*.tsv
do
	output_file=$(echo $report|sed 's|.tsv||g')
	bracken \
		-d ${KRAKEN2_DB} \
		-i $report \
		-o ${output_file}.bracken \
		-r ${READ_LEN} \
		-l ${LEVEL} \
		-t ${THRESHOLD}
done


