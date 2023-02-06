source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

# Data Loading
ligand_unknown <- readAAMultipleAlignment(infile1)
receptor_unknown <- readAAMultipleAlignment(infile2)

# Matrix Format
ligand_unknown <- as.matrix(ligand_unknown)
receptor_unknown <- as.matrix(receptor_unknown)

dim(ligand_unknown) # 190 genes × 99 cites
dim(receptor_unknown) # 31 genes × 108 cites

# One-Hot Vectorize
LigandTensor <- array(0, dim=c(5890, 99, 21))
ReceptorTensor <- array(0, dim=c(5890, 108, 21))

pairLoc <- expand.grid(seq(190), seq(31))
for(i in seq(nrow(pairLoc))){
    LigandTensor[i,,] <- .oneHotMatrix(ligand_unknown[pairLoc[i,1], ])
    ReceptorTensor[i,,] <- .oneHotMatrix(receptor_unknown[pairLoc[i,2], ])
}

# Tensor Data
LRTensor <- array(0, dim=c(5890, 99+108, 21))
LRTensor[1:5890, 1:99, 1:21] <- LigandTensor
LRTensor[1:5890, (99+1):(99+108), 1:21] <- ReceptorTensor

# Save
save(LRTensor, LigandTensor, ReceptorTensor, file=outfile)
