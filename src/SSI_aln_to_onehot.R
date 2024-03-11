source("src/functions_SSI_aln_to_onehot.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
outfile1 <- args[3]
outfile2 <- args[4]

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

# Response variable
X <- rbind(positivePair, negativePair)

# Outcome variable
Y <- c(rep(1, 90), rep(0, 90))

# Export X & Y for Python
write.csv(X, outfile1, row.names = FALSE)
write.csv(Y, outfile2, row.names = FALSE)
