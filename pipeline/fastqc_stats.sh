for file in parsed_fastq/*.fastq
do
    fastqc ${file} -o ./qc_files

done

multiqc ./qc_files
