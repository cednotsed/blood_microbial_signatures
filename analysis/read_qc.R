setwd("../Desktop/year_3/BIOC0023/BIOC0023_dissertation/")
require(tidyverse)
require(ggplot2)
require(data.table)
require(fastqcr)

dirs <- list.dirs("results/read_qc", recursive = F)

num_steps <- 2
proc_step_names <- c("Before", "After") # Set the step number according to order of dirs
final_df <- tibble()

for (i in seq(num_steps)) {
  dir <- dirs[i]
  qc <- qc_aggregate(dir)
  qc <- qc %>% 
    filter(module == "Basic Statistics") %>%
    mutate(tot.seq = as.numeric(tot.seq) / 1000,
           proc_step = proc_step_names[i])
  
  final_df <- final_df %>%
      bind_rows(qc)
}

# Only for paired-end (we drop all R2)
final_df <- final_df %>% 
  filter(!grepl("_R2_", sample))

# Normalise sample names
final_df <- final_df %>%
  separate(sample, into = c("sample1", "sample2", NA)) %>%
  mutate(sample = paste0(sample1, "_", sample2))

# Order barplot
filt_df <- final_df %>% distinct(sample, .keep_all = T)
final_df$sample <- factor(final_df$sample, 
                          levels = filt_df$sample[order(filt_df$tot.seq)])


# Calculate statistics
# Read count
R1 <- fread("data/read.counts.R1.txt")# R1
R2 <- fread("data/read.counts.R2.txt") # R2
processed <- fread("data/read.counts.parsed.txt") # Processed
meta <- fread("data/metadata.parsed.tsv")

count_df <- processed %>%
  separate(V1, into = c("sample1", "sample2", NA), sep = "_", remove = F) %>%
  mutate(sample = paste0(sample1, "_", sample2)) %>%
  rename(reads = V2) %>%
  inner_join(meta, "sample")

count_df %>%
  group_by(y) %>%
  summarise(mean = mean(reads))

# Test multiple times
control <- count_df %>% filter(y == "Control")
blood <- count_df %>% filter(y == "Blood")

pvals <- c() 
for (i in seq(100)) {
  t <- t.test(control$reads, sample(blood$reads, 5))
  pvals <- c(pvals, t$p.value)
}

hist(pvals)
# Median read counts
processed %>% summarise(median = median(V1))

# Plot
final_df %>%
  ggplot(aes(x = sample, y = tot.seq, fill = proc_step)) +
  geom_bar(stat = "identity", 
           position = "identity", 
           alpha = 0.5) +
  labs(x = "Sample name", 
       y = expression(paste("Read count (x", 10^3, ")")), 
       fill = "Processing") +
  geom_hline(yintercept = 10, color = "black", linetype = "dashed") +
  theme(axis.text.y = element_text(size = 6)) +
  coord_flip()
  
ggsave("results/read_counts.svg", dpi = 300)

