#Mapping
ref_name=Bacillus_cereus_NZ_CP072774.1.fasta
fastq_name=WHH5104

ref_name=Bacillus_cereus_NZ_CP072774.1.fasta
fastq_name=WHB534

ref_name=Bacillus_cereus_NZ_CP072774.1.fasta
fastq_name=WHH5150

ref_name=Human_mastadenovirus_C_NC_001405.1.fasta
fastq_name=WHB6121

ref_name=Cutibacterium_acnes_NC_021085.1.fasta
fastq_name=WHB8433

ref_name=Cutibacterium_acnes_NC_021085.1.fasta
fastq_name=WHB8505
fastq_name=0816-0079
#ref_name=Gardnerella_vaginalis_NZ_PKJK01000001.1.fasta
#fastq_name=WHB9812

#ref_name=Staphylococcus_haemolyticus_NZ_CP013911.1.fasta
#fastq_name=0416-0024

#ref_name=Pseudomonas_mendocina_NZ_CP013124.1.fasta
#fastq_name=0715-0061

#ref_name=Paracoccus_yeei_NZ_CP024422.1.fasta
#fastq_name=WHH1680

#ref_name=Burkholderia_contaminans_GCF_004723625.1_ASM472362v1.fasta
#fastq_name=WHB10821

#ref_name=Neisseria_subflava_NZ_CP039887.1.fasta
#fastq_name=WHB9179

#ref_name=Rickettsia_felis_NZ_JSEL01000013.1.fasta
#fastq_name=WHB9978

#ref_name=Haemophilus_parainfluenzae_NZ_GL872339.1.fasta
#fastq_name=WHB9179

#ref_name=Haemophilus_parainfluenzae_NZ_GL872339.1.fasta
#fastq_name=WHB8397

#ref_name=Corynebacterium_segmentosum_NZ_LR134408.1.fasta
#fastq_name=WHB6459

#ref_name=Staphylococcus_epidermidis_NZ_CP035288.1.fasta
#fastq_name=WHB6459

ref_name=Staphylococcus_epidermidis_NZ_CP035288.1.fasta
fastq_name=WHB4219

#ref_name=Lactobacillus_crispatus_NZ_CP039266.1.fasta
#fastq_name=WHB10710

#ref_name=Lactobacillus_crispatus_NZ_CP039266.1.fasta
#fastq_name=WHB4450

#ref_name=Fusobacterium_periodonticum_NZ_GG665898.1.fasta
#fastq_name=WHB4594

#ref_name=Acinetobacter_baumannii_NZ_CP043953.1.fasta
#fastq_name=0116-0053

#ref_name=Microbacterium_PAMC_28756_NZ_CP014313.1.fasta
#fastq_name=WHB3375

#ref_name=Microbacterium_PM5_NZ_CP022162.1.fasta
#fastq_name=WHB10821

#ref_name=Microbacterium_PM5_NZ_CP022162.1.fasta
#fastq_name=WHB10753

#ref_name=Microbacterium_Y-01_NZ_CP024170.1.fasta
#fastq_name=WHB3375

#ref_name=Microbacterium_paraoxydans_NZ_LT629770.1.fasta
#fastq_name=WHB3375

#ref_name=Enterobacter_cloacae_NZ_CP009756.1.fasta
#fastq_name=WHB10343

#ref_name=Ralstonia_solanacearum_NZ_CP088237.1.fasta
#fastq_name=0416-0024

#ref_name=Fusobacterium_nucleatum_NZ_LN831027.1.fasta
#fastq_name=WHB4594

#ref_name=Achromobacter_xylosoxidans_NZ_CP043820.1.fasta
#fastq_name=WHB3734

#ref_name=Staphylococcus_cohnii_NZ_UHDA01000001.1.fasta
#fastq_name=0416-0024

#ref_name=Zhihengliuella_ISTPL4_NZ_CP025422.1.fasta
#fastq_name=1114-0063

#ref_name=Microbacterium_hominis_NZ_CP061344.1.fasta
#fastq_name=WHB10821

# Parse file paths
ref_path=../data/irep_data/genome_references/${ref_name}
ref_index_dir=$(echo ${ref_path}|sed 's/.fasta//g')

fastq_1=$(ls ../data/irep_data/libraries/*.${fastq_name}.*.1.*)
fastq_2=$(ls ../data/irep_data/libraries/*.${fastq_name}.*.2.*)

result_dir=../results/irep_analysis
map_out=${result_dir}/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.sam/g')

table_path=${result_dir}/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.tsv/g')
pdf_path=${result_dir}/$(echo ${fastq_name}_${ref_name} | sed 's/.fasta/.pdf/g')

# Indexing
bowtie2-build ${ref_path} ${ref_index_dir}

# Mapping
bowtie2 -x ${ref_index_dir} -1 ${fastq_1} -2 ${fastq_2} -S ${map_out} --reorder -p 8

# iRep
bPTR -f ${ref_path} -s ${map_out} -o ${table_path} -plot ${pdf_path} -m coverage -ff
