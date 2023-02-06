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
tmp1 <- einsum('ijk,lj->ilk', LigandTensor, res@common_factors$A2)
tmp1 <- einsum('ilk,mk->ilm', tmp1, res@common_factors$A3)
tmp1 <- rs_unfold(as.tensor(tmp1), m=1)

tmp2 <- einsum('ijk,lj->ilk', ReceptorTensor, res@common_factors$A5)
tmp2 <- einsum('ilk,mk->ilm', tmp2, res@common_factors$A3)
tmp2 <- rs_unfold(as.tensor(tmp2), m=1)

X <- cbind(tmp1@data, tmp2@data)

# Save
# write.csv(X, file=outfile)
write.csv(X, file=outfile, row.names = FALSE)
