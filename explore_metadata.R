setwd("../Desktop/git_repos/blood_microbiome")
require(data.table)
require(tidyverse)
require(ggplot2)
df <- fread("data/SG10K_Health_metadata.n10714.16March2021.txt")
View(df)

columns <- colnames(df)
to_keep <- columns[!(columns %in% )]
filt <- df %>%
  select("Self Reported Ethnicity", "Supplied Gender", "Extraction Kit", "Year Of Birth", 
         "Extraction Date", "Plate position", "Plate ID", "Designed cov", 
         "CREATED_BY", "PROJECT_ID", "Library prep kit",
         "Instrument ID") %>%
  mutate(across(everything(), ~replace(., . == "", "unknown")))
  
col_list <- apply(filt, 2, table)
fig_list <- list()

for (i in seq(length(col_list))) {
  col <- col_list[[i]]
  col_name <- names(col_list)[i]
  
  temp <- data.table(col) %>%
    mutate(V1 = str_trunc(V1, 10, "left")) %>%
    ggplot(aes(x = V1, y = N, fill = V1)) +
    geom_bar(stat = "identity") +
    geom_text(aes(label = N)) +
    labs(x = col_name, y = "Frequency") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = "none")
  fig_list[[i]] <- temp
}

plt <- egg::ggarrange(plots = fig_list, nrow = 4, ncol = 3)

ggsave("results/metadata.png", plot = plt, height = 12, width = 12)
