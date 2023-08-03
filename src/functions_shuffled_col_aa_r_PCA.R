#library
##################################################
library(Biostrings)
library(rTensor)
library(tidyverse)
##################################################
shuffle_blocks_in_row <- function(row) {
  # 行をブロックに分ける
  blocks <- split(row, ceiling(1:length(row) / N_site))
  
  # ブロックの順番をシャッフル
  shuffled_blocks <- blocks[sample(length(blocks))]
  
  # シャッフルされたブロックを結合
  unlist(shuffled_blocks)
}