source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta
COHORT='TTSH'
MUX='MUX5304'
SAMPLE='WHH5186'
WKDIR='/home/projects/14001280/PROJECTS/blood_microbiome/data/temp_files_test'
N_THREADS=10

# Create directories
mkdir ${WKDIR}
mkdir ${WKDIR}/01_bam ${WKDIR}/01_fastq/ ${WKDIR}/02_fastq/ ${WKDIR}/03_fastq/ ${WKDIR}/04_fastq/ ${WKDIR}/05_fastq/ ${WKDIR}/06_reports/ ${WKDIR}/06_unclassified_fastq/ ${WKDIR}/07_abundance_matrix/

#sh 01_extract_unmapped_reads_and_mates.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS

#sh 02_trim.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS

#sh 03_filter.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS

#sh 04_remove_low_complexity.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS

#sh 05_host_decontamination.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS

sh 06_kraken2_assignment.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS
