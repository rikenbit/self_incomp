source("src/functions_SSI_common_factors_analysis.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input <- args[1]
args_outdir <- args[2]
args_output <- args[3]
#### test args####
# args_input <- c("elwood/self_incomp/output/train_X/tensor/MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx.RData")
# args_outdir <- c("elwood/self_incomp/output/Vis_train/train_X/res_hist")
# args_output <- c("elwood/self_incomp/output/Vis_train/train_X/res_hist/MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx.RData")
load(args_input)

for (factor in names(res@common_factors)) {
  plot_histogram_with_kurtosis(res@common_factors[[factor]], factor, args_outdir)
}

save(res, file=args_output)