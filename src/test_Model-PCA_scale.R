source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# infile1 <- c("output/PCA_scale/MT_train_X/one_slice_tensor/MODELS_Model-PCA_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row_1.RData")
# infile2 <- c("output/PCA_scale/MT_train_X/tensor/MODELS_Model-PCA_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row_1.RData")

# 1行test_X LRTensor LigandTensor ReceptorTensor 
load(infile1)
# Reshape
X_test <- rs_unfold(as.tensor(LRTensor), m=1)@data

# res  次元圧縮後のX_train
# data 次元圧縮前 179行train_X train_Model-PCA.Rの data <- rs_unfold(as.tensor(LRTensor), m=1)@dat
load(infile2)

#### new scale####
# 179x4347の訓練データ
X_train <- data
# scale
scale.data <- matrix(nrow=1, ncol=length(X_test))
for (i in seq(length(X_test))) {
  scale.data[1,i]<- X_test[,i] - mean(X_train[,i])
}
#####

# Prediction
X <- scale.data %*% res$rotation

# Save
write.csv(X, file=outfile, row.names = FALSE)
