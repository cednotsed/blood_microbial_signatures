setwd("../Desktop/git_repos/blood_microbiome/")
require(Maaslin2)
require(tidyverse)
require(data.table)


X <- fread("results/decontamination/PA_matrix_n125.global_decontaminated.zeroed.csv")

meta <- fread("data/20210125_v3_release/20210203_all_traits_v3.txt")

n <- gsub("[^0-9A-Za-z///' ]", " ", colnames(meta))
n <- tolower(n)
n <- gsub(" ", "_", n)
colnames(meta) <- n

# Filter data
X_meta <- X %>%
  left_join(meta)

X_meta

# Association testing
X_meta %>%
  group_by(genetic_ancestry) %>%
  summarise(sum = sum(`Cutibacterium acnes`) / n())

X_meta

taxon_list <- ""
chisq.test(as.factor(X_meta$`Cutibacterium acnes`), as.factor(X_meta$diab_med),
           simulate.p.value = T)

table(X_meta$diab_med)
glm(geneti)
fit_data = Maaslin2(
  input_data = X_filt, 
  input_metadata = meta_filt, 
  output = "results/demo_output", 
  fixed_effects = c("genetic_ancestry", "age", "bmi", "sbp", "t2d"),
  reference = c("genetic_ancestry,C"),
  )


input_data = system.file("extdata", "HMP2_taxonomy.tsv", package="Maaslin2") # The abundance table file
input_data

input_metadata = system.file("extdata", "HMP2_metadata.tsv", package="Maaslin2") # The metadata table file
input_metadata


df_input_data = read.table(file = input_data, header = TRUE, sep = "\t", row.names = 1, stringsAsFactors = FALSE)
df_input_data[1:5, 1:5]

df_input_metadata = read.table(file = input_metadata, header = TRUE, sep = "\t", row.names = 1, stringsAsFactors = FALSE)
df_input_metadata[1:5, ]


fit_data = Maaslin2(
  input_data = input_data, 
  input_metadata = input_metadata, 
  output = "demo_output", 
  fixed_effects = c("diagnosis", "dysbiosis"),
  reference = c("diagnosis,nonIBD"))
