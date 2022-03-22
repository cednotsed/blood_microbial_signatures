rm(list = ls())
setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)

prev_max_filt <- fread("results/decontamination/")

fasta_files <- list.files("data/irep_data/genome_references/")
fasta_files <- fasta_files[grepl("fasta", fasta_files)]
df <- fread("results/decontamination/read_matrix_n157.global_decontaminated.zeroed.csv")
taxa <- colnames(df)

# fasta_name <- fasta_files[2]
for (fasta_name in fasta_files) {
  genus <- str_split(fasta_name, "_")[[1]][1]
  species <- str_split(fasta_name, "_")[[1]][2]
  
  taxon <- taxa[grepl(genus, taxa, ignore.case = T)]
  taxon <- c(taxon)[grepl(species, taxon, ignore.case = T)]
  
  if (length(taxon) != 0) {
    
    temp_list <- df %>% 
      select(all_of(c("npm_research_id", taxon))) %>%
      filter(get(taxon) != 0) %>%
      arrange(desc(get(taxon))) %>%
      head(5) %>%
      select(npm_research_id)
    
    fwrite(temp_list, str_glue("data/irep_data/sample_lists/{fasta_name}.txt"), col.names = F)
  }
}
