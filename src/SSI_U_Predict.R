source("src/functions_SSI_U_Predict.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_output <- args[1]
args_input_dir  <- args[2]
args_params_L <- args[3]
args_params_R <- args[4]

#### test args####
# args_input_dir  <- c("output/test_X/predict")
# args_output    <- c("output/test_X/SSI_U_Predict.csv")
# args_params_L <- c("data/multi_align_gap/ArabiLigand_all_final_190seq.aln")
# args_params_R <- c("data/multi_align_gap/ArabiReceptorFinal.aln")

# get pass
cv_dirnames <- list.files(args_input_dir, full.names = TRUE)
# get filename
cv_filenames <- list.files(args_input_dir, full.names = FALSE)
# #### top16####
# cv_dirnames <- c(
#     "output/test_X/predict/MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10.csv",
#     "output/test_X/predict/MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_20_r3R_20.csv",
#     "output/test_X/predict/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.csv",
#     "output/test_X/predict/MODELS_Model-10-A1GLGR_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_8_r3R_10.csv",
#     "output/test_X/predict/MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_10_r2R_25_r3L_20_r3R_5.csv",
#     "output/test_X/predict/MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_10_r2R_25_r3L_20_r3R_8.csv",
#     "output/test_X/predict/MODELS_Model-8-A1GLGR_r1_6_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx.csv",
#     "output/test_X/predict/MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx.csv",
#     "output/test_X/predict/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_10_r2R_25_r3L_10_r3R_8.csv",
#     "output/test_X/predict/MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_10_r3R_10.csv",
#     "output/test_X/predict/MODELS_Model-10-A1GLGR_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_10_r2R_25_r3L_10_r3R_8.csv",
#     "output/test_X/predict/MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_10_r2R_25_r3L_20_r3R_10.csv",
#     "output/test_X/predict/MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_10_r3R_8.csv",
#     "output/test_X/predict/MODELS_Model-8-A1GLGR_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx.csv",
#     "output/test_X/predict/MODELS_Model-10-A1GLGR_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_20_r3R_20.csv",
#     "output/test_X/predict/MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx.csv"
# )
# cv_filenames <- c(
#     "MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10.csv",
#     "MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_20_r3R_20.csv",
#     "MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.csv",
#     "MODELS_Model-10-A1GLGR_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_8_r3R_10.csv",
#     "MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_10_r2R_25_r3L_20_r3R_5.csv",
#     "MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_10_r2R_25_r3L_20_r3R_8.csv",
#     "MODELS_Model-8-A1GLGR_r1_6_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx.csv",
#     "MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx.csv",
#     "MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_10_r2R_25_r3L_10_r3R_8.csv",
#     "MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_10_r3R_10.csv",
#     "MODELS_Model-10-A1GLGR_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_10_r2R_25_r3L_10_r3R_8.csv",
#     "MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_10_r2R_25_r3L_20_r3R_10.csv",
#     "MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_10_r3R_8.csv",
#     "MODELS_Model-8-A1GLGR_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx.csv",
#     "MODELS_Model-10-A1GLGR_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_20_r3R_20.csv",
#     "MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx.csv"
# )
# ##############
#### top15####
cv_dirnames <- c(
    "output/test_X/predict/MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_10_r3R_10.csv",
    "output/test_X/predict/MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx.csv",
    "output/test_X/predict/MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv",
    "output/test_X/predict/MODELS_Model-1-A1_r1_20_r2_50_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv",
    "output/test_X/predict/MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_10_r3R_8.csv",
    "output/test_X/predict/MODELS_Model-8-A1_r1_20_r2_xx_r3_5_r1L_xx_r1R_xx_r2L_50_r2R_50_r3L_xx_r3R_xx.csv",
    "output/test_X/predict/MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_8_r3R_8.csv",
    "output/test_X/predict/MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_50_r3L_5_r3R_5.csv",
    "output/test_X/predict/MODELS_Model-8-A1_r1_20_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_50_r2R_50_r3L_xx_r3R_xx.csv",
    "output/test_X/predict/MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_10_r3R_20.csv",
    "output/test_X/predict/MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_5_r3R_8.csv",
    "output/test_X/predict/MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_8_r3R_10.csv",
    "output/test_X/predict/MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10.csv",
    "output/test_X/predict/MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_50_r3L_20_r3R_20.csv",
    "output/test_X/predict/MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_50_r3L_xx_r3R_xx.csv"
)
cv_filenames <- c(
    "MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_10_r3R_10.csv",
    "MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx.csv",
    "MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv",
    "MODELS_Model-1-A1_r1_20_r2_50_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv",
    "MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_10_r3R_8.csv",
    "MODELS_Model-8-A1_r1_20_r2_xx_r3_5_r1L_xx_r1R_xx_r2L_50_r2R_50_r3L_xx_r3R_xx.csv",
    "MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_8_r3R_8.csv",
    "MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_50_r3L_5_r3R_5.csv",
    "MODELS_Model-8-A1_r1_20_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_50_r2R_50_r3L_xx_r3R_xx.csv",
    "MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_10_r3R_20.csv",
    "MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_5_r3R_8.csv",
    "MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_8_r3R_10.csv",
    "MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10.csv",
    "MODELS_Model-10-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_50_r3L_20_r3R_20.csv",
    "MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_50_r3L_xx_r3R_xx.csv"
)
##############

purrr::map_dfc(seq(length(cv_filenames)), .df_onecol) -> df_pre

pairLoc <- expand.grid(seq(190), seq(31))
colnames(pairLoc) <- c("Ligand", "Receptor")

# mutate LR pair Number
df_pre |>
    dplyr::mutate(pairLoc,
                  .before = everything()
                 ) -> df_add_num

# mutate LR pair Name
ligand_unknown <- readAAMultipleAlignment(args_params_L)
receptor_unknown <- readAAMultipleAlignment(args_params_R)
pairLoc_Name <- expand.grid(as.character(rownames(ligand_unknown)),
                            as.character(rownames(receptor_unknown)))
colnames(pairLoc_Name) <- c("Ligand_Name", "Receptor_Name")
df_add_num |>
    dplyr::mutate(pairLoc_Name,
                  .before = everything()
                 ) -> df_add_name

# save
write.csv(df_add_name,
          args_output,
          row.names = FALSE)