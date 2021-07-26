input=/home/projects/14001280/PROJECTS/blood_microbiome/results/map_to_human_out/MUX5246.WHH5065.unmapped-both-read-and-mate.sam
output=/home/projects/14001280/PROJECTS/blood_microbiome/results/map_to_human_out/MUX5246.WHH5065.remapped.bam

samtools view -b -f2 -F256 ${input} | samtools sort > ${output}
