setwd("../Desktop/year_3/BIOC0023/BIOC0023_dissertation/")
require(tidyverse)
require(ggplot2)
require(data.table)
require(ape)
require(vegan)
require(Rtsne)

genus_df <- fread("data/05_abundance_matrices/gosiewski.genus.normalised.tsv")
meta <- fread("data/metadata.parsed.tsv")

low_depth <- c("water2_S56", "water-SIGMA_S137")
# water <- genus_df$sample[grepl("water", genus_df$sample)]
# to_remove <- unique(c(low_depth, water))

genus_df <- genus_df %>% 
  filter(!(sample %in% low_depth)) %>%
  column_to_rownames('sample')

# K-means
kmeans <- kmeans(genus_df, centers = 3, nstart = 25)
clusters <- tibble(cluster = kmeans$cluster, sample = names(kmeans$cluster))

# t-SNE
size <- 2
X <- vegdist(genus_df, "bray")

set.seed(66)

# Get Bray-Curtis pairwise matrix
bc <- vegdist(X, method = "bray")
perp <- 2

tsne <- Rtsne(bc,
              verbose = T,
              perplexity = perp,
              max_iter = 10000,
              is_distance = T,
              pca = F,
              theta = 0)

plot_df <- tibble(X1 = tsne$Y[, 1], 
                  X2 = tsne$Y[, 2], 
                  sample = rownames(genus_df)) %>%
  left_join(meta, "sample") %>%
  left_join(clusters, "sample") %>%
  mutate(cluster = as.character(cluster))
  
plt1 <- ggplot(plot_df, aes(x = X1, y = X2, color = y, shape = cluster)) +
  geom_point(size = size, alpha = 0.8) +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "left") +
  # geom_text(aes(x = X1, y = X2, color = y, label = sample),
  #           position = position_nudge(x = -0.5),
  #           size = 2, 
  #           color = "black") +
  labs(color = "Sample type", shape = "k-means cluster")
plt1

ggsave("results/tsne.svg", 
       dpi = 600, 
       width = 5,
       height = 4,
       plot = plt1)
