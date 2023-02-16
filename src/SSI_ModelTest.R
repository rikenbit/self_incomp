source("src/functions_SSI_ModelTest.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_output <- args[1]
args_input_dir <- args[2]
args_input_dir2 <- args[3]
args_input_y <- args[4]
args_input_pattern <- args[5]

#### test args####
# args_output <- c("output/MT_test_X/predict_df.csv")
# args_input_dir  <- c("output/MT_test_X/predict")
# args_input_dir2  <- c("output/MT_test_X/predict/")
# args_input_y <- c("output/y_r.csv")
# args_input_pattern <- c("MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row")

# get pass
cv_dirnames <- list.files(args_input_dir, 
                          pattern=args_input_pattern, 
                          full.names = TRUE)
# get filename
cv_filenames <- list.files(args_input_dir, 
                           pattern=args_input_pattern, 
                           full.names = FALSE)

cv_filenames |> 
    str_remove(args_input_pattern) |> 
    str_remove("_") |> 
    str_remove(".csv") |> 
    as.numeric() |> 
    sort() -> cv_sort

# file pass list by row num sort
input_path_list <- c()
for(i in cv_sort){
    eval(parse(text=paste0("path <- c('", args_input_dir2, args_input_pattern, "_", i, ".csv')")))
    input_path_list <- c(input_path_list, path)
}

#180pair row
purrr::map_dfr(seq(length(input_path_list)), .df_onecol) -> df_pre

read_csv(args_input_y) |>  as.data.frame() -> y
colnames(y) <- c("y")
df_pre |> dplyr::mutate(y) -> df

# save
write.csv(df,
          args_output,
          row.names = FALSE)