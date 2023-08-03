#library
##################################################
library(Biostrings)
library(rTensor)
library(tidyverse)
##################################################
shuffle_col_r <- function(row) {
  shuffled_row <- sample(row)
  return(shuffled_row)
}