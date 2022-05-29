setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)
wkdir <- "data/blood_culture_records/raw_csvs"
file_list <- list.files(wkdir)
file_list

morsels <- foreach(file = file_list) %do% {
  culture_type <- str_split(file,  "_")[[1]]
  year_collected <- culture_type[1]
  culture_type <- gsub(".csv", "", culture_type[2])
  
  temp <- fread(str_glue("{wkdir}/{file}")) %>%
    mutate(culture_type = culture_type,
           year_collected = year_collected)
  colnames(temp) <- tolower(gsub("[^[:alnum:]]", "", colnames(temp)))
  colnames(temp)[grepl("digit", colnames(temp))] <- "aclast4digits"
  temp
}

to_save <- bind_rows(morsels) %>%
  select(-collection, -source)

fwrite(to_save, "data/blood_culture_records/blood_culture_records.parsed.csv")
