input1=/home/projects/14001280/PROJECTS/blood_microbiome/results/map_to_human_out/MUX5246.WHH5065.mapped.bam
output1=/home/projects/14001280/PROJECTS/blood_microbiome/results/map_to_human_out/qualimap_human_mapped

input2=/home/projects/14001280/PROJECTS/blood_microbiome/results/map_to_human_out/MUX5246.WHH5065.remapped.bam
output2=/home/projects/14001280/PROJECTS/blood_microbiome/results/map_to_human_out/qualimap_human_remapped

qualimap bamqc -bam ${input1} -outdir ${output1}
qualimap bamqc -bam ${input2} -outdir ${output2}
