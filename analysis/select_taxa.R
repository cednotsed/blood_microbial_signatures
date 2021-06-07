setwd("../Desktop/year_3/BIOC0023/BIOC0023_dissertation/")
require(tidyverse)
require(ggplot2)
require(data.table)
require(ggsci)

genus_df <- fread("data/05_abundance_matrices/gosiewski.genus.normalised.tsv")
meta <- fread("data/metadata.parsed.tsv")

X <- genus_df %>%
  column_to_rownames("sample")

# Find genera that are non-zero in all samples
num_genera <- apply(X, 2, function(x){sum(x != 0)})
genera <- names(num_genera[num_genera == 26])
plt1 <- X %>%
  select(all_of(genera)) %>%
  mutate(across(everything(), function(x) {log(x / Bradyrhizobium)})) %>%
  rownames_to_column("sample") %>%
  pivot_longer(!sample, names_to = "rank", values_to = "abundance") %>%
  inner_join(meta, "sample") %>%
  ggplot(aes(x = y, y = abundance, fill = y)) +
  theme_bw() +
  geom_point(size = 1, position = "jitter") +
  geom_boxplot(alpha = 0.8) +
  facet_wrap(. ~ rank, ncol = 3) +
  labs(y = "Relative differential abundance", fill = "Sample type") +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank())

## Presence absence Heatmap ##
long_df <- genus_df %>% 
  pivot_longer(!sample, names_to = "rank", values_to = "abundance") %>%
  inner_join(meta, "sample")

in_blood <- long_df %>%
  filter(y == "Blood", abundance != 0) %>%
  distinct(rank, sample, .keep_all = T) %>%
  group_by(rank) %>%
  summarise(n_pos = n()) %>%
  filter(n_pos == 23)

in_control <- long_df %>%
  filter(y == "Control", abundance != 0) %>%
  distinct(rank, sample, .keep_all = T) %>%
  group_by(rank) %>%
  summarise(n_pos = n()) %>%
  filter(n_pos == 3)

ranks_to_keep <- in_blood %>%
  filter(!(rank %in% in_control$rank))
ranks_to_keep <- ranks_to_keep$rank

plt2 <- long_df %>%
  filter(rank %in% ranks_to_keep) %>%
  mutate(sample = factor(sample, levels = unique(sample)[order(sample)]),
         abundance = na_if(abundance, 0)) %>%
  # mutate(sample = factor(sample, levels = unique(sample)[order(sample)]),
  # abundance = case_when(abundance < 1e-5 ~ 0, T ~ abundance)) %>% 
  # mutate(abundance = na_if(abundance, 0)) %>% 
  ggplot(aes(x = sample, y = rank, fill = abundance)) +
  geom_tile() +
  scale_fill_gradient(low = "#00798c", high = "#cc3300", na.value = "black") +
  labs(x = "Sample", y= "Genus", fill = "Relative abundance (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text.y = element_text(size = 8),
        axis.ticks.x = element_blank())

final_plt <- egg::ggarrange(plt2, plt1, 
                            nrow = 2,
                            heights = c(1, 5))
final_plt
ggsave("results/select_taxa.svg",
       plot = final_plt,
       dpi = 600,
       width = 8,
       height = 9)
