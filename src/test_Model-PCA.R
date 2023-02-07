source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Loading
load(infile1)
load(infile2)

# Reshape
data <- rs_unfold(as.tensor(LRTensor), m=1)@data

# Scaling
scale.data <- scale(data, center=TRUE, scale=FALSE)

# Prediction
X <- scale.data %*% res$rotation

# Save
# write.csv(X, file=outfile)
write.csv(X, file=outfile, row.names = FALSE)
