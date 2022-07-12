setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)

meta <- fread("data/SG10K_Health_metadata.n10714.16March2021.parsed.csv")

get_meta_cols <- function(meta, meta_regex, to_exclude) {
  meta_cols <- colnames(meta)[grep(meta_regex, colnames(meta))]
  meta_cols <- meta_cols[!(meta_cols %in% to_exclude)]
  return(meta_cols)
}

meta_cols <- get_meta_cols(meta, 
                           meta_regex = "kit|flow_cell|site_supplying", 
                           to_exclude = c("hiseq_xtm_flow_cell_v2_5_id"))

meta_cols

count_df <- meta %>% 
  select(all_of(c("npm_research_id", meta_cols)))
  # pivot_longer(!npm_research_id, names_to = "kit_type", values_to = "batch")
  # group_by(kit_type, batch) %>%
  # summarise(n_samples = n())

fwrite(count_df, "results/reagent_kits.csv")
