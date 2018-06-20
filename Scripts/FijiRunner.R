fijiRunner <- function(script, inputParameters) {
  writeLines(inputParameters, con = paste0("Memory/",script,".txt"))
  parameters <- readRDS(file.path("Memory", "parameters.rds"))
  fijiPath <- parameters$fijiDirectoryPath
  macroFile <- paste0(getwd(), "/Scripts/", script, ".ijm")
  system(paste("\"",
               fijiPath,
               "\"", " -batch ", "\"",
               macroFile,
               "\"", " \"", gsub("/", "\\\\\\\\", paste0(getwd(),"/Memory/",script,".txt")), "\"",
               sep = ""))
}
