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
r1 <- 3
r2 <- 4
loocv_position <- 5

# Reshape
X <- lapply(seq(dim(LRTensor)[1]), function(x){LRTensor[x,,]})
X_train <- X[setdiff(seq(dim(LRTensor)[1]), loocv_position)]
X_test <- X[[loocv_position]]
y_train <- y[setdiff(seq(dim(LRTensor)[1]), loocv_position)]

# Perform 2DLDA
res <- TwoDLDA(X_train, y_train, l1=r1, l2=r2, sigma1=1E-1, sigma2=1E-1, verbose=TRUE)
# Train Scores
score_train <- do.call("rbind", lapply(res$Bs, as.vector))
# Test Score
score_test <- as.vector(t(res$L) %*% X_test %*% res$R)

# Save
save(res, file=outfile1)
write.csv(score_train, file=outfile2)
write.csv(score_test, file=outfile3)
