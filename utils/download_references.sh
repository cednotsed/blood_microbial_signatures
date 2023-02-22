ref_dir=/mnt/c/Users/Cedric/Desktop/git_repos/blood_microbial_signatures/data/irep_data/genome_references/contams

accessions=$(esearch -db assembly \
		-query '"Sphingobium sp. YG1"[Organism] AND "latest RefSeq"[filter] AND (all[filter] NOT anomalous[filter])' | esummary | xtract -pattern DocumentSummary \
		-element AssemblyAccession)

# Get first accession
accession=$(echo $accessions| awk '{print $1}')
echo $accession

# Download genome
esearch -db assembly -query $accession | elink -target nucleotide -name \
        assembly_nuccore_refseq | efetch -format fasta > $ref_dir/Sphingobium_YG1_${accession}.fna


