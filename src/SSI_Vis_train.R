source("src/functions_SSI_Vis_train.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input <- args[1]
args_rec_error <- args[2]
args_rel_change <- args[3]
#### test args####
# args_input <- c("output/train_X/tensor/MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.RData")
# args_rec_error <- c("output/Vis_train/train_X/MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx/rec_error.png")
# args_rel_change <- c("output/Vis_train/train_X/MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx/rel_change.png")

#### rec_error####
rec_error <- as.numeric(res@rec_error)
rec_error <- rec_error[2:length(rec_error)]
rec_error |>
    as.data.frame() |>
        rownames_to_column("order") -> re_df
re_df$order <- as.numeric(re_df$order)

gg_rec_error <- ggplot(re_df,
                    aes(x = order,
                        y = rec_error
                        )
                    ) +
    geom_point(size=4.0) +
    labs(title = "RecError") +
    theme(text = element_text(size = 60)) +
    theme(plot.title = element_text(hjust = 0.5))
# ggsave
ggsave(filename = args_rec_error,
       plot = gg_rec_error,
       dpi = 100,
       width = 18.0,
       height = 20.0,
       limitsize = FALSE)

#### rel_change####
rel_change <- as.numeric(res@rel_change)
rel_change <- rel_change[2:length(rel_change)]
rel_change |>
    as.data.frame() |>
        rownames_to_column("order") -> re_df
re_df$order <- as.numeric(re_df$order)

gg_rel_change <- ggplot(re_df,
                       aes(x = order,
                           y = rel_change
                           )
                       ) +
    geom_point(size=4.0) +
    labs(title = "RecError") +
    theme(text = element_text(size = 60)) +
    theme(plot.title = element_text(hjust = 0.5))
# ggsave
ggsave(filename = args_rel_change,
       plot = gg_rel_change,
       dpi = 100,
       width = 18.0,
       height = 20.0,
       limitsize = FALSE)