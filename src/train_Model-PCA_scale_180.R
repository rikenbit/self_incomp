source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
npdim <- args[2]
outfile1 <- args[3]
outfile2 <- args[4]

# Loading
# LRTensor, LigandTensor ,ReceptorTensor
load(infile)

# Parameter
r <- as.numeric(npdim)

# Reshape
data <- rs_unfold(as.tensor(LRTensor), m=1)@data

# Matrix Decomposition
res <- prcomp(data, rank=r)

# Reshape
X <- res$x

# Save
save(res, data, file=outfile1)
write.csv(X, file=outfile2, row.names = FALSE)
