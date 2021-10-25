require(tidyverse)
require(data.table)

setwd("../Desktop/git_repos/blood_microbiome/data/reported_non_contaminants/")

species_df <- fread("nejman_2019_table_s2.csv") %>%
  filter(!grepl("Unknown", V1)) %>%
  filter(V1 != "") %>%
  filter(!is.na(V1))

species_df <- t(species_df)
cols <- as.vector(species_df["V1", ])
species_df <- as.data.frame(species_df[2:nrow(species_df), ])
colnames(species_df) <- cols

# View(species_df)
control_df <- species_df %>% 
  rename(tissue_type = "Tissue type") %>%
  filter(grepl("control", tissue_type))
