source("src/Functions.R")

#### args setting####
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
infile_2 <- args[2]
outfile <- args[3]
outfile_2 <- args[4]
#### test args####
# infile <- c("data/train_Tensors.RData")
# outfile <- c("output/MT_py_X/matrix/X_180_LR.csv")

#### Loading####
# LRTensor, LigandTensor ,ReceptorTensor,y
load(infile)
#### Reshape#### 
data <- rs_unfold(as.tensor(LRTensor), m=1)@data
#### save#### 
write.csv(data, file=outfile, row.names = FALSE)

#### Loading####
# LRTensor, LigandTensor ,ReceptorTensor,y
load(infile_2)
#### Reshape#### 
data <- rs_unfold(as.tensor(LRTensor), m=1)@data
#### save#### 
write.csv(data, file=outfile_2, row.names = FALSE)