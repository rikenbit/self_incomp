source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# 5890行の test_X LRTensor LigandTensor ReceptorTensor
load(infile1)
# Reshape 5890,207,21 -> 5890 x 4347にunfold
X_test <- rs_unfold(as.tensor(LRTensor), m=1)@data

# res  次元圧縮後のX_train
# data 次元圧縮前 180行train_X
load(infile2)

#### new scale####
# 180x4347の訓練データ
X_train <- data
# scale lengthは5890
scale.data <- matrix(nrow=nrow(X_test), ncol=ncol(X_test))
for (i in seq(ncol(X_test))) {
  scale.data[,i]<- X_test[,i] - mean(X_train[,i])
}
#####

# Prediction
X <- scale.data %*% res$rotation

# Save
write.csv(X, file=outfile, row.names = FALSE)
