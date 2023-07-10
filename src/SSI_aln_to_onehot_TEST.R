# yamaken37/ssi_tensor:20221212で実行
# Package Loading
library(Biostrings)
library(rTensor)

# Function
.oneHotMatrix <- function(seq1){
    out <- matrix(0, nrow=length(seq1), ncol=21)
    colnames(out) <- c(AA_ALPHABET[seq(20)], "-")
    for(i in seq_along(seq1)){
        out[i, which(colnames(out) == seq1[i])] <- 1
    }
    out
}

.randomPairs <- function(seq1, seq2, nr){
    # https://qiita.com/maech/items/83d1b3a85b976ffcdaf6
    combi <- expand.grid(seq(nr), seq(nr))
    idx <- subset(combi, Var1 != Var2)
    idx <- idx[sample(nrow(idx), nr), ]
    cbind(seq1[idx[,1], ], seq2[idx[,2], ])
}

# Data Loading
ligand_unknown <- readAAMultipleAlignment("data/multi_align_gap/ArabiLigand_all_final_190seq.aln")
receptor_unknown <- readAAMultipleAlignment("data/multi_align_gap/ArabiReceptorFinal.aln")

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

unfold_LRTensor <- rs_unfold(as.tensor(LRTensor), m=1)@data

########################################################################

# Export X 
write.csv(unfold_LRTensor,"output/SSI/x_r_test.csv", row.names = FALSE)
