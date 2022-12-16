source("src/functions_SSI_tensor.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input_sp  <- args[1]
args_input_srk <- args[2]
args_output    <- args[3]

args_model     <- args[4]

dim_aa         <- as.numeric(args[5]) # max 21
dim_gene_x2    <- as.numeric(args[6]) # max 180
dim_site_L     <- as.numeric(args[7]) # max 99
dim_site_R     <- as.numeric(args[8]) # max 108
dim_site_LR    <- dim_site_L + dim_site_R

#### test args####
# args_input_sp  <- c("data/multi_align_gap/sp11alnfinal90seq.aln")
# args_input_srk <- c("data/multi_align_gap/SRKfinal_90seq.aln")
# args_output    <- c("output/SSI/X_Tensor/Model1_AA10_Gene10_sL10_sR10.csv")
# args_model     <- c("1")
# dim_aa         <- as.numeric(c("10")) # max 21
# dim_gene_x2    <- as.numeric(c("10")) # max 180
# dim_site_L     <- as.numeric(c("10")) # max 99
# dim_site_R     <- as.numeric(c("10")) # max 108
# dim_site_LR    <- dim_site_L + dim_site_R # max 207

#### args max####
# model1  # model2  # model3  # model4
#     180   99 +108       180        99
# 99 +108        21        99        21
#      21 #########        21       108
######### #########       108 #########


#### common####
# Data Loading
ligand_known <- readAAMultipleAlignment(args_input_sp)
receptor_known <- readAAMultipleAlignment(args_input_srk)

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

#### switch####
set.seed(1234)
X <- switch(args_model,
            "1" = Model1(LRTensor, dim_gene_x2, dim_site_LR, dim_aa),
            "2" = Model2(LRTensor, dim_site_LR, dim_aa),
            "3" = Model3(LigandTensor, ReceptorTensor, dim_gene_x2, dim_site_L, dim_aa, dim_site_R),
            "4" = Model4(LigandTensor, ReceptorTensor, dim_site_L, dim_aa, dim_site_R),
            stop("Only can use Model1, Model2, Model3, Model4")
            )

#### save####
# Export X for Python
write.csv(X, args_output, row.names = FALSE)

# Y <- c(rep(1, 90), rep(0, 90))
# write.csv(Y,"output/SSI/y_r.csv", row.names = FALSE)