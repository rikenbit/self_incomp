source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Data Loading
ligand_known <- readAAMultipleAlignment(infile1)
receptor_known <- readAAMultipleAlignment(infile2)

# Matrix Format
ligand_known <- as.matrix(ligand_known)
receptor_known <- as.matrix(receptor_known)

dim(ligand_known) # 90 genes × 99 cites
dim(receptor_known) # 90 genes × 108 cites

# One-Hot Vectorize
oneHotLigand <- array(0, dim=c(90, 99, 21))
oneHotReceptor <- array(0, dim=c(90, 108, 21))

for(i in seq(nrow(ligand_known))){
    oneHotLigand[i,,] <- .oneHotMatrix(ligand_known[i,])
}

for(i in seq(nrow(receptor_known))){
    oneHotReceptor[i,,] <- .oneHotMatrix(receptor_known[i,])
}

oneHotLigand <- rs_unfold(as.tensor(oneHotLigand), m=1)@data
oneHotReceptor <- rs_unfold(as.tensor(oneHotReceptor), m=1)@data

# Positive Pair (L-R interaction)
positivePair <- cbind(oneHotLigand, oneHotReceptor)
# Negative Pairs (no L-R interation)
negativePair <- .randomPairs(oneHotLigand, oneHotReceptor, 90)

# Matrix => Tensor
positiveLigandTensor <- fold(oneHotLigand, row_idx=1, col_idx=c(2,3),
    modes=c(90, 99, 21))@data
positiveReceptorTensor <- fold(oneHotReceptor, row_idx=1, col_idx=c(2,3),
    modes=c(90, 108, 21))@data
negativeLigandTensor <- fold(negativePair[, 1:(99*21)], row_idx=1, col_idx=c(2,3),
    modes=c(90, 99, 21))@data
negativeReceptorTensor <- fold(negativePair[, (99*21+1):ncol(negativePair)], row_idx=1, col_idx=c(2,3),
    modes=c(90, 108, 21))@data

# Tensor Data
LigandTensor <- array(0, dim=c(90+90, 99, 21))
ReceptorTensor <- array(0, dim=c(90+90, 108, 21))
LRTensor <- array(0, dim=c(90+90, 99+108, 21))

LigandTensor[1:90, 1:99, 1:21] <- positiveLigandTensor
LigandTensor[91:180, 1:99, 1:21] <- negativeLigandTensor

ReceptorTensor[1:90, 1:108, 1:21] <- positiveReceptorTensor
ReceptorTensor[91:180, 1:108, 1:21] <- negativeReceptorTensor

LRTensor[1:180, 1:99, 1:21] <- LigandTensor
LRTensor[1:180, (99+1):(99+108), 1:21] <- ReceptorTensor

# Response variable
y <- c(rep(1, 90), rep(0, 90))

# Save
save(LRTensor, LigandTensor, ReceptorTensor, y, file=outfile)
