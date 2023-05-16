source("src/functions_SSI_cfa_180row.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input <- args[1]
args_input_pattern <- args[2]
args_output <- args[3]
#### test args####
# args_input <- "output/MT_train_X/tensor"  # Replace with your input directory
# args_input_pattern <- c("MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx")
# args_output <- "output"  # Replace with your output directory

# Get the list of .RData files in the directory
file_list <- list.files(path = args_input, pattern = "*.RData", full.names = TRUE)
file_list <- file_list[str_detect(file_list, args_input_pattern)]

# Initialize a list to store the data vectors
data_list <- list()

# Load each .RData file and add its data to the corresponding common factor in the data list
for (file_path in file_list) {
    load(file_path)

    for (factor in names(res@common_factors)) {
        # Flatten the matrix to a single vector
        data_vector <- c(res@common_factors[[factor]])

        # If the factor is already in the data list, append the new data vector to it
        if (factor %in% names(data_list)) {
            data_list[[factor]] <- append(data_list[[factor]], list(data_vector))
        } else {
            data_list[[factor]] <- list(data_vector)
        }
    }
}

# Create the corresponding plot for each common factor
plot_list <- map(names(data_list), ~{
    # Assign colors for the histograms
    colors <- rainbow(length(data_list[[.]]))

    plot_histogram_with_kurtosis(data_list[[.]], ., colors)
})

# Open PNG device
png(filename = args_output, width = 700, height = 500 * length(plot_list))

# Arrange the plots in one column
grid.arrange(grobs = plot_list, ncol = 1)

# Close PNG device
dev.off()
