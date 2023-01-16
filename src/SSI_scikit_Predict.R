source("src/functions_SSI_scikit_Predict.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input_y <- args[1]
args_input_y_score <- args[2]
args_output <- args[3]
#### test args####
# args_input_y <- c("output/SSI/y_r.csv")
# args_input_y_score <- c("output/y_score/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.csv")
# args_output <- c("output/y_predict/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.csv")

read.csv(args_input_y_score) %>%
    .$score %>%
        as.numeric() -> y_score

read.csv(args_input_y) %>%
    .$x %>%
      as.numeric() -> y

seq(length(y)) %>%
    purrr::map(., .zero_one) %>%
        unlist() -> y_predict
y_predict <- as.tibble(y_predict)
#### save####
write.csv(y_predict,
          args_output, 
          row.names = FALSE)