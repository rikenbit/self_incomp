source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Loading
load(infile)

# Parameter
r2 <- 4

params <- new("CoupledMWCAParams",
    # Data-wise setting
    Xs=list(X1=LRTensor),
    mask=list(X1=NULL),
    weights=list(X1=1),
    # Common Factor Matrices
    common_model=list(X1=list(I1="A1", I2="A2", I3="A3")),
    common_initial=list(A1=NULL, A2=NULL, A3=NULL),
    common_algorithms=list(A1="mySVD", A2="mySVD", A3="mySVD"),
    common_iteration=list(A1=0, A2=30, A3=0),
    common_decomp=list(A1=FALSE, A2=TRUE, A3=FALSE),
    common_fix=list(A1=FALSE, A2=FALSE, A3=FALSE),
    common_dims=list(A1=dim(LRTensor)[1], A2=r2, A3=dim(LRTensor)[3]),
    common_transpose=list(A1=FALSE, A2=FALSE, A3=FALSE),
    common_coretype="Tucker",
    # Other option
    specific=FALSE,
    thr=1e-10,
    viz=FALSE,
    verbose=TRUE)

# Tensor Decomposition
res <- CoupledMWCA(params)

# Reshape
X <- rs_unfold(res@common_cores[[1]], m=1)@data

# Save
save(res, file=outfile1)
write.csv(X, file=outfile2)
