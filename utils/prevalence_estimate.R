rm(list = ls())
setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)

count_df <- fread("results/prevalence_estimates/cutibacterium_acnes/cutibacterium_acnes_mapping_counts_all.csv")
df <- fread("results/decontamination/prevalence_RA0.005_read10.csv")
df_relaxed <- fread("results/decontamination/prevalence_RA0.001_read0.csv")

# Prevalence without decontamination
df %>%
  pivot_longer(!npm_research_id, names_to = "taxa", values_to = "presence") %>%
  group_by(taxa) %>%
  summarise(prevalence = sum(presence) / nrow(df)) %>%
  arrange(desc(prevalence)) %>%
  head(10)

df_relaxed %>%
  pivot_longer(!npm_research_id, names_to = "taxa", values_to = "presence") %>%
  group_by(taxa) %>%
  summarise(prevalence = sum(presence) / nrow(df_relaxed)) %>%
  arrange(desc(prevalence)) %>%
  head(10)

count_filt <- count_df %>% 
  filter(npm_research_id %in% df$npm_research_id) %>%
  mutate(pairs_mapped = reads_mapped / 2)

morsels <- foreach(n_reads = seq(0, 100)) %do% {
  count_filt %>% 
    summarise(prev = sum(pairs_mapped >= n_reads) / 8828) %>%
    add_column(n_reads = n_reads, .before = 1)
}

bind_rows(morsels) %>%
  ggplot(aes(x = n_reads, y = prev)) +
  geom_line() +
  theme_bw() +
  theme(text = element_text(size = 15)) +
  labs(x = "Read pair threshold", y = "Prevalence (%)")

ggsave("results/prevalence_estimates/cutibacterium_acnes/prevalence_estimates.png", 
       dpi = 600,
       width = 5, height = 5)
bind_rows(morsels) 

count_filt %>% 
  summarise(prev = sum(pairs_mapped >= n_reads) / 8828)