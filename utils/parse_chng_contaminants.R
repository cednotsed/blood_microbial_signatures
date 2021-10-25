require(tidyverse)
require(data.table)

setwd("../Desktop/git_repos/blood_microbiome/data/reported_controls/")

meta <- fread("illumina_metadata.txt") %>%
  filter(grepl("control", Sample_type, ignore.case = T))
controls <- meta$Library
species_df <- fread("metagenomics.metaphlan2.table.s") %>%
  select(all_of(c("Index", controls))) %>%
  separate(Index, into = c(NA, "taxa"), sep = "__") %>%
  mutate(taxa = gsub("_", " ", taxa))
row_sums <- apply(species_df[, 2:ncol(species_df)], 1, sum)

contam <- species_df %>% 
  filter(row_sums > 0, !grepl("unclassified", taxa)) %>%
  select(taxa)

fwrite(contam, "chng_2020_parsed_negative.txt")
