# Map data files.

# Load the pipe operator.
library(magrittr)

# Find data files.
filesList <- list.files(recursive = TRUE) %>%
  .[grepl("^Data/", .)]

# Subset relevant data files.
files <- filesList[!grepl(".nd", filesList) & !grepl("_thumb_", filesList)] %>%
  strsplit(., "/") %>%
  lapply(
    .,
    function(item){
      fname <- file.path(item[1],item[2],item[3],item[4])
      experiment <- item[2]
      fileGroup <- file.path(item[2],item[3])
      
      tibble::data_frame(
        filename = fname,
        experiment = experiment,
        fileGroup = fileGroup
      )
    }
  ) %>%
  dplyr::bind_rows()

imageGroupList <- split(files, f = factor(files$fileGroup))
saveRDS(imageGroupList, file = file.path("Memory","imageGroupList.rds"))
