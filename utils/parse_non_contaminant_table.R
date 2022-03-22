setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(foreach)
require(reactable)
require(htmltools)
require(htmlwidgets)
require(webshot2)

df <- fread("results/decontamination/curated_n125_global_decontamination_stats.csv")

bact <- df %>% 
  filter(pathogen_type == "bacteria") %>%
  arrange(desc(overall_prevalence)) %>%
  head(20)

virus <- df %>% 
  filter(pathogen_type == "virus")

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
