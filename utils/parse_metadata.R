setwd("../Downloads/")
require(data.table)
require(tidyverse)

# Raw metadata
meta <- fread("SG10K_Health_metadata.n10714.16March2021.txt")

# List of r3 samples
meta2 <- fread("SG10K_Health_r5.3.n9770.sample_ids.txt", header = F)$V1

# Parse column names
n <- gsub("[^0-9A-Za-z///' ]", "", colnames(meta))
n <- tolower(n)
n <- gsub(" ", "_", n)
colnames(meta) <- n

# Filter
meta_filt <- meta %>% 
  filter(npm_research_id %in% meta2) %>% # Retain only r5.3 samples
  replace(is.na(.), "") %>%
  filter(duplicateinfo != "TRUE.DUPLICATE") # Remove 64 duplicates

# Get 10 samples per cohort to subset data
cohorts <- unique(meta_filt$site_supplying_sample)
subset_vec <- c()

for (i in cohorts) {
  ids <- meta_filt$npm_research_id[meta_filt$site_supplying_sample == i]
  subset_ids <- sample(ids, 10)
  subset_vec <- c(subset_vec, subset_ids)
}

meta_sub <- meta_filt %>%
  filter(npm_research_id %in% subset_vec) %>%
  select(site_supplying_sample)

fwrite(meta_sub, "meta_sub.csv", row.names = F)

