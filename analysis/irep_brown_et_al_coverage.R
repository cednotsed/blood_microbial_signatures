setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)

df <- fread("data/irep_data/NIHMS884305-supplement-ST3.csv")

df %>% 
  group_by(coverage) %>%
  summarise(n = n())


df %>%
  mutate(coverage = factor(coverage)) %>%
  ggplot(aes(x = bPTR, fill = coverage)) +
  facet_grid(rows = vars(coverage)) +
  geom_histogram()
df
