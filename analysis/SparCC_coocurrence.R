setwd("../Desktop/year_3/BIOC0023/BIOC0023_dissertation/")
require(tidyverse)
require(ggplot2)
require(data.table)
require(igraph)
require(Matrix)

genus_df <- fread("data/05_abundance_matrices/gosiewski.genus.normalised.tsv")
meta <- fread("data/metadata.parsed.tsv")
pathogens <- fread("data/pathogen_list.csv") 
pathogens %>%
  select(Genus)
genera_to_keep <- colnames(genus_df)[grepl(paste(unique(pathogens$Genus), 
                               sep = "", collapse = "|"), colnames(genus_df))]
to_remove <- c("water2_S56", "water-SIGMA_S137")

genus_df <- genus_df %>% 
  filter(!(sample %in% to_remove)) %>%
  select(all_of(genera_to_keep))

# # Remove genera present in control
# blood_df <- genus_df %>%
#   filter(sample %in% meta$sample[meta$y == "Blood"]) %>%
#   column_to_rownames('sample')
# 
# control_df <- genus_df %>%
#   filter(sample %in% meta$sample[meta$y == "Control"]) %>%
#   column_to_rownames('sample')
# 
# control_df
# non_zero <- apply(control_df, 2, function(x){any(x > 0)})
# non_contaminants <- names(non_zero)[!non_zero]
# 
# X <- blood_df %>% select(non_contaminants)
# X <- t(as.matrix((X / apply(X, 1, sum))))

X <- blood_df

get_graph <- function(X) {
  set.seed(666)

  # Run SparCC
  sparcc.amgut <- sparcc(X)

  ## Define arbitrary threshold for SparCC correlation matrix for the graph
  sparcc.graph <- sparcc.amgut$Cor
  sparcc.graph[sparcc.graph < 0.15] <- 0
  diag(sparcc.graph) <- 0
  sparcc.graph <- Matrix(sparcc.graph, sparse=TRUE)

  ## Create igraph object
  vertex.names <- setNames(seq(ncol(X)), colnames(X))
  ig.sparcc <- adj2igraph(sparcc.graph, vertex.attr = vertex.names)
  V(ig.sparcc)$name <- colnames(X)

  bad.vs <- V(ig.sparcc)[degree(ig.sparcc) == 0]
  sparcc.filt <- delete.vertices(ig.sparcc, bad.vs)

  return(sparcc.filt)
}

g <- get_graph(X)
# Remove edgeless vertices
bad.vs <- V(g)[degree(g) == 0]
g <- delete.vertices(g, bad.vs)

# Plot
png(file = "results/sparCC_network.png",
    width = 10,
    height = 8,
    units = 'in',
    res = 300)

plot(g,
     margin = c(0, -0.5, 0.5, 0),
     layout = layout.fruchterman.reingold(g),
     vertex.size = 5,
     vertex.label.cex = 0.5,
     vertex.label.color = "black",
     vertex.frame.color = NA,
     vertex.label.dist = 1,
     edge.width = E(g)$weight * 10)

dev.off()
