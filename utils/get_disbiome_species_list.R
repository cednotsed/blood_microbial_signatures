setwd("../Desktop/git_repos/blood_microbiome/")
require(httr)
require(tidyverse)
require(data.table)
require(foreach)

disbiome <- jsonlite::fromJSON("https://disbiome.ugent.be:8080/experiment") %>% as_tibble()
# View(disbiome)

# List all names
sample_types <- unique(disbiome$sample_name)
control_types <- unique(disbiome$control_name)
# Save
tibble(sample_type = sample_types) %>% fwrite("results/annotations/disbiome_list.sample_types.csv")
tibble(control_type = control_types) %>% fwrite("results/annotations/disbiome_list.control_types.csv")
### Please manually curate sample sites ###

# Load parsed species_list
site_df <- fread("results/annotations/disbiome_list.sample_types.parsed.csv")
# health_df <- fread("results/annotations/disbiome_list.control_types.parsed.csv")

human_only <- disbiome %>%
  rename(sample_type = sample_name) %>%
  left_join(site_df) %>%
  filter(host_type == "Human")

human_site_df <- human_only %>% 
  separate(organism_name, into = c("genus", "species", "species2"), sep = " ", remove = F) %>%
  filter(!is.na(species) & species != "cluster",
         site != "unknown") %>%
  mutate(taxa = str_trim(organism_name, side = "both")) %>%
  select(taxa, site, control_name)

healthy_site_df <- human_site_df %>%
  filter(grepl("healthy", control_name, ignore.case = T)) %>%
  filter(!grepl("patient", control_name, ignore.case = T)) %>%
  select(-control_name) %>%
  distinct()

human_site_df <- human_site_df %>% 
  select(-control_name) %>%
  distinct()

fwrite(human_site_df, "results/annotations/species_site_metadata.all_humans.csv")
fwrite(healthy_site_df, "results/annotations/species_site_metadata.healthy_humans.csv")
