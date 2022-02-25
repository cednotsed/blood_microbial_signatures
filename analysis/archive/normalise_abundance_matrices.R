setwd("../Desktop/year_3/BIOC0023/BIOC0023_dissertation/")
require(tidyverse)
require(ggplot2)
require(data.table)

genus_df <- fread("data/05_abundance_matrices/gosiewski.genus.tsv")
family_df <- fread("data/05_abundance_matrices/gosiewski.family.tsv")
order_df <- fread("data/05_abundance_matrices/gosiewski.order.tsv")
low_depth <- c("water2_S56", "water-SIGMA_S137")

filter_normalise <- function(df, to_remove) {
  filt_df <- df %>% 
    filter(!(sample %in% to_remove)) %>%
    column_to_rownames('sample')
  
  norm_df <- (filt_df / apply(filt_df, 1, sum)) %>%
    rownames_to_column('sample')
  return(norm_df)
}

order_df <- filter_normalise(df = order_df, to_remove = low_depth)
family_df <- filter_normalise(family_df, to_remove = low_depth)
genus_df <- filter_normalise(genus_df, to_remove = low_depth)

fwrite(order_df, "data/05_abundance_matrices/gosiewski.order.normalised.tsv")
fwrite(family_df, "data/05_abundance_matrices/gosiewski.family.normalised.tsv")
fwrite(genus_df, "data/05_abundance_matrices/gosiewski.genus.normalised.tsv")

# Blood only
# genus_blood <- 
genus_blood <- genus_df %>%
  filter(!grepl("water", sample)) %>%
  column_to_rownames("sample")

fwrite(genus_blood, "data/05_abundance_matrices/gosiewski.genus.normalised.blood.tsv", row.names = F, sep = "\t")
