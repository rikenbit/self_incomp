source("src/functions_SSI_tensor_viz.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input_dir  <- args[1]
args_output <- args[2]

#### test args####
# args_input_dir  <- c("output/SSI/LOOCV_rf")
# args_output    <- c("output/SSI/Tensor_viz/X_Tensor_LOOCV_rf.csv")

# args_input_dir  <- c("output/LOOCV_rf")
# args_input_dir  <- c("output/LOOCV_rf_copy")
# args_input_dir  <- c("output/LOOCV_rf_230124")
# args_input_dir  <- c("output/LOOCV_LDA")
# args_input_dir  <- c("output/LOOCV_LDA")

# args_output    <- c("output/Tensor_viz/X_Tensor_LOOCV_rf.csv")
# args_output    <- c("output/Tensor_viz/19Umodel_5para_copy/X_Tensor_LOOCV_rf.csv")
# args_output    <- c("output/Tensor_viz/19Umodel_TopPara/X_Tensor_LOOCV_LDA.csv")

#### ディレクトリ一覧取得####
cv_dirnames <- list.files(args_input_dir, full.names = TRUE)
#### ファイル名一覧取得####
cv_filenames <- list.files(args_input_dir, full.names = FALSE)

#### create dataframe####
purrr::map_dfr(seq(length(cv_filenames)), .df_onerow) -> df_loocv
df_loocv |>
  dplyr::mutate(All_Tensor_Params=str_remove(cv_filenames,".csv"), .before=1) -> df_loocv
#### save####
# Export X for Python
write.csv(df_loocv, args_output, row.names = FALSE)