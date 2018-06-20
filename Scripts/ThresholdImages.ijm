inputFilename = getArgument();
input = File.openAsString(inputFilename);
filesList = split(input, "%");
for(i = 0; i < filesList.length; i++){
  splitFileData = split(filesList[i], "#");
  inputFile = splitFileData[0];
  outputFile = splitFileData[1];
  open(inputFile);

  // Your macro goes here.
  run("Despeckle");
  run("Subtract Background...", "rolling=10");
  run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 24 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] normalize");
  setAutoThreshold("Default dark");
  setOption("BlackBackground", true);
  run("Convert to Mask");
  // Your macro ends here.

  saveAs("Tiff", outputFile);
  close();
  print(inputFile);
  print(i / filesList.length * 100 + "% complete!");
}
print("All done!");
