source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]
outfile3 <- args[4]

# Loading
load(infile)

# Parameter
r <- 3
loocv_position <- 5

# Reshape
X <- lapply(seq(dim(LRTensor)[1]), function(x){LRTensor[x,,]})
X <- do.call("rbind", lapply(X, as.vector))
X_train <- X[setdiff(seq(dim(LRTensor)[1]), loocv_position), ]
X_test <- X[loocv_position, ]
y_train <- y[setdiff(seq(dim(LRTensor)[1]), loocv_position)]

# Perform LDA
res <- LDA(X_train, y_train, l=r, sigma1=1E-1, sigma2=1E-1, verbose=TRUE)

# Train Scores
score_train <- res$B
# Test Score
score_test <- as.vector(X_test %*% res$W)

# Save
save(res, file=outfile1)
write.csv(score_train, file=outfile2)
write.csv(score_test, file=outfile3)
