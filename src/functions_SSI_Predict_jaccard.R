#library
##################################################
library()
##################################################
jaccard <- function(a, b) {
  intersection = length(intersect(a, b))
  union = length(a) + length(b) - intersection
  return(intersection/union)
}