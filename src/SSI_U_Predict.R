source("src/functions_SSI_U_Predict.R")

#### args setting####
# args <- commandArgs(trailingOnly = T)
# args_output <- args[1]
# args_input_dir  <- args[2]
# args_params_L <- args[3]
# args_params_R <- args[4]

#### test args####
args_input_dir  <- c("output/test_X/predict")
args_output    <- c("output/test_X/SSI_U_Predict.csv")
args_params_L <- c("data/multi_align_gap/ArabiLigand_all_final_190seq.aln")
args_params_R <- c("data/multi_align_gap/ArabiReceptorFinal.aln")

# get pass
cv_dirnames <- list.files(args_input_dir, full.names = TRUE)
# get filename
cv_filenames <- list.files(args_input_dir, full.names = FALSE)
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