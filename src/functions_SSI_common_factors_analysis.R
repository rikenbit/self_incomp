#library
##################################################
library(einsum)
library(rTensor)
library(mixOmics)
library(mwTensor)
library(e1071)
##################################################
plot_histogram_with_kurtosis <- function(data, factor_name, output_dir) {
  # Flatten the matrix to a single vector
  data_vector <- c(data)
  
  # Calculate kurtosis
  kurt <- kurtosis(data_vector)
  
  png(filename = paste0(output_dir, "/", factor_name, "_histogram.png"), width = 700, height = 500)
  
  # Plot histogram
  hist(data_vector, main = paste("Histogram of", factor_name), xlab = "Values", freq = FALSE, col = 'grey')
  
  # Add kurtosis information as text
  mtext(paste("Kurtosis:", round(kurt, 2)), side = 3)
  
  dev.off()
}