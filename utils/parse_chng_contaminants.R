require(tidyverse)
require(data.table)

setwd("../Desktop/git_repos/blood_microbiome/data/reported_controls/")

meta <- fread("illumina_metadata.txt") %>%
  filter(grepl("control", Sample_type, ignore.case = T))
controls <- meta$Library
species_df <- fread("raw_files/hospital_microbiome.tsv") %>%
  select(all_of(c("Index", controls))) %>%
  separate(Index, into = c(NA, "taxa"), sep = "__") %>%
  mutate(taxa = gsub("_", " ", taxa)) %>%
  as_tibble()

RA_df <- apply(species_df[, 2:ncol(species_df)], 2, function(x) {return(x / sum(x))})
RA_df <- as.data.frame(RA_df)
rownames(RA_df) <- species_df$taxa

RA_df[RA_df <= 0.001] <- 0
RA_df[RA_df > 0.001] <- 1

row_sums <- rowSums(RA_df)
contam <- names(row_sums)[row_sums > 0]

fwrite(tibble(taxa = contam), "chng_2020_parsed_negative.txt")
