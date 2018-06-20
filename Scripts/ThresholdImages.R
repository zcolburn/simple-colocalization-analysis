# Threshold the channel of interest.

# Load the pipe operator.
library(magrittr)

# Load imageGroupList
imageGroupList <- readRDS(file.path("Memory", "imageGroupList.rds"))

output <- parallel::parLapply(
  # Create cluster
  parallel::makeCluster(
    parallel::detectCores()
  ),

  # Provide input data
  imageGroupList,

  # Task to perform
  function(group) {
    # Load the pipe operator.
    library(magrittr)

    # Load the parameters.
    params <- readRDS(file.path("Memory", "parameters.rds"))

    # Identify tif files to threshold.
    indicator <- params$ch1_indicator
    if(params$ch_to_threshold == 2){
      indicator <- params$ch2_indicator
    }
    
    input_path <- file.path(
      getwd(), 
      group$filename[grepl(indicator, group$filename)]
    )
    
    # Define output path.
    output_path <- file.path(
      gsub("/[^/]*$", "", input_path),
      "thresh.tif"
    )
    
    # Return a tibble row.
    return(data.frame(
      "inputPaths" = input_path,
      "outputPaths" = output_path
    ))


  }
) %>%
  dplyr::bind_rows()

# Perform thresholding.
script <- "ThresholdImages"
inputParameters <- output %>%
  as.matrix() %>%
  t() %>%
  apply(., 2, function(item){paste(item, collapse = "#")}) %>%
  (function(item){paste(item, collapse = "%")})

source(file.path("Scripts", "FijiRunner.R"))
fijiRunner(script, inputParameters)
