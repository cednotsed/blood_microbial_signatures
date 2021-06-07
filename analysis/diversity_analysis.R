setwd("../Desktop/year_3/BIOC0023/BIOC0023_dissertation/")
require(tidyverse)
require(ggplot2)
require(data.table)
require(vegan)
require(adiv)
require(Rarefy)

genus_df <- fread("data/05_abundance_matrices/gosiewski.genus.tsv")
low_depth <- c("water2_S56", "water-SIGMA_S137")
meta <- fread("data/metadata.parsed.tsv")

genus_df <- genus_df %>% 
  filter(!(sample %in% low_depth)) %>%
  column_to_rownames('sample')

rare_df <- tibble()

for (n in seq(1, 16160, by = 100)) {
  rare <- rarefy(genus_df, sample = n)
  morsel <- tibble(n = n, sample = names(rare), richness = rare)
  rare_df <- bind_rows(rare_df, morsel)
}

rare_df <- rare_df %>%
  left_join(meta, "sample")

richness_plt <- rare_df %>%
  ggplot(aes(x = n, y = richness, color = y)) +
  geom_line(aes(fill = sample)) +
  labs(x = "No. of sequences sampled", 
       y = "Expected richness", 
       color = "Sample type") +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank())

## Rarefaction for alpha diversity ##
subsample_matrix <- function(df, n_reads) {
  X <- as.data.frame(df)
  rarefied_X <- as_tibble(colnames(X)) %>%
    rename(g_name = value)
  
  for (idx in seq(nrow(X))) {
    sample <- as.list(X[idx, ])
    row_name <- rownames(X)[idx]
    non_zero <- sample[sample > 0] # convert to set
    genus_list <- names(sample)
    collection <- c()
    
    for (i in seq(length(non_zero))) {
      g_name <- genus_list[i]
      g_count <- non_zero[[i]]
      collection <- c(collection, rep(g_name, g_count))
    }
    
    rarefied <- sample(collection, n_reads)
    rarefied <- as_tibble(table(rarefied))
    colnames(rarefied) <- c("g_name", row_name)
    
    rarefied_X <- rarefied_X %>%
      left_join(rarefied, "g_name")
  }
  
  return(rarefied_X %>% replace(., is.na(.), 0))
}

# Calculate rarefied metrics
seq_list <- seq(1, 16160, 1000)
metric_df <- tibble()

for (n in seq_list) {
  morsel <- subsample_matrix(genus_df, n) %>%
    # Start transpose
    gather(var, value, -g_name) %>% 
    spread(g_name, value) %>%
    column_to_rownames("var")
    # End transpose
  
  # Normalise abundance
  morsel <- (morsel / apply(morsel, 1, sum))
  
  shannon <- diversity(morsel, "shannon")
  shannon_df <- tibble(n = n, shannon = shannon, sample = names(shannon))
  metric_df <- bind_rows(metric_df, shannon_df)
}

shannon_plt <- metric_df %>%
  left_join(meta, "sample") %>%
  ggplot(aes(x = n, y = shannon, color = y)) +
  geom_line(aes(fill = sample)) +
  labs(x = "No. of sequences sampled", 
       y = "Shannon diversity", 
       color = "Sample type")


diversity_plt <- ggpubr::ggarrange(richness_plt, shannon_plt, 
                                   common.legend = T, 
                                   ncol = 1,
                                   align = "hv")

ggsave("results/diversity_plots.svg", 
       dpi = 600, 
       width = 5,
       height = 4,
       plot = diversity_plt)
