setwd("../Desktop/git_repos/blood_microbial_signatures/")
require(data.table)
require(tidyverse)


df <- fread("data/taxonomic_profiles/07_abundance_matrix/abundance_matrix.S.pipeline2_210322.tsv") %>%
  separate(sample, into = c(NA, "npm_research_id"), sep = "\\.")

meta <- fread("data/SG10K_Health_metadata.n10714.16March2021.parsed.csv")
meta2 <- fread("data/SG10K_Health_r5.3.n9770.sample_ids.txt", header = F)
missing <- meta2$V1[!(meta2$V1 %in% df$npm_research_id)]
missing_df <- meta %>% 
  filter(npm_research_id %in% missing) %>%
  select(site_supplying_sample, multiplex_pool_id, npm_research_id)

fwrite(missing_df, "data/file_lists/missing.csv", col.names = F, row.names = F, eol = "\n")
