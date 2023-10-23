source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[11]
outfile1 <- args[12]
outfile2 <- args[13]
outfile3 <- args[14]
pullout_row <- as.numeric(args[10]) #row

# Loading
# LRTensor, LigandTensor ,ReceptorTensor
load(infile)
LRTensor <- LRTensor[-pullout_row,,]
LigandTensor <- LigandTensor[-pullout_row,,]
ReceptorTensor <- ReceptorTensor[-pullout_row,,]

# Parameter
r <- as.numeric(args[2]) #r2

# Reshape
data <- rs_unfold(as.tensor(LRTensor), m=1)@data

# Matrix Decomposition
res <- prcomp(data, rank=r)

# Reshape
X <- res$x

# Save
save(res, data, file=outfile1)
write.csv(X, file=outfile2, row.names = FALSE)

# Save for 射影
load(infile)
LRTensor <- array(LRTensor[pullout_row,,],
                  c(1, dim(LRTensor[pullout_row,,]))
)
LigandTensor <- array(LigandTensor[pullout_row,,],
                      c(1, dim(LigandTensor[pullout_row,,]))
)
ReceptorTensor <- array(ReceptorTensor[pullout_row,,],
                        c(1, dim(ReceptorTensor[pullout_row,,]))
)
save(LRTensor, LigandTensor, ReceptorTensor, file=outfile3)