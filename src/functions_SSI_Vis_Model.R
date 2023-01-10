#library
##################################################
library(tidyverse)
##################################################
.df_onerow  = function(i) {
    cv_filenames[i] |>
        strsplit("_") |>
            unlist() -> cv_col_vec
    cv_col_vec[seq(1,length(cv_col_vec),2)] -> cv_colnames
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