#library
##################################################
library(tidyverse)
##################################################
.zero_one = function(i) {
    if(y_score[i]==1){
        return_object <- y[i]
    }
    else{
        if(y[i]==1){
            return_object <- 0
        }
        else{
            return_object <- 1
        }
    }
}