# Parse Kraken2 reports
source ~/miniconda3/etc/profile.d/conda.sh
conda activate base

n_subset=10
SCRIPTS=/home/projects/14001280/PROJECTS/blood_microbiome/pipeline
WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome/data/temp_files_${n_subset}/
N_THREADS=$5

input_dir=${WKDIR}/06_reports
output_dir=${WKDIR}/07_abundance_matrix
rank='S'
prefix=abundance_matrix.subset_${n_subset}
delim='.'


python ${SCRIPTS}/07_parse_kraken2_report.py \
	--i ${input_dir} \
	--o ${output_dir} \
	--rank $rank \
	--prefix $prefix \
	--delim $delim

