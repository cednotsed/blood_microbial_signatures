require(tidyverse)
require(data.table)
rm(list = ls())
setwd("../Desktop/git_repos/blood_microbiome/data/reported_controls/")


species_df <- read.table("raw_files/caregiver.table.s.tsv") %>%
  rownames_to_column("taxa")

meta <- fread("raw_files/caregiver.meta.tsv")

controls <- meta %>%
  filter(sample_category == "blank")
controls <- controls$LibraryID

species_df <- species_df %>% 
  select(all_of(c("taxa", controls))) %>%
  mutate(taxa = gsub("\\[|\\]", "", taxa)) %>%
  mutate(taxa = gsub("_", " ", taxa)) %>%
  as_tibble()

RA_df <- apply(species_df[, 2:ncol(species_df)], 2, function(x) {return(x / sum(x))})
RA_df <- as.data.frame(RA_df)
rownames(RA_df) <- species_df$taxa

RA_df[RA_df <= 0.001] <- 0
RA_df[RA_df > 0.001] <- 1

row_sums <- rowSums(RA_df)
contam <- names(row_sums)[row_sums > 0]

fwrite(tibble(taxa = contam), "caregiver_parsed_negative.txt")

