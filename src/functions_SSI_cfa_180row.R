#library
##################################################
library(e1071)
library(tidyverse)
library(ggplot2)
library(gridExtra)
library(purrr)
##################################################
plot_histogram_with_kurtosis <- function(data_list, factor_name, colors) {
    # Initialize an empty ggplot object
    p <- ggplot() +
        ggtitle(paste("Histogram of", factor_name)) +
        xlab("Values")
    
    # Add a geom_freqpoly for each data vector in the list
    for (i in seq_along(data_list)) {
        # Create a data frame for ggplot
        df <- data.frame(value = data_list[[i]])
        
        # Add the geom_freqpoly to the plot
        p <- p + 
            geom_freqpoly(data = df, aes(x=value, y=..density..), color=colors[i], bins=30)
    }
    
    # Calculate average kurtosis
    kurt <- mean(unlist(lapply(data_list, kurtosis)))
    
    # Add average kurtosis information as text
    p <- p + annotate("text", x = Inf, y = Inf, label = paste("Ave_Kurtosis:", round(kurt, 2)), hjust=1, vjust=1)
    
    return(p)
}