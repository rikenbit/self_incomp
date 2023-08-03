#library
##################################################
library(Biostrings)
library(rTensor)
library(tidyverse)
##################################################
# 各ブロックに対してシャッフルを行う関数
shuffle_block <- function(block) {
  shuffled_block <- sample(block)
  return(shuffled_block)
}