source("src/functions_SSI_toy_Accuracy.R")

#### args setting####
args <- commandArgs(trailingOnly = TRUE)
outfile <- args[1]
#### test args####

# One-Hot Vectorize (LR Pairs × Sites × AAs)
LigandTensor <- array(0, dim=c(90+90, 99, 21))
ReceptorTensor <- array(0, dim=c(90+90, 108, 21))

# Assign 1
## Random AAs
rindex1 <- expand.grid(1:180, 1:99)
rindex1 <- as.matrix(cbind(rindex1,
    sample(1:21, nrow(rindex1), replace=TRUE)))
LigandTensor[rindex1] <- 1

rindex2 <- expand.grid(1:180, 1:108)
rindex2 <- as.matrix(cbind(rindex2,
    sample(1:21, nrow(rindex2), replace=TRUE)))
ReceptorTensor[rindex2] <- 1

## Common AAs
LigandTensor[1:90, 1:20, ] <- 0
LigandTensor[1:90, 1:20, 1] <- 1
ReceptorTensor[1:90, 100:108, ]  <- 0
ReceptorTensor[1:90, 100:108, 21] <- 1

## Non-specific AAs
LigandTensor[1:180, 31:50, ] <- 0
LigandTensor[1:180, 31:50, 2] <- 1
ReceptorTensor[1:180, 81:90, ] <- 0
ReceptorTensor[1:180, 81:90, 20] <- 1

# Merge into LRTensor
LRTensor <- array(0, dim=c(90+90, 99+108, 21))
LRTensor[1:180, 1:99, 1:21] <- LigandTensor
LRTensor[1:180, (99+1):(99+108), 1:21] <- ReceptorTensor

# Check（あるアミノ酸配列iのあるサイトjには必ずアミノ酸残基kが1つだけある）
for(i in 1:180){
    stopifnot(all(apply(LigandTensor[i,,], 1, sum) == 1))
    stopifnot(all(apply(ReceptorTensor[i,,], 1, sum) == 1))
    stopifnot(all(apply(LRTensor[i,,], 1, sum) == 1))
}

# # Plot
# layout(rbind(1:3))
# plotTensor3D(as.tensor(LigandTensor), thr=0)
# plotTensor3D(as.tensor(ReceptorTensor), thr=0)
# plotTensor3D(as.tensor(LRTensor), thr=0)

# PCA
X <- rs_unfold(as.tensor(LRTensor), m=1)@data
res.pca <- prcomp(X, center=TRUE, scale=FALSE)
# plot(res.pca$x[,1:2], pch=16, col=c(rep(1, 90), rep(2, 90)))

# Save
# save(LRTensor, LigandTensor, ReceptorTensor, file="toydata.RData")
save(LRTensor, LigandTensor, ReceptorTensor, file=outfile)