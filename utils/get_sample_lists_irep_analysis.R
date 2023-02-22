rm(list = ls())
setwd("../Desktop/git_repos/blood_microbial_signatures/")
require(tidyverse)
require(data.table)
require(foreach)

# NPM data
fasta_files <- list.files("data/irep_data/genome_references/noncontams/")
# fasta_files <- list.files("data/irep_data/genome_references_Paraburkholderia/")
fasta_files <- fasta_files[grepl("fna", fasta_files)]
df <- fread("results/decontamination/read_matrix.raw.zeroed.csv")
taxa <- colnames(df)
out_dir <- "data/irep_data/sample_lists/noncontams/"
n_top <- 5
fasta_files
# Poore et al
# fasta_files <- list.files("data/poore_et_al/genome_references_poore/")
# fasta_files <- fasta_files[grepl("fasta", fasta_files)]
# df <- fread("data/poore_et_al/pipeline_2_output/07_abundance_matrix/abundance_matrix.S.tsv") %>%
#   mutate(npm_research_id = gsub("poore.", "", sample))
# out_dir <- "data/poore_et_al/sample_lists_poore"
# taxa <- colnames(df)
# n_top <- 1

# fasta_name <- fasta_files[2]
for (fasta_name in fasta_files) {
  genus <- str_split(fasta_name, "_")[[1]][1]
  species <- str_split(fasta_name, "_")[[1]][2]
  species2 <- str_split(fasta_name, "_")[[1]][3]
  species3 <- paste0(" ", str_split(fasta_name, "_")[[1]][4])
  
  taxon <- taxa[grepl(genus, taxa, ignore.case = T)]
  taxon <- c(taxon)[grepl(species, taxon, ignore.case = T)]
  taxon <- taxon[!grepl("monkey", taxon)]
  taxon <- taxon[!grepl("cangingivalis", taxon)]
  taxon <- taxon[!grepl("pseudolongum", taxon)]
  
  if (grepl("virus|oral_taxon", fasta_name)) {
    if (grepl("Torque|414", fasta_name)) {
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
        head(n_top) %>%
        select(npm_research_id)
      
      save_name <- gsub(".fna", "", fasta_name)
      
      fwrite(temp_list, str_glue("{out_dir}/{save_name}.txt"), 
             col.names = F,
             eol = "\n")
      
    } 
  } else {
    print(str_glue("{fasta_name} error!"))
  }
}
