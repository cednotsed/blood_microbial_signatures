setwd("../Desktop/git_repos/blood_microbiome/")
require(webshot2)

html <- "results/irep_analysis/parsed_irep_results.html"
webshot(html, 
        "results/irep_analysis/parsed_irep_results.png", 
        vwidth = 1150, vheight = 90, zoom = 5)
