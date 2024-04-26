library(jsonlite)
library(dplyr)
library(readr)
library(tidyr)

behavior.files <- list.files(paste0('data/raw/beh'), pattern="csv", full.names = T)

merged.data <- lapply(behavior.files, read_csv) %>% bind_rows()

write_csv(merged.data, file=paste0("data/final/behavioral.csv"))
