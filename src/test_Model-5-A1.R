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
X <- einsum('ijk,ljk->il', LRTensor, res@common_cores[[1]]@data)

# Save
# write.csv(X, file=outfile)
write.csv(X, file=outfile, row.names = FALSE)
