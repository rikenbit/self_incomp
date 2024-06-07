source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Loading
load(infile1)
load(infile2)

# ##########
# # 3階テンソルから平均行列を算出
# # mean_X1 <- einsum('ijk->jk', X) / dim(X)[1] # einsum利用の場合
# # LRTensor is before Tensor Decomposition
# X_train <- LRTensor
# mean_X1 <- einsum('ijk->jk', X_train) / dim(X_train)[1] # einsum利用の場合

# # 3階テンソルから平均行列を引く
# # X_new <- sweep(X, MARGIN=c(2,3), STATS=mean_X1)
# X_test <- one_LRTensor
# X_new <- sweep(X_test, MARGIN=c(2,3), STATS=mean_X1)
# ##########
#######
X_train <- LRTensor
X_train_unfold <- unfold(as.tensor(X_train), row_idx=1, col_idx=c(2,3))@data
X_mean <- colMeans(X_train_unfold)

X_test <- one_LRTensor
X_test_unfold <- unfold(as.tensor(X_test), row_idx=1, col_idx=c(2,3))@data
scaled_data <- X_test_unfold - X_mean
X_new <- fold(as.tensor(scaled_data), row_idx=1, col_idx=c(2,3), modes = dim(one_LRTensor))@data
#######

# Reshape, Prediction
tmp <- einsum('ijk,jl->ilk', res@common_cores[[1]]@data, res@common_factors$A2)
tmp <- einsum('ilk,km->ilm', tmp, res@common_factors$A3)
# LRTensorをX_newに変更
X <- einsum('ijk,ljk->il', X_new, tmp)

# Save
# write.csv(X, file=outfile)
write.csv(X, file=outfile, row.names = FALSE)