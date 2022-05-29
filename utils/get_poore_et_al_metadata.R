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

meta %>% 
  filter(aids_status_clean == "Control") %>%
  filter(antibacterial == 1| antifungal == 1| antiviral == 1) %>%
  View()

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
morsels <- foreach(sample_id = all$sample_name) %do% {
  temp <- df_filt %>%
    filter(sample_title == sample_id) %>%
    arrange(desc(read_count)) %>%
    head(1)
  temp
}

df_final <- bind_rows(morsels)

final_meta <- df_final %>%
  rename(sample_name = sample_title) %>%
  left_join(all)

links_only <- final_meta %>%
  select(fastq_ftp) %>%
  separate(fastq_ftp, into = c("fastq1", "fastq2"), sep = ";")
links_only <- tibble(links = paste0("http://", c(links_only$fastq1, links_only$fastq2)))

fwrite(final_meta %>% select(-fastq_ftp), "data/poore_et_al/poore_meta.parsed.csv") 
fwrite(links_only, "data/poore_et_al/poore_fastq_links.txt", col.names = F, eol = "") 
