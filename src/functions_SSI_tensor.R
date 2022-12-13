#library
##################################################
# Package Loading
library(Biostrings)
library(rTensor)
library(mwTensor)
library(einsum)
##################################################
.oneHotMatrix <- function(seq1){
    out <- matrix(0, nrow=length(seq1), ncol=21)
    colnames(out) <- c(AA_ALPHABET[seq(20)], "-")
    for(i in seq_along(seq1)){
        out[i, which(colnames(out) == seq1[i])] <- 1
    }
    out
}

.randomPairs <- function(seq1, seq2, nr){
    combi <- expand.grid(seq(nr), seq(nr))
    idx <- subset(combi, Var1 != Var2)
    idx <- idx[sample(nrow(idx), nr), ]
    cbind(seq1[idx[,1], ], seq2[idx[,2], ])
}

########################################
# Model 1
########################################
Model1 <- function(LRTensor, r1, r2, r3){
	params <- new("CoupledMWCAParams",
		# Data-wise setting
		Xs=list(X1=LRTensor),
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
	res <- CoupledMWCA(params)
	tmp <- einsum('ij,ikl->jkl', res@common_factors$A1, res@common_cores[[1]]@data)
	rs_unfold(as.tensor(tmp), m=1)@data
}

# Response variable
# X1 <- Model1(LRTensor, 3, 4, 5)

########################################
# Model 2
########################################
Model2 <- function(LRTensor, r1, r2){
	params <- new("CoupledMWCAParams",
		# Data-wise setting
		Xs=list(X1=LRTensor),
		mask=list(X1=NULL),
		weights=list(X1=1),
		# Common Factor Matrices
		common_model=list(X1=list(I1="A1", I2="A2", I3="A3")),
		common_initial=list(A1=NULL, A2=NULL, A3=NULL),
		common_algorithms=list(A1="mySVD", A2="mySVD", A3="mySVD"),
		common_iteration=list(A1=0, A2=30, A3=30),
		common_decomp=list(A1=FALSE, A2=TRUE, A3=TRUE),
		common_fix=list(A1=FALSE, A2=FALSE, A3=FALSE),
		common_dims=list(A1=dim(LRTensor)[1], A2=r1, A3=r2),
		common_transpose=list(A1=FALSE, A2=FALSE, A3=FALSE),
		common_coretype="Tucker",
		# Other option
		specific=FALSE,
		thr=1e-10,
		viz=FALSE,
		verbose=TRUE)
	res <- CoupledMWCA(params)
	tmp <- einsum('ij,ikl->jkl', res@common_factors$A1, res@common_cores[[1]]@data)
	rs_unfold(as.tensor(tmp), m=1)@data
}

# Response variable
# X2 <- Model2(LRTensor, 3, 4)

########################################
# Model 3
########################################
Model3 <- function(LigandTensor, ReceptorTensor, r1, r2, r3, r4){
	params <- new("CoupledMWCAParams",
		# Data-wise setting
		Xs=list(X1=LigandTensor, X2=ReceptorTensor),
		mask=list(X1=NULL, X2=NULL),
		weights=list(X1=1, X2=1),
		# Common Factor Matrices
		common_model=list(
			X1=list(I1="A1", I2="A2", I3="A3"),
			X2=list(I1="A1", I4="A4", I3="A3")),
		common_initial=list(A1=NULL, A2=NULL, A3=NULL, A4=NULL),
		common_algorithms=list(A1="mySVD", A2="mySVD", A3="mySVD", A4="mySVD"),
		common_iteration=list(A1=30, A2=30, A3=30, A4=30),
		common_decomp=list(A1=TRUE, A2=TRUE, A3=TRUE, A4=TRUE),
		common_fix=list(A1=FALSE, A2=FALSE, A3=FALSE, A4=FALSE),
		common_dims=list(A1=r1, A2=r2, A3=r3, A4=r4),
		common_transpose=list(A1=FALSE, A2=FALSE, A3=FALSE, A4=FALSE),
		common_coretype="Tucker",
		# Other option
		specific=FALSE,
		thr=1e-10,
		viz=FALSE,
		verbose=TRUE)
	res <- CoupledMWCA(params)
	tmp1 <- einsum('ij,ikl->jkl', res@common_factors$A1, res@common_cores[[1]]@data)
	tmp2 <- einsum('ij,ikl->jkl', res@common_factors$A1, res@common_cores[[2]]@data)
	cbind(rs_unfold(as.tensor(tmp1), m=1)@data, rs_unfold(as.tensor(tmp2), m=1)@data)
}

# Response variable
# X3 <- Model3(LigandTensor, ReceptorTensor, 2, 3, 4, 5)

########################################
# Model 4
########################################
Model4 <- function(LigandTensor, ReceptorTensor, r1, r2, r3){
	params <- new("CoupledMWCAParams",
		# Data-wise setting
		Xs=list(X1=LigandTensor, X2=ReceptorTensor),
		mask=list(X1=NULL, X2=NULL),
		weights=list(X1=1, X2=1),
		# Common Factor Matrices
		common_model=list(
			X1=list(I1="A1", I2="A2", I3="A3"),
			X2=list(I1="A1", I4="A4", I3="A3")),
		common_initial=list(A1=NULL, A2=NULL, A3=NULL, A4=NULL),
		common_algorithms=list(A1="mySVD", A2="mySVD", A3="mySVD", A4="mySVD"),
		common_iteration=list(A1=0, A2=30, A3=30, A4=30),
		common_decomp=list(A1=FALSE, A2=TRUE, A3=TRUE, A4=TRUE),
		common_fix=list(A1=FALSE, A2=FALSE, A3=FALSE, A4=FALSE),
		common_dims=list(A1=dim(LigandTensor)[1], A2=r1, A3=r2, A4=r3),
		common_transpose=list(A1=FALSE, A2=FALSE, A3=FALSE, A4=FALSE),
		common_coretype="Tucker",
		# Other option
		specific=FALSE,
		thr=1e-10,
		viz=FALSE,
		verbose=TRUE)
	res <- CoupledMWCA(params)
	tmp1 <- einsum('ij,ikl->jkl', res@common_factors$A1, res@common_cores[[1]]@data)
	tmp2 <- einsum('ij,ikl->jkl', res@common_factors$A1, res@common_cores[[2]]@data)
	cbind(rs_unfold(as.tensor(tmp1), m=1)@data, rs_unfold(as.tensor(tmp2), m=1)@data)
}

# Response variable
# X4 <- Model4(LigandTensor, ReceptorTensor, 3, 4, 5)