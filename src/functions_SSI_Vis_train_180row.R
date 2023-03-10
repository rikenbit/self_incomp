#library
##################################################
library(tidyverse)
##################################################
.df_rec_error  = function(i) {
    load(input_path_list[i])
    rec_error <- as.numeric(res@rec_error)
    rec_error <- rec_error[2:length(rec_error)]
    rec_error |>
        as.data.frame() -> re_df
    eval(parse(text=paste0("df_col_name <- c('row_",i,"')")))
    colnames(re_df) <- df_col_name
    return_object <- re_df
    return(return_object)
}
.df_rel_change  = function(i) {
    load(input_path_list[i])
    rel_change <- as.numeric(res@rel_change)
    rel_change <- rel_change[2:length(rel_change)]
    rel_change |>
        as.data.frame() -> re_df
    eval(parse(text=paste0("df_col_name <- c('row_",i,"')")))
    colnames(re_df) <- df_col_name
    return_object <- re_df
    return(return_object)
}