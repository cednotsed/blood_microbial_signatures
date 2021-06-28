source ~/miniconda3/etc/profile.d/conda.sh
conda activate metameta
COHORT='HELIOS'
MUX='MUX9846'
SAMPLE='WHB10117'
WKDIR='/home/projects/14001280/PROJECTS/blood_microbiome/data/temp_files'
N_THREADS=10

tput setaf 2; echo Extracting...
tput sgr0
sh 01_extract_unmapped_reads_and_mates.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS
tput setaf 2; echo Extracting done.
tput sgr0

tput setaf 2; echo Trimming...
tput sgr0
sh 02_trim.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS
tput setaf 2; echo Trimming done.
tput sgr0

tput setaf 2; echo Filtering...
tput sgr0
sh 03_filter.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS
tput setaf 2; echo Filtering done.
tput sgr0

tput setaf 2; echo Removing low complexity reads...
tput sgr0
sh 04_remove_low_complexity.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS
tput setaf 2; echo Low complexity removal done.
tput sgr0

tput setaf 2; echo Host decontamination...
tput sgr0
sh 05_host_decontamination.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS
tput setaf 2; echo Decontamination done.
tput sgr0

tput setaf 2; echo Kraken2 classification...
tput sgr0
sh 06_kraken2_assignment.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS
tput setaf 2; echo Classification done.
tput sgr0
