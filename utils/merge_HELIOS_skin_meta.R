setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)

file_list <- list.files("data/reported_controls/raw_files/", "IDs", full.names = T)
file_list

morsels <- foreach(file = file_list) %do% {
  temp <- fread(file) %>%
    select(LibraryID, )
}

merged <- bind_rows(morsels) %>%
  rename(npm_research_id = LibraryID)
meta <- fread("data/SG10K_Health_metadata.n10714.16March2021.parsed.csv")
sum(merged$npm_research_id %in% meta$npm_research_id)
