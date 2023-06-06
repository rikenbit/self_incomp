source("src/functions_SSI_v_tensor.R")

#### args setting####
args <- commandArgs(trailingOnly = TRUE)
# LRTensor LigandTensor ReceptorTensor y
args_input_train <- args[1]
# LRTensor LigandTensor ReceptorTensor
args_input_test <- args[2]
args_output_res <- args[3]
args_output_1 <- args[4]
args_output_2 <- args[5]
r1 <- as.numeric(args[6]) #r1
r2 <- as.numeric(args[7]) #r2
r3 <- as.numeric(args[8]) #r3

# #### test args####
# args_input_train <- c("data/train_Tensors.RData")
# args_input_test <- c("data/test_Tensors.RData")
# r1 <- as.numeric("20") #r1
# r2 <- as.numeric("100") #r2
# r3 <- as.numeric("5") #r3
# args_output_res <- c("output/train_X/v_tensor/MODELS_Model-1-A1_r1_20_r2_50_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.RData")
# args_output_1 <- c("output/train_X/v_tensor/MODELS_Model-1-A1_r1_20_r2_50_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv")
# args_output_2 <- c("output/test_X/v_tensor/MODELS_Model-1-A1_r1_20_r2_50_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv")

#### load Arab test####
# Arab test data
load(args_input_test)
# rename object
test_LigandTensor <- LigandTensor
rm(LigandTensor)
test_ReceptorTensor <- ReceptorTensor
rm(ReceptorTensor)
test_LRTensor <- LRTensor
rm(LRTensor)

#### load Bra train####
# Bra train data
load(args_input_train)

#### vertical connect#####
# Vertically concatenate the arrays
vc_LRTensor <- abind(LRTensor, test_LRTensor, along=1)
# Verify the dimensions of the resulting array
# dim(LRTensor)
# dim(test_LRTensor)
# dim(vc_LRTensor)

#### DR Model-1-A1.R####
params <- new("CoupledMWCAParams",
              # Data-wise setting
              Xs=list(X1=vc_LRTensor),
              mask=list(X1=NULL),
              weights=list(X1=1),
              # Common Factor Matrices
              common_model=list(X1=list(I1="A1", I2="A2", I3="A3")),
              common_initial=list(A1=NULL, A2=NULL, A3=NULL),
              common_algorithms=list(A1="mySVD", A2="mySVD", A3="mySVD"),
              common_iteration=list(A1=30, A2=30, A3=30),
              common_decomp=list(A1=TRUE, A2=TRUE, A3=TRUE),
              common_fix=list(A1=FALSE, A2=FALSE, A3=FALSE),
              common_dims=list(A1=r1, A2=r2, A3=r3),
              common_transpose=list(A1=FALSE, A2=FALSE, A3=FALSE),
              common_coretype="Tucker",
              # Other option
              specific=FALSE,
              thr=1e-10,
              viz=FALSE,
              verbose=TRUE)

#### Tensor Decomposition####
res <- CoupledMWCA(params)
# Reshape
X <- t(res@common_factors$A1)
# Resize 180 x r1のmatrix
train_v_X <- X[1:180,]
test_v_X <- X[181:6070,]

####  Save#### 
save(res, file=args_output_res)
write.csv(train_v_X, file=args_output_1, row.names = FALSE)
write.csv(test_v_X, file=args_output_2, row.names = FALSE)