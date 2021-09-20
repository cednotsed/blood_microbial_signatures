rm(list=ls())
setwd("../Desktop/git_repos/blood_microbiome/")
require(tidyverse)
require(data.table)
require(ggplot2)

blastout <- fread("results/diamond_kraken2_unclassified_reads/subset_10_unclassified.tsv")
blast_cols <- c("qseqid","sseqid","pident","length","mismatch",
                "gapopen", "qstart", "qend", "sstart", "send",
                "evalue", "bitscore")

colnames(blastout) <- blast_cols

blastout %>% 
  filter(length > 40, pident > 90) %>%
  distinct(qseqid)
  
unique(blastout$qseqid)

