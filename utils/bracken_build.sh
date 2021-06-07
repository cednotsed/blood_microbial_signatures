# ./bracken-build -d ${KRAKEN_DB} -t ${THREADS} -k ${KMER_LEN} -l ${READ_LEN} -x ${KRAKEN_INSTALLATION}
KRAKEN2_DB='/mnt/c/Users/Cedric/Desktop/year_3/BIOC0023/BIOC0023_dissertation/kraken2_db/16S_SILVA138_k2db'
THREADS=10
KMER_LEN=35
# READ_LEN set to mode read length of parsed fastqs
READ_LEN=407
KRAKEN2_INSTALLATION='/home/csctan/miniconda3/envs/metameta/libexec'

bracken-build \
	-d ${KRAKEN2_DB} \
	-t ${THREADS} \
	-k ${KMER_LEN} \
	-l ${READ_LEN} \

