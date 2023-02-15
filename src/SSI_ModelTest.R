source("src/functions_SSI_ModelTest.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_output <- args[1]
args_input_dir <- args[2]
args_input_y <- args[3]

#### test args####
# args_input_dir  <- c("output/MT_test_X/predict")
# args_input_y <- c("output/y_r.csv")
# args_output <- c("output/MT_test_X/predict_df.csv")

# get pass
cv_dirnames <- list.files(args_input_dir, full.names = TRUE)
# get filename
cv_filenames <- list.files(args_input_dir, full.names = FALSE)

#180pair row
purrr::map_dfr(seq(length(cv_filenames)), .df_onecol) -> df_pre

read_csv(args_input_y) |>  as.data.frame() -> y
colnames(y) <- c("y")
df_pre |> mutate(y) -> df

# save
write.csv(df,
          args_output,
          row.names = FALSE)