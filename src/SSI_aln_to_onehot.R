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
ligand_known <- readAAMultipleAlignment("data/multi_align_gap/sp11alnfinal90seq.aln")
receptor_known <- readAAMultipleAlignment("data/multi_align_gap/SRKfinal_90seq.aln")

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

# Response variable
X <- rbind(positivePair, negativePair)

# Outcome variable
Y <- c(rep(1, 90), rep(0, 90))

# Export X & Y for Python
write.csv(X,"output/SSI/x_r.csv", row.names = FALSE)
write.csv(Y,"output/SSI/y_r.csv", row.names = FALSE)