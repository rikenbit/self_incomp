source("src/functions_shuffled_col_site_PCA.R")

#### args setting####
# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]
# Parameter
r <- as.numeric(args[4]) #r2
#### test args####
# r <- as.numeric(c("10"))
# infile <- c("output/inputTensors.RData")
############

##### Loading#####
load(infile)

##### Reshape#####
X_unfold <- rs_unfold(as.tensor(LRTensor), m=1)@data

#### shuffle####
# 列の長さN_unfoldとブロックサイズN_siteを設定
N_unfold <- ncol(X_unfold)
# 任意のブロックサイズ
N_site <- 207

shuffled_blocks <- lapply(1:(N_unfold/N_site), function(i) {
  block <- X_unfold[, (N_site*(i-1)+1):(N_site*i)]
  shuffled_indices <- sample(ncol(block))
  block[, shuffled_indices]
})
# シャッフルされたブロックを結合
X_shuffle <- do.call(cbind, shuffled_blocks)

##### Matrix Decomposition#####
res <- prcomp(X_shuffle, rank=r)
##### Reshape#####
X <- res$x

##### Save#####
save(res, file=outfile1)
write.csv(X, file=outfile2, row.names = FALSE)
