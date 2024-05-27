source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Loading
load(infile1)
load(infile2)

##########
# 3階テンソルから平均行列を算出
# mean_X1 <- einsum('ijk->jk', X) / dim(X)[1] # einsum利用の場合
mean_X1 <- einsum('ijk->jk', LRTensor) / dim(LRTensor)[1] # einsum利用の場合

# 3階テンソルから平均行列を引く
# X_new <- sweep(X, MARGIN=c(2,3), STATS=mean_X1)
X_new <- sweep(one_LRTensor, MARGIN=c(2,3), STATS=mean_X1)
##########

# Reshape, Prediction
tmp <- einsum('ijk,jl->ilk', res@common_cores[[1]]@data, res@common_factors$A2)
tmp <- einsum('ilk,km->ilm', tmp, res@common_factors$A3)
# LRTensorをX_newに変更
X <- einsum('ijk,ljk->il', X_new, tmp)

# Save
# write.csv(X, file=outfile)
write.csv(X, file=outfile, row.names = FALSE)