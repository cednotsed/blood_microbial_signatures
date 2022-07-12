setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)
require(randomcoloR)

df <- fread("results/decontamination/prevalence_RA0.001_read0.csv")

plot_df <- df %>% 
  pivot_longer(!npm_research_id, names_to = "taxa", values_to = "presence") %>%
  group_by(taxa) %>%
  summarise(prev = sum(presence) / n() * 100) %>%
  arrange(desc(prev)) %>%
  rename(Species = taxa, Prevalence = prev)


fwrite(plot_df, "results/prevalence_estimates/prevalence_all_species.RA0.001_read0.csv")
plot_df %>%
  head(20) %>%
  separate(Species, into = c("Genus"), sep = " ") %>%
  group_by(Genus) %>%
  summarise(n = n())

