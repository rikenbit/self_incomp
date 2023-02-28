source("src/functions_SSI_Vis_train_180row.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input <- args[1]
args_rec_error <- args[2]
args_rel_change <- args[3]
#### test args####
args_input_dir <- c("output/toy/MT_train_X/tensor")
args_input_dir2 <- c("output/toy/MT_train_X/tensor/")
args_input_pattern <- c("MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row")

# get dirname
list.files(args_input_dir,
           pattern = args_input_pattern,
           full.names = TRUE) |> 
    str_subset(pattern = ".RData") -> cv_dirnames
# get filename
list.files(args_input_dir,
           pattern = args_input_pattern,
           full.names = FALSE) |> 
    str_subset(pattern = ".RData") -> cv_filenames
# get sort order
cv_filenames |>
    str_remove(args_input_pattern) |>
    str_remove("_") |>
    str_remove(".RData") |>
    as.numeric() |>
    sort() -> cv_sort

# file pass list ,sort by row num
input_path_list <- c()
for(i in cv_sort){
    eval(parse(text=paste0("path <- c('", args_input_dir2, args_input_pattern, "_", i, ".RData')")))
    input_path_list <- c(input_path_list, path)
}


# purrrで各行のresを読み込んでcbind（map_dfc）、列名にrowNo.、
purrr::map_dfc(cv_sort, .df_rel_change) -> df_rel_change
# purrr後に縦長に変形


#### ggsave####