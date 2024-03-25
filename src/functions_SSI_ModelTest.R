#library
##################################################
library(tidyverse)
##################################################
.df_onecol  = function(i) {
    input_path_list[i] |> 
        str_remove(args_input_dir2) |> 
        str_remove(".csv") |> 
        strsplit("_") |> 
        unlist() -> cv_col_vec
    cv_col_vec[seq(2,length(cv_col_vec),2)] -> cv_params
    
    matrix(cv_params, nrow = 1, ncol = 11) |> 
        as.data.frame() -> cv_df
    cv_colnames <- cv_col_vec[seq(1,length(cv_col_vec),2)]
    colnames(cv_df) <- cv_colnames
        
    input_path_list[i] |>
        read_csv() |>
            as.data.frame() -> cv_value
    cv_df |> mutate(cv_value) -> cv_df_predict
    cv_df_predict -> return_object
    return(return_object)
}