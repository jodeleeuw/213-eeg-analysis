library(edfReader)
library(purrr)
library(dplyr)
library(readr)

eeg.file <- "data/raw/eeg/subject-02-eeg_3_21_24.bdf"
beh.file <- "data/raw/beh/02_03_21_24 - 02_03_21_24.csv"

extract_events <- function(eeg.file, beh.file){
  
  # read in EEG data
  head <- readEdfHeader(eeg.file)
  signals <- readEdfSignals(head, signals="Ordinary")
  
  eeg.data <- map_df(signals, "signal")
  eeg.data$sample_id <- 1:nrow(eeg.data)
  
  ## read in behavioral data
  
  behavioral.data <- read_csv(beh.file)
  trials <- behavioral.data %>% 
    dplyr::filter(task=="response") %>%
    mutate(event_id = 1:n())
  
  ## extract EEG events
  
  # 11 = n4 T
  # 21 = p6 T
  # 12 = n4 NT
  # 22 = p6 NT
  
  events <- eeg.data %>% 
    select(sample_id, TRIGGER) %>% 
    dplyr::filter(TRIGGER != lag(TRIGGER)) %>%
    dplyr::filter(TRIGGER %in% c(11, 12, 21, 22)) %>%
    slice_tail(n = 100) %>%
    mutate(time = sample_id/500) %>%
    mutate(event_id = 1:n())
  
  final_events <- trials %>%
    left_join(events, by="event_id") %>%
    select(event_id, sample_id, time, normal, ERP_type, correct)
  
 
  # final_events <- filtered.events %>% 
  #   left_join(trials, by="row_id") %>%
  #   mutate(event_id = 1:n()) %>%
  #   select(event_id, sample_id, time, event_type, word_type, is_word, correct)
  
  return(final_events)
}
