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
  mutate(taxa = gsub("_", " ", taxa))

row_sums <- apply(species_df[, 2:ncol(species_df)], 1, sum)

contam <- species_df %>% 
  filter(row_sums > 0, !grepl("unclassified", taxa)) %>%
  select(taxa)

fwrite(contam, "caregiver_parsed_negative.txt")

