#library
##################################################
library(tidyverse)
library(Biostrings)
##################################################
.df_onecol  = function(i) {
    cv_filenames[i] |>
          str_remove(".csv") |>
              strsplit("_") |>
                  unlist() -> cv_col_vec
    cv_col_vec[seq(2,length(cv_col_vec),2)] -> cv_params
    cv_dirnames[i] |>
        read_csv() |>
            as.data.frame() -> cv_value
    colnames(cv_value) <- cv_params[1]
    #### top16####
    eval(parse(text=paste0("colnames(cv_value) <- '", i ,"Rank_", cv_params[1], "'")))
    ##############
    cv_value -> return_object
    return(return_object)
}