require(tidyverse)
require(data.table)
rm(list = ls())
setwd("../Desktop/git_repos/blood_microbiome/data/reported_controls/")

meta <- fread("raw_files/negative_controls_asmp.csv")
controls <- meta$LibraryID

# Missing data
missing <- controls[!(controls %in% colnames(merged_df))]
meta %>% filter(LibraryID %in% missing) %>% View()

merged_df <- tibble(taxa = "dummy")
batches <- c("BATCH1_taxonomic_profiles_new_withdatatopup", 
             "BATCH2_taxonomic_profiles", 
             "BATCH3_taxonomic_profiles", 
             "PILOT_taxonomic_profiles")

for (batch in batches) {
# batch <- "PILOT"
  df <- fread(str_glue("raw_files/HELIOS_{batch}.csv")) %>%
  select(any_of(c("Index", controls))) %>%
  separate(Index, into = c(NA, "taxa"), sep = "__") %>%
  mutate(taxa = gsub("_", " ", taxa))
  
  merged_df <- merged_df %>% full_join(df)
}

# Replace na with zeros
merged_df[is.na(merged_df)] <- 0

# Get row sums
merged_df <- merged_df %>% column_to_rownames("taxa")
merged_df[merged_df <= 0.001] <- 0
merged_df[merged_df > 0.001] <- 1

row_sums <- rowSums(merged_df)
contam <- names(row_sums)[row_sums > 0]

fwrite(tibble(taxa = contam), "asmp_parsed_negative.txt")
