# Simple dual channel fluorescent microscopy colocalization analysis

## Dependencies
This script depends on the packages magrittr, parallel, ijtiff, ggplot2, tibble, and dplyr. It also depends on Fiji/ImageJ.


The analysis was made for:
* Windows 10, 64-bit.
* R 3.5.0, RStudio 1.1.383
* ImageJ 1.52a, Java 1.8.0_66 (64-bit)


## Set up and analysis
Data in should be stored in the *Data* folder and divided into folders by experiment. Within each experiment folder should be a folder for each field of view. Each of these folders should contain the images to be processed.


To analyze these data, set the values in the file *Parameters.R* accordingly. Set **ch1_indicator** and **ch2_indicator** to unique identifiers in the image names that specify which channel the images belong to. **ch_to_threshold** should be set to 1 or 2. It specifies the number of the channel identified by the indicators above that should be used to generate masks for generating ROIs within which colocalization should be analyzed. Finally, **fijiDirectoryPath** should be the full path to the Fiji/ImageJ executable file.


After setting the above parameters, a good background subtraction method should be developed in Fiji/ImageJ and a macro created to threshold a single image. ROIs in the processed image should have a non-zero intensity value. All other pixels should have an intensity value of zero. The macro should be pasted into the file *Scripts/ThresholdImages.ijm* in the middle section denoted by the comments.


Finally, the file *Main.R* can be run. It performs statistical analysis to determine whether the Spearman correlation between the two channels in the ROIs specified is greater than zero. It also generates a graph which it places in the folder *Statistics*, which is generated by the *ProcessData.R* script.
