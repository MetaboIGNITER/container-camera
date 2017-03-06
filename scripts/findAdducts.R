#!/usr/bin/env Rscript
options(stringAsfactors = FALSE, useFancyQuotes = FALSE)

# Taking the command line arguments
args <- commandArgs(trailingOnly = TRUE)

if(length(args)==0)stop("No file has been specified! Please select a file for performing RT correction!\n")
require(xcms)
require(CAMERA)
previousEnv<-NA
output<-NA
ppm<-10
polarity<-"positive"
for(arg in args)
{
  argCase<-strsplit(x = arg,split = "=")[[1]][1]
  value<-strsplit(x = arg,split = "=")[[1]][2]
  if(argCase=="input")
  {
    previousEnv=as.character(value)
  }
  if(argCase=="ppm")
  {
    ppm=as.numeric(value)
  }
  if(argCase=="polarity")
  {
    polarity=as.character(value)
  }
  if(argCase=="output")
  {
    output=as.character(value)
  }
  
}
if(is.na(previousEnv) | is.na(output)) stop("Both input and output need to be specified!\n")

load(file = previousEnv)

toIsoCharac<-get(varNameForNextStep)

xcmsSetAdduCharac<-findAdducts(toIsoCharac,polarity = polarity,ppm = ppm)

preprocessingSteps<-c(preprocessingSteps,"findAdducts")

varNameForNextStep<-as.character("xcmsSetAdduCharac")

save(list = c("xcmsSetAdduCharac","preprocessingSteps","varNameForNextStep"),file = output)

