# Determine colocalization levels.

# Load pipe operator.
library(magrittr)

# Load imageGroupList.
imageGroupList <- readRDS(file.path("Memory","imageGroupList.rds"))

# Iterate through each image group.
dat <- parallel::parLapply(
  # Make cluster.
  parallel::makeCluster(
    parallel::detectCores()
  ),
  
  # Select data.
  imageGroupList,
  
  # Processing function.
  function(files){
    # Load parameters.
    params <- readRDS(file.path("Memory", "parameters.rds"))
    
    # Load images.
    ## Load ch1 image.
    ch1_path <- files$filename[grepl(params$ch1_indicator, files$filename)]
    ch1_img <- ijtiff::read_tif(ch1_path)[,,1,1]
    
    ## Load ch2 image.
    ch2_path <- files$filename[grepl(params$ch2_indicator, files$filename)]
    ch2_img <- ijtiff::read_tif(ch2_path)[,,1,1]
    
    ## Load thresh image.
    thresh_path <- file.path(
      gsub("/[^/]*$", "", ch1_path),
      "thresh.tif"
    )
    thresh_img <- ijtiff::read_tif(thresh_path)[,,1,1] > 0
    
    # Visual check.
    # plot(
    #   as.vector(ch1_img[thresh_img]), 
    #   as.vector(ch2_img[thresh_img]), 
    #   pch = 19
    # )
    
    # Determine correlation.
    cor(
      as.vector(ch1_img[thresh_img]), as.vector(ch2_img[thresh_img]),
      method = "spearman"
    )
  }
) %>%
  unlist()

# Perform statistics.
wilcox.test(dat, alternative = "greater")



# Graph results.
library(ggplot2)

# Set the random seed for the jitter layer.
set.seed(8)

tibble::data_frame(
  imageGroup = names(dat),
  correlations = dat,
  group = factor(1)
) %>%
ggplot(
  .,
  aes(group, correlations)
)+
  geom_boxplot(colour = "black", outlier.alpha = 0)+
  geom_jitter(colour = "blue")+
  geom_hline(yintercept = 0, linetype = "dashed", colour = "red", size = 1.5)+
  theme_bw()+
  theme(
    axis.title = element_text(size = 14),
    axis.text.y = element_text(size = 12, colour = "black"),
    axis.text.x = element_blank()
  )+
  coord_cartesian(ylim = c(-1, 1, expand = FALSE))+
  xlab("")+
  ylab("Spearman correlation")
  
ggsave(
  filename = file.path("Statistics", "Correlations.tiff"),
  units = "in",
  width = 2, height = 3
)
