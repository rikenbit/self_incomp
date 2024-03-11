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