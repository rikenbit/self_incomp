#library
##################################################
library(tidyverse)
##################################################
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