library(readr)
library(dplyr)

# Read in all CSVs in the data/preprocessed directory

files <- list.files(paste0("data/preprocessed"), pattern = "*.csv", full.names = TRUE)
data <- lapply(files, function(x){
  read_csv(x, col_types = "cdcclcddlc") %>% 
    dplyr::filter(electrode %in% c("Cz", "C3", "C4", "Pz", "P3", "P4")) %>%
    select(-v_range, -good_segment)
}) %>% 
  bind_rows()

write_csv(data, paste0("data/final/eeg.csv"))
