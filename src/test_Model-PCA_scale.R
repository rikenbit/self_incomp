source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

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
