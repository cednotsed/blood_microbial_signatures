base_dir=/home/projects/14001280/PROJECTS/blood_microbiome/data/irep_data
data_dir=/scratch/users/astar/gis/tancsc/blood_microbiome_files/
fastq_dir=$data_dir/05_fastq
ref_dir=$base_dir/genome_references
sam_dir=$data_dir/mapping_results
irep_dir=$data_dir/irep_results
cov_dir=$data_dir/coverage_results


for ref_path in $ref_dir/*.fasta
do
	echo $ref_path
done
