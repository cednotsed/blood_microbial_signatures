setwd("../Desktop/git_repos/blood_microbial_signatures/")
require(tidyverse)
require(data.table)
require(foreach)

df <- fread("results/irep_analysis/coverage_irep_results.raw.csv")

df %>% 
  group_by(prefix) %>%
  summarise(microbe_pairs_mapped = max(microbe_pairs_mapped)) %>%
  left_join(df) %>%
  mutate(expected_cov1 = round(151 * 2 * microbe_pairs_mapped / microbe_length, 2)) %>%
  select(npm_research_id, prefix, microbe_pairs_mapped, expected_cov1, perc_covered1) %>%
  filter(expected_cov1 < 1) %>%
  mutate(expected_cov1 = expected_cov1 * 100) %>% 
  ggplot(aes(y = expected_cov1, x = perc_covered1)) +
  geom_point() +
  theme(text = element_text(size = 15)) +
  xlim(0, 100) +
  ylim(0, 100) +
  labs(x = "Observed coverage breadth", y = "Expected coverage breadth") +
  geom_abline(slope = 1) +
  geom_text(aes(label = prefix))
  
