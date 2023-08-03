source("src/functions_shuffled_col_site_r_PCA.R")

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
# ブロックごとの列インデックスを計算
block_indices <- split(1:N_unfold, rep(1:(N_unfold/N_site), each = N_site, length.out = N_unfold))
# 各行ごとにブロック内でシャッフルを適用し、シャッフル後の行列を作成
X_shuffle <- t(apply(X_unfold, 1, function(row) {
  shuffled_row <- c()
  for (block_idx in block_indices) {
    shuffled_row <- c(shuffled_row, shuffle_block(row[block_idx]))
  }
  return(shuffled_row)
}))

##### Matrix Decomposition#####
res <- prcomp(X_shuffle, rank=r)
##### Reshape#####
X <- res$x

##### Save#####
save(res, file=outfile1)
write.csv(X, file=outfile2, row.names = FALSE)
