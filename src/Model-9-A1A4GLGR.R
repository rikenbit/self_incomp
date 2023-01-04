source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Loading
load(infile)

# Parameter
r1 <- as.numeric(args[7]) #r1L
r2 <- as.numeric(args[9]) #r2L
r3 <- as.numeric(args[6]) #r3
r4 <- as.numeric(args[8]) #r1R
r5 <- as.numeric(args[10]) #r2R

params <- new("CoupledMWCAParams",
    # Data-wise setting
    Xs=list(X1=LigandTensor, X2=ReceptorTensor),
    mask=list(X1=NULL, X2=NULL),
    weights=list(X1=1, X2=1),
    # Common Factor Matrices
    common_model=list(
        X1=list(I1="A1", I2="A2", I3="A3"),
        X2=list(I4="A4", I5="A5", I3="A3")),
    common_initial=list(A1=NULL, A2=NULL, A3=NULL, A4=NULL, A5=NULL),
    common_algorithms=list(A1="mySVD", A2="mySVD", A3="mySVD", A4="mySVD", A5="mySVD"),
    common_iteration=list(A1=30, A2=30, A3=30, A4=30, A5=30),
    common_decomp=list(A1=TRUE, A2=TRUE, A3=TRUE, A4=TRUE, A5=TRUE),
    common_fix=list(A1=FALSE, A2=FALSE, A3=FALSE, A4=FALSE, A5=FALSE),
    common_dims=list(A1=r1, A2=r2, A3=r3, A4=r4, A5=r5),
    common_transpose=list(A1=FALSE, A2=FALSE, A3=FALSE, A4=FALSE, A5=FALSE),
    common_coretype="Tucker",
    # Other option
    specific=FALSE,
    thr=1e-10,
    viz=FALSE,
    verbose=TRUE)

# Tensor Decomposition
res <- CoupledMWCA(params)

# Reshape
tmp1 <- einsum('ij,ikl->jkl', res@common_factors$A1, res@common_cores[[1]]@data)
tmp2 <- einsum('ij,ikl->jkl', res@common_factors$A4, res@common_cores[[2]]@data)
X <- cbind(rs_unfold(as.tensor(tmp1), m=1)@data, rs_unfold(as.tensor(tmp2), m=1)@data)

# Save
save(res, file=outfile1)
write.csv(X, file=outfile2)
