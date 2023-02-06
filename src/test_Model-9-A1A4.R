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
tmp1 <- einsum('ijk,jl->ilk', res@common_cores[[1]]@data, res@common_factors$A2)
tmp1 <- einsum('ilk,km->ilm', tmp1, res@common_factors$A3)
tmp1 <- einsum('ijk,ljk->il', LigandTensor, tmp1)

tmp2 <- einsum('ijk,jl->ilk', res@common_cores[[2]]@data, res@common_factors$A5)
tmp2 <- einsum('ilk,km->ilm', tmp2, res@common_factors$A3)
tmp2 <- einsum('ijk,ljk->il', ReceptorTensor, tmp2)

X <- cbind(tmp1, tmp2)

# Save
# write.csv(X, file=outfile)
write.csv(X, file=outfile, row.names = FALSE)
