setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)
require(reactable)
require(htmltools)
require(htmlwidgets)
require(webshot2)

files <- list.files("results/irep_analysis/", full.names = T)
files <- files[grepl(".tsv", files)]

morsels <- foreach(file = files) %do% {
  temp_df <- read.csv(file, sep = "\t")
  file_name <- gsub("results/irep_analysis/", "", file)
  sample_name <- str_split(file_name, pattern = "_")[[1]][1]
  reference_accession <- paste0(str_split(file_name, pattern = "_")[[1]][4:5], collapse = "_")
  reference_accession <- gsub(".tsv", "", reference_accession)
  colnames(temp_df)[4] <- "bPTR"
  temp_df %>%
    separate(X..genome, sep = "/", into = c(NA, NA, NA, NA, "file_name")) %>%
    separate(file_name, sep = "_", into = c("genus", "species", NA, NA)) %>%
    mutate(taxa = paste(genus, species),
           max_sample = sample_name,
           ref = reference_accession,
           ORI = as.numeric(gsub(",", "", ORI)),
           TER = as.numeric(gsub(",", "", TER)),
           bPTR = as.numeric(bPTR)) %>%
    select(taxa, max_sample, ref, ORI, TER, bPTR)
}

morsel <- bind_rows(morsels) %>%
  mutate(taxa = case_when(taxa == "Microbacterium Y-01" ~ "Microbacterium sp. Y-01",
                          taxa == "Microbacterium PM5" ~ "Microbacterium sp. PM5",
                          taxa == "Microbacterium PAMC" ~ "Microbacterium sp. PAMC 28756",
                          taxa == "Zhihengliuella ISTPL4" ~ "Zhihengliuella sp. ISTPL4",
                          TRUE ~ taxa))

taxa_df <- fread("results/irep_analysis/global_top_20_bacteria_max_count.csv")

parsed <- taxa_df %>%
  left_join(morsel)

taxa_df

# render functions
orange_pal <- function(x) rgb(colorRamp(c("#ffe4cc", "#ff9500"))(x), maxColorValue = 255)
green_pal <- function(x) scales::colour_ramp(c("darkolivegreen1", "darkolivegreen4"), na.color = "white")(x)
    
status_badge <- function(color = "#aaa", width = "12px", height = width) {
  span(style = list(
    display = "inline-block",
    marginRight = "8px",
    width = width,
    height = height,
    backgroundColor = color,
    borderRadius = "50%"
  ))
}

parsed <- parsed %>%
  mutate(overall_prevalence = overall_prevalence * 100) %>%
  mutate_if(is.numeric, round, digits = 1) %>%
  mutate(status = ifelse(is.na(bPTR), "Unknown", "Replicating")) %>%
  select(-ref, -ORI, -TER, -max_sample)

rtable <- parsed %>%
  reactable(compact = T,
            borderless = T,
            pagination = F,
            width = 1500,
            columns = list(overall_prevalence = colDef(name = "Overall prevalence (%)",
                                                       style = function(value) {
                                                          normalized <- (value - min(parsed$overall_prevalence)) / (max(parsed$overall_prevalence) - min(parsed$overall_prevalence))
                                                          color <- orange_pal(normalized)
                                                          list(background = color)
                                                       }),
                           bPTR = colDef(name = "PTR",
                                                       style = function(value) {
                                                         normalised <- (value - min(parsed$bPTR, na.rm = T)) / (max(parsed$bPTR, na.rm = T) - min(parsed$bPTR, na.rm = T))
                                                         color <- green_pal(normalised)
                                                         list(background = color)
                                                       }),
                           status = colDef(name = "Status",
                                           cell = function(value) {
                             color <- switch(
                               value,
                               Replicating = "hsl(120, 45%, 50%)",
                               Unknown = "hsl(3, 69%, 50%)"
                             )
                             badge <- status_badge(color = color)
                             tagList(badge, value)
                           }),
                           max_count = colDef(name = "Max. read count"),
                           n_samples = colDef(name = "No. of samples"),
                           taxa = colDef(name = "Species"),
                           rel_a = colDef(name = "Rel. abundance")
            )
  )

html <- "results/irep_analysis/parsed_irep_results.html"
saveWidget(rtable, html)
webshot(html, 
        "results/irep_analysis/parsed_irep_results.png", 
        vwidth = 1500, vheight = 1000, zoom = 5)

# fwrite(parsed, "results/irep_analysis/parsed_irep_results.csv")
