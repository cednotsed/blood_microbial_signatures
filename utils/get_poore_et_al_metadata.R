setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)
meta <- fread("data/poore_et_al/12667_20201124-125327.txt")

healthy <- meta %>% 
  filter(aids_status_clean == "Control") %>%
  filter(antibacterial != 1, 
         antifungal != 1, 
         antiviral != 1)

blanks <- meta %>% 
  filter(grepl("blank", empo_3, ignore.case = T))

all <- bind_rows(healthy, blanks) %>%
  select(sample_name, sample_type, 
         bacterial_dna_concentration, human_dna_concentration,
         bmi, bnethni, bngendr, bnviage,
         cholesterol_total, hdl_cholesterol,
         ldl_cholesterol, triglycerides,
         diabetes, hyperlipidemia, hypertension,
         systolic_bp, diastolic_bp)

nrow(all)

# Sample links
df <- fread("data/poore_et_al/filereport_read_run_PRJEB36408_tsv.txt")
sum(all$sample_name %in% df$sample_title) == nrow(all)

df_filt <- df %>% 
  filter(sample_title %in% all$sample_name) %>%
  select(-sample_accession)

# Get highest read count library
morsels <- foreach(sample_id = df_filt$sample_title) %do% {
  temp <- df_filt %>%
    filter(sample_title == sample_id) %>%
    arrange(desc(read_count)) %>%
    head(1)
  temp
}

df_final <- bind_rows(morsels)

df_final %>% 
  group_by(sample_title) %>%
  summarise(n = n()) %>%
  arrange(n)
