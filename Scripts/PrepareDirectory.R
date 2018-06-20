rm(list = ls())

folderNames <- c("Memory","Statistics")

for(folderName in folderNames) {
  if (dir.exists(folderName)) unlink(folderName, recursive = TRUE)
  dir.create(folderName, showWarnings = FALSE)
}


