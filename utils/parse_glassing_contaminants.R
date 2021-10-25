require(tidyverse)
require(data.table)
rm(list = ls())
setwd("../Desktop/git_repos/blood_microbiome/data/reported_controls/")


species_df <- fread("glassing_2016_table_s1.csv") %>%
  filter(Species != "", 
         !grepl("unclassified|spp.", Species, ignore.case = T)) %>%
  mutate(taxa = paste(Genus, Species))

contam <- species_df %>% select(taxa)

fwrite(contam, "glassing_2016_parsed_negative.txt")
