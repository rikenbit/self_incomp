#library
##################################################
library(Biostrings)
library(rTensor)
library(tidyverse)
##################################################
shuffle_row <- function(matrix_data) {
  t(apply(matrix_data, 1, sample))
}