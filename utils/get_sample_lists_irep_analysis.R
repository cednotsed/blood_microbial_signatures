rm(list = ls())
setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)

prev_max_filt <- fread("results/decontamination/")

fasta_files <- list.files("data/irep_data/genome_references/")
fasta_files <- fasta_files[grepl("fasta", fasta_files)]
df <- fread("results/decontamination/read_matrix.raw.zeroed.csv")
taxa <- colnames(df)

# fasta_name <- fasta_files[2]
for (fasta_name in fasta_files) {
  genus <- str_split(fasta_name, "_")[[1]][1]
  species <- str_split(fasta_name, "_")[[1]][2]
  species2 <- str_split(fasta_name, "_")[[1]][3]
  species3 <- paste0(" ", str_split(fasta_name, "_")[[1]][4])
  
  taxon <- taxa[grepl(genus, taxa, ignore.case = T)]
  taxon <- c(taxon)[grepl(species, taxon, ignore.case = T)]
  taxon <- taxon[!grepl("monkey", taxon)]
  
  if (grepl("virus", fasta_name)) {
    if (grepl("Torque", fasta_name)) {
      taxon <- taxon[grepl(species2, taxon)]
      taxon <- taxon[grepl(species3, taxon)]
    } else {
      taxon <- taxon[grepl(species2, taxon)]
    }
  }
  
  if(length(taxon) == 1) {
  
    if (length(taxon) != 0) {
      
      temp_list <- df %>% 
        select(all_of(c("npm_research_id", taxon))) %>%
        filter(get(taxon) != 0) %>%
        arrange(desc(get(taxon))) %>%
        head(10) %>%
        select(npm_research_id)
      
      save_name <- gsub(".fasta", "", fasta_name)
      
      fwrite(temp_list, str_glue("data/irep_data/sample_lists/{save_name}.txt"), 
             col.names = F,
             eol = "\n")
      
    } 
  } else {
    print(str_glue("{fasta_name} error!"))
  }
}
