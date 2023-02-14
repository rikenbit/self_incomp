# source("src/functions_SSI_MT_preprocess.R")
source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile1 <- args[3]
outfile2 <- args[4]
pullout_row <- args[5]

#### test####
infile1 <- c("data/multi_align_gap/sp11alnfinal90seq.aln")
infile2 <- c("data/multi_align_gap/SRKfinal_90seq.aln")
outfile1 <- c("data/MT_train_Tensors/row_1.RData")
outfile2 <- c("data/MT_onerow_Tensors/row_1.RData")
pullout_row <- c("1")
########
pullout_row <- as.numeric(pullout_row)

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

LRTensor_all <- LRTensor
LigandTensor_all <- LigandTensor
ReceptorTensor_all <- ReceptorTensor
y_all <- y

# Save train
LRTensor <- LRTensor_all[-pullout_row,,]
LigandTensor <- LigandTensor_all[-pullout_row,,]
ReceptorTensor <- ReceptorTensor_all[-pullout_row,,]
y <- y_all[-pullout_row]
save(LRTensor, LigandTensor, ReceptorTensor, y, file=outfile1)
# Save onerow
LRTensor <- LRTensor_all[pullout_row,,]
LigandTensor <- LigandTensor_all[pullout_row,,]
ReceptorTensor <- ReceptorTensor_all[pullout_row,,]
y <- y_all[pullout_row]
save(LRTensor, LigandTensor, ReceptorTensor, y, file=outfile2)
