setwd("../Desktop/year_3/BIOC0023/BIOC0023_dissertation/")
require(tidyverse)
require(ggplot2)
require(data.table)

# Parse meta
meta <- fread("data/metadata.filt.tsv") %>%
  separate(forward, sep = "_", into = c("s1", "s2", NA)) %>%
  mutate(sample = paste0(s1, "_", s2)) %>%
  mutate(y = case_when(y == "control" ~ "Blood",
                       y == "ntc" ~ "Control"))

fwrite(meta, "data/metadata.parsed.tsv")