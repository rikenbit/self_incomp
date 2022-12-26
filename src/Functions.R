# Package Loading
library("Biostrings")
library("rTensor")
library("mwTensor")
library("einsum")
library("geigen")
library("randomForest")
library("caret")

# Functions
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

# LDA
LDA <- function(X, y, l, sigma1=1E-1, sigma2=1E-1, verbose=FALSE){
	# Check Argument
	.checkLDA(X, y, l, sigma1, sigma2, verbose)
	# Initialization
	int <- .initLDA(X, y, l, sigma1, sigma2)
	S_w <- int$S_w
	S_b <- int$S_b
	# Optimization
	W <- geigen(S_b, S_w)$vectors[, seq(l)]
	# Score
	B <- X %*% W
	list(W=W, B=B)
}

.checkLDA <- function(X, y, l, sigma1, sigma2, verbose){
	# Check X
	stopifnot(is.matrix(X))
	# Check y
	stopifnot(is.vector(y))
	# Check l
	stopifnot(l <= min(dim(X)))
	# Check sigma1
	stopifnot(is.numeric(sigma1))
	stopifnot(sigma1 > 0)
	# Check sigma2
	stopifnot(is.numeric(sigma2))
	stopifnot(sigma2 > 0)
	# Check verbose
	stopifnot(is.logical(verbose))
}

.initLDA <- function(X, y, l, sigma1, sigma2){
	# Global Mean
	M <- colMeans(X)
	# Mean for each class
	Mi <- lapply(unique(y), function(x){
		target <- which(y == x)
		colMeans(X[target, ]) / length(target)
	})
	names(Mi) <- unique(y)
	# Number of samples
	ni <- lapply(unique(y), function(x){
		length(which(y == x))
	})
	names(ni) <- unique(y)
	# Within class scatter matrix
	scaleX <- t(t(X) - M)
	S_w <- t(scaleX) %*% scaleX
	diag(S_w) <- diag(S_w) + sigma1
	# Between class scatter matrix
	tmp_ <- lapply(as.character(unique(y)), function(x){
		tmp <- Mi[[x]] - M
		ni[[x]] * outer(tmp, tmp)
	})
	S_b <- Reduce("+", tmp_)
	diag(S_b) <- diag(S_b) + sigma2
	# Output
	list(S_w=S_w, S_b=S_b)
}

# Two-Dimenional LDA
TwoDLDA <- function(As, y, l1, l2, sigma1=1E-1, sigma2=1E-1, num.iter=30, verbose=FALSE){
	# Check Argument
	.checkTwoDLDA(As, y, l1, l2, sigma1, sigma2, num.iter, verbose)
	# Initialization
	int <- .initTwoDLDA(As, y, l1, l2)
	M <- int$M
	Mi <- int$Mi
	ni <- int$ni
	L <- int$L
	R <- int$R
	# Iteration
	for(n in seq(num.iter)){
		if(verbose){
			print(n)
		}
		L <- .updateL(As, y, M, Mi, ni, L, R, l1, sigma1, sigma2)
		R <- .updateR(As, y, M, Mi, ni, L, R, l2, sigma1, sigma2)
	}
	# Score
	Bs <- .calcB(As, L, R)
	list(L=L, R=R, Bs=Bs)
}

.checkTwoDLDA <- function(As, y, l1, l2, sigma1, sigma2, num.iter, verbose){
	# Check As
	stopifnot(is.list(As))
	stopifnot(all(unlist(lapply(As, function(x){dim(x) == dim(As[[1]])}))))
	# Check y
	stopifnot(is.vector(y))
	# Check As and y
	stopifnot(length(As) == length(y))
	# Check l1
	stopifnot(l1 <= dim(As[[1]])[1])
	# Check l2
	stopifnot(l2 <= dim(As[[1]])[2])
	# Check sigma1
	stopifnot(is.numeric(sigma1))
	stopifnot(sigma1 > 0)
	# Check sigma2
	stopifnot(is.numeric(sigma2))
	stopifnot(sigma2 > 0)
	# Check num.iter
	stopifnot(is.numeric(num.iter))
	stopifnot(num.iter > 0)
	# Check verbose
	stopifnot(is.logical(verbose))
}

.initTwoDLDA <- function(As, y, l1, l2){
	# Global Mean
	M <- Reduce("+", As) / length(As)
	# Mean for each class
	Mi <- lapply(unique(y), function(x){
		target <- which(y == x)
		Reduce("+", As[target]) / length(target)
	})
	names(Mi) <- unique(y)
	# Number of samples
	ni <- lapply(unique(y), function(x){
		length(which(y == x))
	})
	names(ni) <- unique(y)
	# Initial L and R
	nr <- nrow(As[[1]])
	nc <- ncol(As[[1]])
	L <- matrix(0, nrow=nr, ncol=l2)
	R <- matrix(0, nrow=nc, ncol=l1)
	diag(L) <- 1
	diag(R) <- 1
	list(M=M, Mi=Mi, ni=ni, L=L, R=R)
}

# LDA in mode 1
.updateL <- function(As, y, M, Mi, ni, L, R, l1, sigma1, sigma2){
	S_w_R <- .wScatter(As, y, Mi, R, sigma1)
	S_b_R <- .bScatter(y, Mi, ni, M, R, sigma2)
	geigen(S_b_R, S_w_R)$vectors[, seq(l1)]
}

# LDA in mode 2
.updateR <- function(As, y, M, Mi, ni, L, R, l2, sigma1, sigma2){
	S_w_L <- .wScatter(As, y, Mi, L, sigma1, reverse=TRUE)
	S_b_L <- .bScatter(y, Mi, ni, M, L, sigma2, reverse=TRUE)
	geigen(S_b_L, S_w_L)$vectors[, seq(l2)]
}

# Within class scatter matrix
.wScatter <- function(As, y, Mi, N, sigma1, reverse=FALSE){
	tmp_ <- lapply(unique(y), function(x){
		target1 <- which(y == x)
		target2 <- which(unique(y) == x)
		tmp2 <- lapply(As[target1], function(A){
			if(reverse){
				tmp <- t(A - Mi[[target2]]) %*% N
			}else{
				tmp <- (A - Mi[[target2]]) %*% N
			}
			tmp %*% t(tmp)
		})
		Reduce("+", tmp2)
	})
	out <- Reduce("+", tmp_)
	diag(out) <- diag(out) + sigma1
	out
}

# Between class scatter matrix
.bScatter <- function(y, Mi, ni, M, N, sigma2, reverse=FALSE){
	tmp_ <- lapply(seq_along(Mi), function(x){
		if(reverse){
			tmp <- t(Mi[[x]] - M) %*% N
		}else{
			tmp <- (Mi[[x]] - M) %*% N
		}
		ni[[x]] * tmp %*% t(tmp)
	})
	out <- Reduce("+", tmp_)
	diag(out) <- diag(out) + sigma2
	out
}

# Score
.calcB <- function(As, L, R){
	lapply(As, function(A){
		t(L) %*% A %*% R
	})
}
