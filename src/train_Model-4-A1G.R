source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[11]
outfile1 <- args[12]
outfile2 <- args[13]
outfile3 <- args[14]
pullout_row <- as.numeric(args[10]) #row

# Loading
# LRTensor, LigandTensor ,ReceptorTensor
load(infile)
LRTensor <- LRTensor[-pullout_row,,]
LigandTensor <- LigandTensor[-pullout_row,,]
ReceptorTensor <- ReceptorTensor[-pullout_row,,]

# Parameter
r1 <- as.numeric(args[4]) #r1
r2 <- as.numeric(args[5]) #r2

params <- new("CoupledMWCAParams",
    # Data-wise setting
    Xs=list(X1=LRTensor),
    mask=list(X1=NULL),
    weights=list(X1=1),
    # Common Factor Matrices
    common_model=list(X1=list(I1="A1", I2="A2", I3="A3")),
    common_initial=list(A1=NULL, A2=NULL, A3=NULL),
    common_algorithms=list(A1="mySVD", A2="mySVD", A3="mySVD"),
    common_iteration=list(A1=30, A2=30, A3=0),
    common_decomp=list(A1=TRUE, A2=TRUE, A3=FALSE),
    common_fix=list(A1=FALSE, A2=FALSE, A3=FALSE),
    common_dims=list(A1=r1, A2=r2, A3=dim(LRTensor)[3]),
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
tmp <- einsum('ij,ikl->jkl', res@common_factors$A1, res@common_cores[[1]]@data)
X <- rs_unfold(as.tensor(tmp), m=1)@data

# Save
save(res, file=outfile1)
write.csv(X, file=outfile2, row.names = FALSE)

# Save for 射影
load(infile)
LRTensor <- array(LRTensor[pullout_row,,],
                  c(1, dim(LRTensor[pullout_row,,]))
                  )
LigandTensor <- array(LigandTensor[pullout_row,,],
                      c(1, dim(LigandTensor[pullout_row,,]))
                      )
ReceptorTensor <- array(ReceptorTensor[pullout_row,,],
                  c(1, dim(ReceptorTensor[pullout_row,,]))
                  )
save(LRTensor, LigandTensor, ReceptorTensor, file=outfile3)
