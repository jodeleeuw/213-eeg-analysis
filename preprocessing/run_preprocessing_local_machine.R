library(readr)
library(stringr)
source("preprocessing/preprocessing-eeg-functions.R")

subjects <- list.files(paste0('data/raw/beh/'), pattern="csv") %>% 
  str_remove(".csv")

for(subject in subjects){
  
  final.path <- paste0("data/preprocessed/subject-", subject,"-epochs.csv")
  print(paste0("Working on ",subject))
  if(file.exists(final.path)){
    print(paste0("epochs.csv already exists - skipping"))
    next
  }
  tryCatch({
    eeg.file <- paste0('data/raw/eeg/', subject, '.bdf')
    beh.file <- paste0('data/raw/beh/', subject, '.csv')
    
    preprocessed.data <- preprocess_eeg(
      eeg.file = eeg.file, 
      beh.file = beh.file,
      subject_id = subject,
      sampling_rate = 500,
      filter_low = 0.1,
      filter_high = 30,
      notch_filter_low = 59,
      notch_filter_high = 61,
      segment_begin = -400,
      segment_end = 1200,
      segment_offset = 0,
      bad_segment_range = 500,
      eye_threshold = 70,
      which_electrodes = c("Fp1", "Fp2", "C3", "Cz", "C4", "P3", "Pz", "P4")
    )
    
    write_csv(preprocessed.data, file=paste0("data/preprocessed/subject-", subject,"-epochs.csv"))
  },
  error = function(cond){
    message(cond)
  },
  warning = function(cond){
    message(cond)
  })
}
