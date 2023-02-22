setwd("c:/git_repos/blood_microbial_signatures/")
require(tidyverse)
require(data.table)
require(foreach)
require(MASS)

df <- fread("results/irep_analysis/coverage_irep_results.raw.csv") %>% 
  filter(!grepl("cohnii|haemolyticus|Achromo|Alcaligene|Pseudo", genus) & 
           !grepl("cohnii|haemolyticus|Achromo|Alcaligene|Pseudo", species)) %>%
  as_tibble()
# distinct(df, prefix) %>% View()

df_parsed <- df %>% 
  mutate(microbe_pairs_mapped = ifelse(microbe_pairs_mapped == 0, 0.01, microbe_pairs_mapped)) %>%
  mutate(log_mapped = log(microbe_pairs_mapped, 10),
         log_assigned = log(pairs_assigned, 10))

linreg <- lm(data = df_parsed, log_mapped ~ log_assigned)
studres <- studres(linreg)

plot_df <- df_parsed %>%
  mutate(studres = studres,
         species = paste0(substr(genus, 1, 1), ". ", species),
         annot = ifelse(abs(studres) > 2, T, F),
         annot_text = ifelse(annot, species, NA))
df_filt <- plot_df %>% filter(!annot)
cor.test(df_filt$pairs_assigned, df_filt$microbe_pairs_mapped)
linreg2 <- lm(data = df_filt, log_mapped ~ log_assigned)
slp <- linreg$coefficients[2]
itx <- linreg$coefficients[1]

summary(linreg)

plot_df %>%
  mutate(annot = factor(annot, c(T, F))) %>%
  ggplot(aes(x = log_assigned, 
             y = log_mapped,
             color = annot)) +
  geom_point() +
  # geom_text(aes(label = annot_text), 
  #           color = "black",
  #           size = 2) +
  geom_abline(intercept = itx, slope = slp) +
  labs(x = "log10(Kraken2 assigned pairs)", 
       y = "log10(Bowtie2 mapped pairs)",
       color = "Outlier?") +
  annotate(geom = "text",
           x = 1, y = 6, 
           hjust = 0,
           label = str_glue("y = {round(slp, 2)}x{round(itx, 2)}")) +
  annotate(geom = "text",
           x = 1, y = 5.5, 
           hjust = 0,
           label = "F=154.9, d.f.=1, p=0") +
  theme_bw()

ggsave("results/publication_figure_files/Fig_S1_mapped_assigned_regression.pdf", 
       dpi = 600,
       height = 5,
       width = 7)  

plot_df %>% 
  dplyr::select(prefix, npm_research_id, pairs_assigned, 
         log_assigned, microbe_pairs_mapped, log_mapped,
         studres, annot) %>%
  fwrite("results/figure_source_data_nat_micro/Fig_S1_mapped_assigned_regresion.csv")
  

# How many outlier points???
# plot_df %>%
#   mutate(annot = factor(annot, c(T, F))) %>%
#   ggplot(aes(x = log_assigned, 
#              y = perc_covered1,
#              color = annot)) +
#   geom_point() +
#   geom_text(aes(label = annot_text), 
#             color = "black",
#             size = 2) +
#   geom_abline(intercept = itx, slope = slp) +
#   labs(x = "log10(Kraken2 assigned pairs)", 
#        y = "log10(Bowtie2 mapped pairs)",
#        color = "Outlier?") +
#   annotate(geom = "text",
#            x = 1, y = 6, 
#            hjust = 0,
#            label = str_glue("y = {round(slp, 2)}x{round(itx, 2)}"))


parsed <- fread("results/irep_analysis/coverage_irep_results.parsed.csv")
# parsed %>%
#   filter(!grepl("cohnii|oryzae|haemolyticus", taxa)) %>%
#   summarise(range = range(max_perc_covered1))
# 
# df %>% 
#   filter(grepl("haemolyticus", species)) %>%
#   arrange(desc(pairs_assigned))
# 
parsed %>%
  filter(!grepl("cohnii|haemolyticus|Achromo|Alcaligene|Pseudo", taxa)) %>%
  summarise(sum10 = sum(max_perc_covered1 > 5) , sum50 = sum(max_perc_covered1 > 50) )

