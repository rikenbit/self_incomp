source("src/functions_SSI_Predict_jaccard.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_output <- args[1]
args_model_u <- args[-1]

#### test args####
# args_output <- c("output/Predict_jaccard/u_model_heatmap_dendrogram.svg")
# args_model_u <- c("output/y_score/MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv",
#                   "output/y_score/MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv",
#                   "output/y_score/MODELS_Model-2-A1G_r1_xx_r2_10_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv",
#                   "output/y_score/MODELS_Model-3-A1_r1_10_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv",
#                   "output/y_score/MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10.csv")

### modelname####
purrr::map(seq(length(args_model_u)), .model_u_name) |>
    unlist() -> model_name

#### jaccard sapply#####
sapply(seq(length(args_model_u)),
       function(A) {
           sapply(seq(length(args_model_u)),
                  function(B){
                      y_A <- read_csv(args_model_u[A], skip =1)
                      colnames(y_A) <- c("pair_num","predict")
                      y_A %>%
                          dplyr::filter(predict==1) %>%
                              dplyr::select(pair_num) %>%
                                  .$pair_num %>%
                                      as.character() -> jac_A

                      y_B <- read_csv(args_model_u[B], skip =1)
                      colnames(y_B) <- c("pair_num","predict")
                      y_B %>%
                          dplyr::filter(predict==1) %>%
                              dplyr::select(pair_num) %>%
                                  .$pair_num %>%
                                    as.character() -> jac_B

                      jaccard(jac_A, jac_B)-> return_object
                      return_object
                  }
           )
       }
) -> sapply_jaccard

#### transform data.frame####
sapply_jaccard %>%
    as.data.frame() -> df_jaccard
colnames(df_jaccard) <- model_name
rownames(df_jaccard) <- model_name
df_jaccard %>%
    rownames_to_column("jac_x_axis") %>%
        pivot_longer(-jac_x_axis,
                     names_to = "jac_y_axis",
                     values_to = "jaccard") -> df_ghm
df_ghm <-as.data.frame(df_ghm)

#### geom_tile####
# sort hclust
# https://scrapbox.io/Bioinfo-yamaken/ヒートマップで階層的クラスタリングで並び替えたいとき
hc.cols <- hclust(dist(df_jaccard))
df_ghm$jac_x_axis <- factor(df_ghm$jac_x_axis, levels = colnames(df_jaccard)[hc.cols$order])
df_ghm$jac_y_axis <- factor(df_ghm$jac_y_axis, levels = colnames(df_jaccard)[hc.cols$order])
df_ghm |> 
    ggplot_ghm() -> ghm

dendro_plot <- ggdendrogram(data = as.dendrogram(hc.cols), labels = FALSE)
# patchwork
gg <- dendro_plot +
    ghm + 
    plot_layout(ncol = 1, heights = c(1, 4))

### ggsave####
ggsave(filename = args_output,
       plot = gg,
       dpi = 80,
       width = 24.0,
       height = 24.0,
       device="svg")