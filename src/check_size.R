# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Loading
X1_train <- read.csv(infile1)
X1_test <- read.csv(infile2)

if(identical(ncol(X1_train), ncol(X1_test))){
	file.create(outfile)
}