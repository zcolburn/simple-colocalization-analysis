# 2018 Colocalization Analysis

params <- tibble::lst(
  "ch1_indicator" = "488",
  "ch2_indicator" = "560",

  "ch_to_threshold" = 1,

  "fijiDirectoryPath" = (
    "C:/Users/Zachary Colburn/fiji-win64/Fiji.app/ImageJ-win64.exe"
  )
)

saveRDS(params, file = file.path("Memory", "parameters.rds"))
