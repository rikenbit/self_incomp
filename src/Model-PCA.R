source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Loading
load(infile)

# Parameter
r <- as.numeric(args[6]) #r3

# Reshape
data <- rs_unfold(as.tensor(LRTensor), m=1)@data

# Matrix Decomposition
res <- prcomp(data, rank=r)

# Reshape
X <- res$x

# Save
save(res, file=outfile1)
write.csv(X, file=outfile2)
