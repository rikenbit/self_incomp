source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[11]
outfile1 <- args[12]
outfile2 <- args[13]
outfile3 <- args[14]
pullout_row <- as.numeric(args[10]) #row

# Loading
# LRTensor, LigandTensor ,ReceptorTensor
load(infile)
LRTensor <- LRTensor[-pullout_row,,]
LigandTensor <- LigandTensor[-pullout_row,,]
ReceptorTensor <- ReceptorTensor[-pullout_row,,]

# Parameter
# Tensor Parameter
r1 <- as.numeric(args[1]) #r1
r2 <- as.numeric(args[2]) #r2
a1 <- as.numeric(args[4]) #r4
a2 <- as.numeric(args[5]) #r5
cc <- as.character(args[6]) #r6

# Reshape
data <- rs_unfold(as.tensor(LRTensor), m=1)@data

# Matrix Decomposition
# res <- prcomp(data, rank=r)
params <- new("CoupledMWCAParams",
              Xs = list(X1=data),
              mask = list(X1=NULL),
              weights = list(X1=1),
              # common_model = list(I1="A1", I2="A2"),
              common_model = list(X1=list(I1="A1", I2="A2")),
              common_initial = list(A1=NULL, A2=NULL),
              common_algorithms = list(A1="mySVD", A2="mySVD"),
              # common_iteration = list(A1=30, A2=30), # <- 1と30で違う結果になるか
              common_iteration = list(A1=a1, A2=a2),
              common_decomp = list(A1=TRUE, A2=TRUE),
              common_fix = list(A1=FALSE, A2=FALSE),
              common_dims = list(A1=r1, A2=r2),
              common_transpose = list(A1=FALSE, A2=FALSE),
              # common_coretype = "Tucker", # <- CPとTuckerで違う結果になるか（CPにする場合、r1 = r2にする必要あり）
              common_coretype = cc,
              specific = FALSE,
              thr = 1e-10,
              viz = FALSE,
              verbose = TRUE
)

# Tensor Decomposition
res <- CoupledMWCA(params)

# Reshape
X <- t(res@common_factors$A1)

# Save
save(res, data, file=outfile1)
write.csv(X, file=outfile2, row.names = FALSE)

# Save for 射影
load(infile)
LRTensor <- array(LRTensor[pullout_row,,],
                  c(1, dim(LRTensor[pullout_row,,]))
                  )
LigandTensor <- array(LigandTensor[pullout_row,,],
                      c(1, dim(LigandTensor[pullout_row,,]))
                      )
ReceptorTensor <- array(ReceptorTensor[pullout_row,,],
                        c(1, dim(ReceptorTensor[pullout_row,,]))
                        )
save(LRTensor, LigandTensor, ReceptorTensor, file=outfile3)