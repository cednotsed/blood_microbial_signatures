setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)

db <- fread("data/kraken2_taxonomy/inspect_k2_pluspf_20210517.txt", 
               skip = 7, 
               sep = "\t",
               header = F) %>%
    rownames_to_column("idx")

colnames(db) <- c("idx", "perc", "n_map_root", "n_map_taxon", "level", "taxid", "taxa")


# For inspecting taxa start and end points
kd <- db %>% 
  filter(grepl("K|D|R|P", level)) 

# kd %>% select(idx, level, taxa) %>% View()

# Demarcate inspect-report
bact <- db[3:14505]
human <- db[14506:14535]
fungi <- db[14536:14744]
others <- db[14745:14915]
plants <- db[14916:14934]
archaea <- db[14935:15674]
viruses <- db[15675:31434]
plasmids <- db[31435:nrow(db)]

# Parse species
parse_species <- function(df, name) {
  parsed <- df %>%
    filter(level == "S") %>%
    select(n_map_taxon, taxa) %>%
    mutate(org_group = name)
  
  return(parsed)
}

species_list <- bind_rows(parse_species(bact, "Bacteria"),
                          parse_species(human, "Human"),
                          parse_species(fungi, "Fungi"),
                          parse_species(others, "Other Eukaryotes"),
                          parse_species(plants, "Plants"),
                          parse_species(archaea, "Archaea"),
                          parse_species(viruses, "Viruses"),
                          parse_species(plasmids, "Plasmids"))

species_list                          

(db %>% filter(level == "S") %>% nrow()) == nrow(species_list)

fwrite(species_list, "data/kraken2_taxonomy/plusPF_20210517_species_meta.csv")

