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
tmp <- einsum('ijk,jl->ilk', res@common_cores[[1]]@data, res@common_factors$A2)
tmp <- einsum('ilk,km->ilm', tmp, res@common_factors$A3)
X <- einsum('ijk,ljk->il', LRTensor, tmp)

# Save
# write.csv(X, file=outfile)
write.csv(X, file=outfile, row.names = FALSE)