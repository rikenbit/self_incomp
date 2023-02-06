source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Loading
load(infile1)
load(infile2)

# Prediction
tmp <- einsum('ijk,lk->ijl', LRTensor, res@common_factors$A3)
X <- rs_unfold(as.tensor(tmp), m=1)@data

# Save
write.csv(X, file=outfile)
