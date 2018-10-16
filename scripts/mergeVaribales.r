#!/usr/bin/env Rscript

# Check if the limma and argparse are available, if not then install them
list.of.packages <- c("argparse")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# load argparse for parsing arguments
suppressWarnings(library("argparse"))

# set require arguments
parser <- ArgumentParser()

# set require arguments.
parser$add_argument("-v", "--verbose", action="store_true", default=TRUE,
                    help="Print extra output [default]")

parser$add_argument("-q", "--quietly", action="store_false", 
                    dest="verbose", help="Print little output")

parser$add_argument("-in", "--dataMatrix_in", type="character",
                    help="Input multiple data matrix containing peaks. They have to be separated by space or , or \\| or tab or |. The order MUST be identical to sampleVariable_in")

parser$add_argument("-out", "--dataMatrix_out", type="character",
                    help="Output data matrix containing peaks")

parser$add_argument("-outp", "--sampleVariable_out", type="character",
                    help="Output data matrix containing variables")

parser$add_argument("-s", "--sampleMetadata_in", type="character", 
                    help="Input data matrix containing sample metadata. Since variables are concatenated, this has to be identical for all files in dataMatrix_in")


parser$add_argument("-p", "--sampleVariable_in", type="character", 
                    help="Input multiple data matrix containing variable information. They have to be separated by space or , or \\| or tab or |. The order MUST be identical to dataMatrix_in")



# parse arguments
args <- parser$parse_args()

if(is.null(args$sampleVariable_out))
{
  errorMessage<-"No output file has been specified for sampleVariable_out You MUST specify the output file see the help (-h)!"
  write(errorMessage,stderr())
  stop(errorMessage,
       call. = FALSE)
}

if(is.null(args$dataMatrix_out))
{
  errorMessage<-"No output file has been specified for dataMatrix_out You MUST specify the output file see the help (-h)!"
  write(errorMessage,stderr())
  stop(errorMessage,
       call. = FALSE)
}

if(is.null(args$dataMatrix_in))
{
  errorMessage<-"No input file has been specified for dataMatrix_in. You MUST specify the input file see the help (-h)!"
  write(errorMessage,stderr())
  stop(errorMessage,
       call. = FALSE)
}

if(is.null(args$sampleVariable_in))
{
  errorMessage<-"No input file has been specified for sampleVariable_in. You MUST specify the input file see the help (-h)!"
  write(errorMessage,stderr())
  stop(errorMessage,
       call. = FALSE)
}

if(is.null(args$sampleMetadata_in))
{
  errorMessage<-"No input file has been specified for sampleMetadata_in. You MUST specify the input file see the help (-h)!"
  write(errorMessage,stderr())
  stop(errorMessage,
       call. = FALSE)
}


if ( args$verbose ) { 
  write("Loading data matrix and performing checks...\n", stdout()) 
}



# split data matrix files
dataMatrixFiles<- sapply(strsplit(x = args$dataMatrix_in,split = "\\;|,| |\\||\\t"),function(x){x})

# split data variable files
dataVariableFiles<- sapply(strsplit(x = args$sampleVariable_in,split = "\\;|,| |\\||\\t"),function(x){x})
# Load peak matrix

if ( args$verbose ) { 
  write("Checking if same number of files have been given for data matrix and variable ...\n", stdout())
}

if(length(dataMatrixFiles)!=length(dataVariableFiles))
{
  errorMessage<-"The number of files dataMatrix_in and sampleVariable_in are different. See the help (-h)!"
  write(errorMessage,stderr())
  stop(errorMessage,
       call. = FALSE)
  
}

xMNCombine<-c()
varDFCombine<-c()



sampleMetadata_inFile<-args$sampleMetadata_in

for(i in 1:length(dataMatrixFiles))
{
  dataMatrix_inFile<-dataMatrixFiles[i]
  sampleVariable_inFile<-dataVariableFiles[i]
  xMN <- t(as.matrix(read.table(dataMatrix_inFile,
                                check.names = FALSE,
                                header = TRUE,
                                row.names = 1,
                                sep = "\t",
                                comment.char = "")))
  
  # Load sample metaData
  samDF <- read.table(sampleMetadata_inFile,
                      check.names = FALSE,
                      header = TRUE,
                      row.names = 1,
                      sep = "\t",
                      comment.char = "")
  
  # load sample variables
  varDF <- read.table(sampleVariable_inFile,
                      check.names = FALSE,
                      header = TRUE,
                      row.names = 1,
                      sep = "\t",
                      comment.char = "")
  # generate error message if row and column names are not identical
  if(!identical(rownames(xMN), rownames(samDF)))
  {
    errorMessage<-"Sample names (or number) in the data matrix (first row) and sample metadata (first column) are not identical; use the 'Check Format' module in the 'Quality Control' section"
    errorMessage<-paste(errorMessage,"files: ", dataMatrix_inFile,", ",sampleMetadata_inFile,"\n",sep="")
    write(errorMessage,stderr())
    stop(errorMessage,
         call. = FALSE)
  }
  
  if(!identical(colnames(xMN), rownames(varDF)))
  {
    errorMessage<-"Variable names (or number) in the data matrix (first column) and sample metadata (first column) are not identical; use the 'Check Format' module in the 'Quality Control' section"
    errorMessage<-paste(errorMessage,"files: ", dataMatrix_inFile,", ",sampleMetadata_inFile,"\n",sep="")
    write(errorMessage,stderr())
    stop(errorMessage,
         call. = FALSE)
  }
  

  
  if(is.null(xMNCombine) && is.null(varDFCombine)){
    
   
    varDF$preComFile<-basename(sampleVariable_inFile)
    varDF$oldVarName<-rownames(varDF)
    rownames(varDF)<-paste("variable_",c(1:nrow(varDF)),sep="")
    varDFCombine<-varDF
    colnames(xMN)<-rownames(varDF)
    xMNCombine<-xMN
  }else{
    varDF$preComFile<-basename(sampleVariable_inFile)
    varDF$oldVarName<-rownames(varDF)
    rownames(varDF)<-paste("variable_",c((ncol(xMN)+1):(ncol(xMN)+nrow(varDF))),sep="")

    varDFCombine<-rbind(varDFCombine,varDF)
    colnames(xMN)<-rownames(varDF)
    xMNCombine<-cbind(xMNCombine,xMN)
  
  }
  
  
}


if ( args$verbose ) { 
  write("all data combined! Now checking for errors ...\n", stdout()) 
}

if(!identical(rownames(xMNCombine), rownames(samDF)))
{
  errorMessage<-"Sample names (or number) in the data matrix (first row) and sample metadata (first column) are not identical; use the 'Check Format' module in the 'Quality Control' section"
  errorMessage<-paste(errorMessage,"files: ", dataMatrix_inFile,", ",sampleMetadata_inFile,"\n",sep="")
  write(errorMessage,stderr())
  stop(errorMessage,
       call. = FALSE)
}

if(!identical(colnames(xMNCombine), rownames(varDFCombine)))
{
  errorMessage<-"Variable names (or number) in the data matrix (first column) and sample metadata (first column) are not identical; use the 'Check Format' module in the 'Quality Control' section"
  errorMessage<-paste(errorMessage,"files: ", dataMatrix_inFile,", ",sampleMetadata_inFile,"\n",sep="")
  write(errorMessage,stderr())
  stop(errorMessage,
       call. = FALSE)
}

if ( args$verbose ) { 
  write("Everything seems OK. Final formatting ...\n", stdout()) 
}
xMNCombine<-xMNCombine
peakMatrix<-cbind.data.frame(dataMatrix=rownames(xMNCombine),xMNCombine,stringsAsFactors = F)
VariableData<-cbind.data.frame(variableMetadata=rownames(varDFCombine),varDFCombine,stringsAsFactors = F)
VariableData<-sapply(VariableData, gsub, pattern="\'|#", replacement="")
if ( args$verbose ) { 
  write("Writing output ...\n", stdout()) 
}

write.table(x = VariableData,file = args$sampleVariable_out,
            row.names = F,quote = F,sep = "\t")
write.table(x = peakMatrix,file = args$dataMatrix_out,
            row.names = F,quote = F,sep = "\t")

