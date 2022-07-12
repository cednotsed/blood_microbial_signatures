setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)

meta <- fread("data/SG10K_Health_metadata.n10714.16March2021.parsed.csv")
meta2 <- fread("data/20210125_v3_release/20210203_all_traits_v3.parsed.csv")
meta2$genetic_ancestry
meta %>% 
  group_by(site_supplying_sample, source_cohort) %>%
  summarise(n = n())
unique(meta$site_supplying_sample)
meta_merged <- meta %>% 
  left_join(meta2, "npm_research_id")
table(meta_merged$self_reported_ethnicity.x)
table(meta_merged$genetic_ancestry) / 9706
table(meta_merged$extraction_kit)
table(meta_merged$library_prep_kit)

decon_raw <- fread("results/decontamination/diff_prev_V3/decon_V3_raw.RA0.005.read_threshold10.csv")
unique(decon_raw$meta_col)
decon_raw %>% 
    filter(taxa == "Staphylococcus cohnii",
           fold_diff > 2, max_prev > 0.25)
decon_raw %>% 
  group_by(meta_col) {}
unique(meta$extraction_kit)
table(meta$library_prep_kit)

old_list <- fread("results/decontamination/curated_n124_global_decontamination_stats.parsed.csv")
new_list <- fread("results/decontamination/curated_n122_global_decontamination_stats.csv")

old_list$taxa[!(old_list$taxa %in% new_list$taxa)]
meta %>% 
  group_by(library_prep_kit, site_supplying_sample) %>%
  summarise(n = n())
