#library
##################################################
library(tidyverse)
##################################################
# ###################for文#####################
# #### colnames from ファイル名####
# cv_filename <- cv_filenames[1]
# cv_filename |>
#   str_remove(".csv") |>
#   strsplit("_") |>
#   unlist() |>
#   str_extract_all("[:alpha:]+") |>
#   unlist() -> cv_colnames
#
# #### parametor from ファイル名####
# cv_filename |>
#   strsplit("_") |>
#   unlist() |>
#   str_extract_all("[:digit:]+") |>
#   unlist() -> cv_params
#
# #### dataframe parametor####
# rbind(cv_colnames, cv_params) |>
#   as.data.frame(col.names = cv_colnames,
#                 row.names = FALSE) -> cv_df
# colnames(cv_df) <- cv_df[1,]
# cv_df <- cv_df[2,]
#
# #### dataframe LOOCV####
# cv_dirname <- cv_dirnames[1]
# cv_value <- read_csv(cv_dirname, col_names = "loocv")
#
# #### cbind####
# df_one_loocv <- merge(cv_df, cv_value)
# ###################for文#####################
# 参考 https://bioscryptome.t-ohashi.info/r/vector/#奇数番目の要素
.df_onerow  = function(i) {
  #### colnames from ファイル名####
  # cv_filename <- cv_filenames[i]
  # cv_filename |>
  #   str_remove(".csv") |>
  #   strsplit("_") |>
  #   unlist() |>
  #   str_extract_all("[:alpha:]+") |>
  #   unlist() -> cv_colnames
  cv_filenames[i] |>
      strsplit("_") |>
          unlist() -> cv_col_vec
      cv_col_vec[seq(1,length(cv_col_vec),2)] -> cv_colnames
  #### parametor from ファイル名####
  # cv_filename |>
  #   strsplit("_") |>
  #   unlist() |>
  #   str_extract_all("[:digit:]+") |>
  #   unlist() -> cv_params
      cv_col_vec[seq(2,length(cv_col_vec),2)] -> cv_params
  #### dataframe parametor####
  rbind(cv_colnames, cv_params) |>
    as.data.frame(col.names = cv_colnames,
                  row.names = FALSE) -> cv_df
  colnames(cv_df) <- cv_df[1,]
  cv_df <- cv_df[2,]
  #### dataframe LOOCV####
  cv_dirname <- cv_dirnames[i]
  cv_value <- read_csv(cv_dirname, col_names = "Loocv")
  #### cbind####
  df_one_loocv <- merge(cv_df, cv_value)

  df_one_loocv-> return_object
  return(return_object)
}
