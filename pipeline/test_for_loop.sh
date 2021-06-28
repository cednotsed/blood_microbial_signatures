WKDIR=/home/projects/14001280/PROJECTS/blood_microbiome/data/temp_files
SCRIPTS=/home/projects/14001280/PROJECTS/blood_microbiome/pipeline
N_THREADS=10

while read line
do
        COHORT=$(echo $line | awk '{split($0, a, ","); print a[1]}')
        MUX=$(echo $line | awk '{split($0, a, ","); print a[2]}')
        SAMPLE=$(echo $line | awk '{split($0, a, ","); print a[3]}')
	echo $SAMPLE
        sh ${SCRIPTS}/test_script.sh $COHORT $MUX $SAMPLE $WKDIR $N_THREADS

done < ../data/subset_list_10.csv
