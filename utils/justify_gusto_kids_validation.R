setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)
meta <-fread("data/SG10K_Health_metadata.n10714.16March2021.parsed.csv") 
read_df <- fread("results/decontamination/read_matrix_n157.global_decontaminated.zeroed.csv")
RA_df <- fread("results/decontamination/RA_matrix_n157.global_decontaminated.zeroed.csv")
df <- fread("results/irep_analysis/coverage_irep_results.raw.csv") %>%
  # filter(!is.na(bPTR)) %>%
  filter(!grepl("virus", prefix)) %>%
  left_join(meta) %>%
  # filter(site_supplying_sample == "HELIOS") %>%
  select(npm_research_id, site_supplying_sample, supplied_gender, genus, species, perc_covered1, perc_covered5, bPTR)

df_parsed <- fread("results/irep_analysis/coverage_irep_results.parsed.csv")
df_parsed %>%
  filter(!(taxa %in% c("Achromobacter xylosoxidans", 
                       "Pseudomonas mendocina", 
                       "Alcaligenes faecalis"))) %>%
  summarise(gt10 = sum(max_perc_covered1 > 10), gt50 = sum(max_perc_covered1 > 50))
df %>%
  group_by(genus, species) %>%
  summarise(min = min(perc_covered1), max = max(perc_covered1))
View(df)

meta_filt <- meta %>% select(npm_research_id, site_supplying_sample, supplied_gender)
prev_df <- fread("results/decontamination/prevalence_RA0.005_read10.csv") %>%
  left_join(meta_filt)

prev_df %>% 
  group_by(site_supplying_sample) %>%
  summarise(F.vaginae = sum(`Fannyhessea vaginae`),
            F.nucleatum = sum(`Fusobacterium nucleatum`),
            F.pseudoperidonticum = sum(`Fusobacterium pseudoperiodonticum`),
            L.crispatus = sum(`Lactobacillus crispatus`),
            G.vaginalis = sum(`Gardnerella vaginalis`),
            L.iners = sum(`Lactobacillus iners`),
            L.jensenii = sum(`Lactobacillus jensenii`),
            n_samples = n())



prev_df %>% 
  group_by(site_supplying_sample, supplied_gender) %>%
  summarise(F.vaginae = sum(`Fannyhessea vaginae`),
            L.crispatus = sum(`Lactobacillus crispatus`),
            G.vaginalis = sum(`Gardnerella vaginalis`),
            L.iners = sum(`Lactobacillus iners`),
            L.jensenii = sum(`Lactobacillus jensenii`),
            n_samples = n()) %>%
  pivot_longer(!c("site_supplying_sample", "n_samples", "supplied_gender"), names_to = "taxa", values_to = "count") %>%
  ggplot(aes(x = taxa, y = count, fill = supplied_gender)) +
    facet_grid(rows = vars(site_supplying_sample)) +
    geom_bar(stat = "identity") +
    geom_text(aes(x = 0, y = 90, 
                  label = str_glue("n = {n_samples}"),
                  color = supplied_gender,
                  vjust = ifelse(supplied_gender == "F", 1, 0)), 
              hjust = 0,
              size = 3) +
    labs(x = "Species", y = "No. of positive samples")
    # theme(legend.position = "none") 

ggsave("results/experimental_validation/GUSTO_vaginal_microflora.gender.png", 
       width = 6, height = 6)

RA_df %>% 
  left_join(meta_filt) %>%
  select(npm_research_id, site_supplying_sample,
         `Fannyhessea vaginae`, `Lactobacillus crispatus`, `Lactobacillus iners`,
         `Lactobacillus jensenii`) %>%
  filter(site_supplying_sample == "GUSTO") %>%
  pivot_longer(!c("site_supplying_sample", "npm_research_id"), names_to = "species", values_to = "rel_a") %>% 
  mutate(rel_a = ifelse(rel_a == 0, NA, rel_a)) %>%
  ggplot(aes(x = species, y = npm_research_id, fill = rel_a)) +
  # facet_grid(rows = vars(site_supplying_sample)) +
  geom_tile()

read_df %>% 
  filter(npm_research_id == "WHB4594") %>% 
  select(`Fusobacterium nucleatum`, `Fusobacterium pseudoperiodonticum`)


oral_to_keep <- RA_df %>% 
  left_join(meta_filt) %>%
  select(npm_research_id, site_supplying_sample, 
         `Fusobacterium nucleatum`, `Fusobacterium pseudoperiodonticum`) %>%
  filter(`Fusobacterium nucleatum` != 0 | `Fusobacterium pseudoperiodonticum` != 0) %>%
  filter(site_supplying_sample == "GUSTO") %>%
  select(npm_research_id)

RA_df %>% 
  left_join(meta_filt) %>%
  filter(npm_research_id %in% oral_to_keep$npm_research_id) %>%
  pivot_longer(!c(npm_research_id, site_supplying_sample), names_to = "taxa", values_to = "rel_a") %>%
  filter(rel_a != 0) %>% View()

vagina_to_keep <- RA_df %>% 
  left_join(meta_filt) %>%
  select(npm_research_id, site_supplying_sample,
         `Gardnerella vaginalis`, `Lactobacillus iners`, 
         `Lactobacillus crispatus`, `Lactobacillus jensenii`,
         `Fannyhessea vaginae`) %>%
  filter(`Fannyhessea vaginae` != 0 | `Lactobacillus crispatus` != 0) %>%
  # filter(site_supplying_sample == "GUSTO") %>%
  select(npm_research_id)

read_df %>% 
  left_join(meta_filt) %>%
  filter(npm_research_id %in% vagina_to_keep$npm_research_id) %>%
  pivot_longer(!c(npm_research_id, site_supplying_sample), names_to = "taxa", values_to = "rel_a") %>%
  filter(rel_a != 0) %>% View()


morsels <- foreach(taxon = c("Lactobacillus crispatus", "Fusobacterium nucleatum", "Fannyhessea vaginae")) %do% {
  prev_df %>%
    left_join(meta) %>%
    filter(get(taxon)) %>%
    summarise(n_extraction = n_distinct(extraction_kit),
              n_site = n_distinct(site_supplying_sample),
              n_flowcell = n_distinct(hiseq_xtm_flow_cell_v2_5_lot),
              n_cluster1 = n_distinct(hiseq_xtm_pe_cluster_kit_cbottm_v2__box_1_of_2__lot),
              n_cluster2 = n_distinct(hiseq_xtm_pe_cluster_kit_cbottm_v2__box_2_of_2__lot),
              n_sbs1 = n_distinct(hiseq_xtm_sbs_kit_300_cycles_v2__box_1of_2__lot),
              n_sbs2 = n_distinct(hiseq_xtm_sbs_kit_300_cycles_v2__box_2_of_2__lot)) %>%
    add_column(taxa = taxon,.before = 1)
}

bind_rows(morsels)
