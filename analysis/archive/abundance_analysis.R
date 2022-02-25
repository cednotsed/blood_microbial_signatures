setwd("../Desktop/year_3/BIOC0023/BIOC0023_dissertation/")
require(tidyverse)
require(ggplot2)
require(data.table)
require(ggsci)

genus_df <- fread("data/05_abundance_matrices/gosiewski.genus.normalised.tsv")
family_df <- fread("data/05_abundance_matrices/gosiewski.family.normalised.tsv")
order_df <- fread("data/05_abundance_matrices/gosiewski.order.normalised.tsv")

n_keep <- 8

## Plot abundance ##
plot_abundance <- function(df, n_keep, rank_name) {
  pal <- c("#d1495b", "#00798c", "#edae49", 
           "#66a182", "#2e4057", "#8d96a3",
           "#8E44AD", "#2980b9")
  long_df <- df %>%
    pivot_longer(!sample, names_to = "rank", values_to = "abundance")
  
  ranks_to_keep <- long_df %>% 
    group_by(rank) %>%
    summarise(median = median(abundance)) %>%
    arrange(desc(median))
  ranks_to_keep <- ranks_to_keep$rank[1:n_keep]
  
  plt <- long_df %>%
    filter(rank %in% ranks_to_keep) %>%
    mutate(sample = factor(sample, levels = unique(sample)[order(sample)])) %>%
    ggplot(aes(x = sample, y = abundance, fill = rank)) +
    geom_bar(stat = "identity", position = "stack") +
    labs(x = "Sample", y = "Relative abundance (%)", fill = rank_name) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          axis.ticks.x = element_blank()) +
    scale_fill_manual(values = pal[1:n_keep])
  return(plt)
}

plt_order <- plot_abundance(order_df, n_keep, "Order")
plt_family <- plot_abundance(family_df, n_keep, "Family")
plt_genus <- plot_abundance(genus_df, n_keep, "Genus")

ggsave("results/genus_abundance.svg",
       width = 5,
       height = 4,
       dpi = 600, 
       plot = plt_genus)

# For combining plots
plt_genus <- plt_genus + 
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank())
