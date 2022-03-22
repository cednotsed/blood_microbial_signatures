require("Rsamtools")
require(Biostrings)
require(tidyverse)
ref <- readDNAStringSet("data/irep_data/genome_references/Bacillus_cereus_NZ_CM000714.1.fasta")
ref_length <- width(ref)
params <- PileupParam(distinguish_strands = F, distinguish_nucleotides = F)
pile_df <- pileup("results/irep_analysis/test.bam", pileupParam = params)
n_covered <- pile_df %>%
  filter(count > 5) %>%
  nrow()

perc_covered <- n_covered / ref_length * 100

