setwd("../Desktop/git_repos/blood_microbiome/")
require(webshot2)

html <- "results/irep_analysis/parsed_irep_results.html"
webshot(html, 
        "results/irep_analysis/parsed_irep_results.png", 
        vwidth = 1200, vheight = 90, zoom = 5)

html <- "results/blood_culture_records/blood_culture_voronoi.html"
webshot(html, 
        "results/blood_culture_records/blood_culture_voronoi.png", 
        vwidth = 900, vheight = 100, zoom = 5)
