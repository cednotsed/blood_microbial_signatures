setwd("../Desktop/year_3/BIOC0023/BIOC0023_dissertation/")
require(tidyverse)
require(ggplot2)
require(data.table)
require(ape)
require(vegan)

genus_df <- fread("data/05_abundance_matrices/gosiewski.genus.normalised.tsv")
low_depth <- c("water2_S56", "water-SIGMA_S137")
meta <- fread("data/metadata.parsed.tsv")

genus_df <- genus_df %>% 
  filter(!(sample %in% low_depth)) %>%
  column_to_rownames('sample')

# PCoA
X <- vegdist(genus_df, "bray")
p <- pcoa(X)

# Plot eigenvalues
eigen <- p$values$Rel_corr_eig
eigen_df <- tibble(eigen = eigen, pc = seq(length(eigen))) %>%
  mutate(eigen = eigen * 100)
eigen_plot <- ggplot(eigen_df, aes(x = pc, y = eigen, fill = eigen)) +
  geom_bar(stat = "identity") +
  # geom_text(aes(label = round(eigen, 1)), vjust = -0.1, size = 2) +
  labs(x = "PCo axis", y = "Variance explained (%)") +
  scale_fill_gradient(low = "steelblue", high = "red") +
  theme(legend.position = "none")

# Plot PCoA
eigenvecs <- p$vectors
assertthat::are_equal(names(eigenvecs[, 1]), names(eigenvecs[, 2])) # Check
vec_df <- tibble(PC1 = eigenvecs[, 1], 
                 PC2 = eigenvecs[, 2], 
                 PC3 = eigenvecs[, 3], 
                 sample = names(eigenvecs[, 2])) %>%
  inner_join(meta, by = "sample")

pca_plot <- ggplot(vec_df, aes(x = PC1, y = PC2, color = y)) +
  geom_point() +
  labs(x = "PCo1", y = "PCo2", color = "Sample type") +
  theme(legend.position = "none")

plot1 <- egg::ggarrange(plots = list(pca_plot, eigen_plot))
ggsave("results/pcoa.svg", 
       dpi = 600, 
       width = 5,
       height = 4,
       plot = plot1)
