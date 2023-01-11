#library
##################################################
library(tidyverse)
##################################################
.df_onerow  = function(i) {
    cv_filenames[i] |>
      str_remove(".csv") |> 
          strsplit("_") |>
              unlist() -> cv_col_vec
    cv_col_vec[seq(1, length(cv_col_vec), 2)] -> cv_colnames
    cv_col_vec[seq(2, length(cv_col_vec), 2)] -> cv_params
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
    return_object <- df_one_loocv
    return(return_object)
}

.return_dim_x = function(i) {
    switch(df_loocv[i,"MODELS"],
           "Model-1-A1G" = as.numeric(df_loocv[i,"r2"]) * as.numeric(df_loocv[i,"r3"]),
           "Model-1-A1" = as.numeric(df_loocv[i,"r1"]),
           "Model-2-A1G" = as.numeric(df_loocv[i,"r2"]) * as.numeric(df_loocv[i,"r3"]),
           "Model-3-A1G" = 207 * as.numeric(df_loocv[i,"r3"]),
           "Model-3-A1" = as.numeric(df_loocv[i,"r1"]),
           "Model-4-A1G" = as.numeric(df_loocv[i,"r2"]) * 21,
           "Model-4-A1" = as.numeric(df_loocv[i,"r1"]),
           "Model-5-A1"  = as.numeric(df_loocv[i,"r1"]),
           "Model-6-A1A3G"  = as.numeric(df_loocv[i,"r2"]) * 21,
           "Model-7-A1A2G" = 207 * as.numeric(df_loocv[i,"r3"]),
           "Model-8-A1GLGR"  = as.numeric(df_loocv[i,"r2L"]) * as.numeric(df_loocv[i,"r3"]) + as.numeric(df_loocv[i,"r2R"]) * as.numeric(df_loocv[i,"r3"]),
           "Model-8-A1"  = as.numeric(df_loocv[i,"r1"]),
           "Model-9-A1A4GLGR" = as.numeric(df_loocv[i,"r2L"]) * as.numeric(df_loocv[i,"r3"]) + as.numeric(df_loocv[i,"r2R"]) * as.numeric(df_loocv[i,"r3"]),
           "Model-9-A1A4" = as.numeric(df_loocv[i,"r1L"]) + as.numeric(df_loocv[i,"r1R"]),
           "Model-10-A1GLGR"  = as.numeric(df_loocv[i,"r2L"]) * as.numeric(df_loocv[i,"r3L"]) + as.numeric(df_loocv[i,"r2R"]) * as.numeric(df_loocv[i,"r3R"]),
           "Model-10-A1"  = as.numeric(df_loocv[i,"r1"]),
           "Model-11-A1A4GLGR" = as.numeric(df_loocv[i,"r2L"]) * as.numeric(df_loocv[i,"r3L"]) + as.numeric(df_loocv[i,"r2R"]) * as.numeric(df_loocv[i,"r3R"]),
           "Model-11-A1A4" = as.numeric(df_loocv[i,"r1L"]) + as.numeric(df_loocv[i,"r1R"]),
           "Model-PCA" = as.numeric(df_loocv[i,"r2"]),
           stop("Only can use UMODEL")
           ) -> return_object
    return(return_object)
  }

.return_Num_Para_x = function(i) {
  switch(df_loocv[i,"MODELS"],
         "Model-1-A1G" = 3,
         "Model-1-A1" = 3,
         "Model-2-A1G" = 2,
         "Model-3-A1G" = 2,
         "Model-3-A1" = 2,
         "Model-4-A1G" = 2,
         "Model-4-A1" = 2,
         "Model-5-A1"  = 1,
         "Model-6-A1A3G"  = 1,
         "Model-7-A1A2G" = 1,
         "Model-8-A1GLGR"  = 4,
         "Model-8-A1"  = 4,
         "Model-9-A1A4GLGR" = 5,
         "Model-9-A1A4" = 5,
         "Model-10-A1GLGR"  = 5,
         "Model-10-A1"  = 5,
         "Model-11-A1A4GLGR" = 6,
         "Model-11-A1A4" = 6,
         "Model-PCA" = 1,
         stop("Only can use UMODEL")
  ) -> return_object
  return(return_object)
}