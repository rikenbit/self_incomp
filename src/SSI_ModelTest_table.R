library(tidyverse)

.df_result  = function(i) {
    MT_filenames[i] |>
        str_remove(".csv") |>
        strsplit("_") |>
        unlist()  -> MT_value
    return_object <- data.frame(Model=MT_value[3],
                                Accuracy=MT_value[2])
}

# args_input_dir <- c("output/MT_test_X/predict")
# args_input_pattern <- c("Accuracy")
# args_output <- c("output/MT_test_X/predict_df/Accuracy_table.csv")

# 自力LOOCV方式
args_input_dir <- c("output/toy/MT_test_X/predict")
args_input_pattern <- c("Accuracy")
args_output <- c("output/toy/MT_test_X/predict_df/Accuracy_table.csv")

MT_filenames <- list.files(args_input_dir,
                           pattern = args_input_pattern,
                           full.names = FALSE)


purrr::map_dfr(seq(length(MT_filenames)), .df_result) -> df

df$Model <- factor(df$Model, levels = c("Model-1-A1",
                                        "Model-1-A1G",
                                        "Model-2-A1G",
                                        "Model-3-A1",
                                        "Model-3-A1G",
                                        "Model-4-A1",
                                        "Model-4-A1G",
                                        "Model-5-A1",
                                        "Model-6-A1A3G",
                                        "Model-7-A1A2G",
                                        "Model-8-A1",
                                        "Model-8-A1GLGR",
                                        "Model-9-A1A4",
                                        "Model-9-A1A4GLGR",
                                        "Model-10-A1",
                                        "Model-10-A1GLGR",
                                        "Model-11-A1A4",
                                        "Model-11-A1A4GLGR",
                                        "Model-PCA"))
df |> dplyr::arrange(Model) -> df_sort

write.csv(df_sort,
          args_output,
          row.names = FALSE)