library(osfr)
library(dplyr)

osf_retrieve_node("sdnhw") %>%
  osf_ls_files(path="Cogs 213 22a and after behavioral data", n_max=Inf) %>%
  osf_download(path="data/raw/beh", conflicts="skip")

osf_retrieve_node("sdnhw") %>%
  osf_ls_files(path="Cogs 213 22a and after EEG data", n_max=Inf) %>%
  osf_download(path="data/raw/eeg", conflicts="skip")
