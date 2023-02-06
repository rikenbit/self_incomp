source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Loading
load(infile1)
load(infile2)

# Reshape, Prediction
tmp <- einsum('ijk,lj->ilk',  LRTensor, res@common_factors$A2)
tmp <- einsum('ilk,mk->ilm', tmp, res@common_factors$A3)
X <- rs_unfold(as.tensor(tmp), m=1)@data

# Save
# write.csv(X, file=outfile)
write.csv(X, file=outfile, row.names = FALSE)
