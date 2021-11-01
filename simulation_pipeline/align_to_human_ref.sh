prefix=10e-5
data=/home/projects/14001280/PROJECTS/blood_microbiome/data/simulation_references
bowtie2 -x ${data}/human/ref -1 ${data}/simulated_reads/simulated.${prefix}.1.fastq \
    -2 ${data}/simulated_reads/simulated.${prefix}.2.fastq | samtools view -C -T ${data}/human/GRCh38_latest_genomic.fna > ${data}/simulated_reads/simulated.${prefix}.cram

