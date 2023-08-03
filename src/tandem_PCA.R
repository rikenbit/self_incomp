# source("src/functions_tandem_PCA.R")

source("src/functions_shuffled_PCA.R")

#### args setting####
# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]
# Parameter
r <- as.numeric(args[4]) #r2
#### test args####
# r <- as.numeric(c("10"))
# infile <- c("output/inputTensors.RData")
############

##### Loading#####
load(infile)

##### Reshape#####
X_unfold <- rs_unfold(as.tensor(LRTensor), m=1)@data

#### tandem####
order_list <- c(rbind(1:90, 91:180))
X_ordered <- X_unfold[order_list, ]

##### Matrix Decomposition#####
res <- prcomp(X_ordered, rank=r)
##### Reshape#####
X <- res$x

##### Save#####
save(res, file=outfile1)
write.csv(X, file=outfile2, row.names = FALSE)