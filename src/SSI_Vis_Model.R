source("src/functions_SSI_Vis_Model.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input_dir <- args[1]
args_output <- args[2]
args_output_fw <- args[3]
args_output_dim <- args[4]
args_output_para <- args[5]
#### test args####
# args_input_dir  <- c("output/LOOCV_rf")
# args_output    <- c("output/Vis_Model/Acc_Dens_plot.png")
# args_output_fw <- c("output/Vis_Model/Acc_Dens_plot_FW.png")
# args_output_dim <- c("output/Vis_Model/Dim_X_plot.png")
# args_output_para <- c("output/Vis_Model/Num_Para_plot.png")

#### ディレクトリ一覧取得####
cv_dirnames <- list.files(args_input_dir, full.names = TRUE)
#### ファイル名一覧取得####
cv_filenames <- list.files(args_input_dir, full.names = FALSE)

#### create dataframe####
purrr::map_dfr(seq(length(cv_filenames)), .df_onerow) |>
    dplyr::mutate(All_Tensor_Params = str_remove(cv_filenames, ".csv"), .before=1) -> df_loocv

new_order <- c("Model-1-A1G",
               "Model-1-A1",
               "Model-2-A1G",
               "Model-3-A1G",
               "Model-3-A1",
               "Model-4-A1G",
               "Model-4-A1",
               "Model-5-A1",
               "Model-6-A1A3G",
               "Model-7-A1A2G",
               "Model-8-A1GLGR",
               "Model-8-A1",
               "Model-9-A1A4GLGR",
               "Model-9-A1A4",
               "Model-10-A1GLGR",
               "Model-10-A1",
               "Model-11-A1A4GLGR",
               "Model-11-A1A4",
               "Model-PCA")

#### ggplot density group scaled by count ####
cord_x <- c("Accuracy")
cord_y <- c("density (scaled)")
ggplot_title <- c("Density plot:Accuracy")

gg_acc <- ggplot(df_loocv,
                 aes(x = Loocv,
                     col = MODELS,
                     number_of_cases = nrow(df_loocv),
                     y = (..count..)/number_of_cases
                     )
                 ) +
  geom_density(linewidth = 4.5) +
  labs(x = cord_x,
       y = cord_y,
       title = ggplot_title
       ) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
  ylim(c(0, 2)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(text = element_text(size = 90)) +
  scale_color_discrete(breaks = new_order)

ggsave(filename = args_output,
       plot = gg_acc,
       dpi = 50,
       width = 50.0,
       height = 40.0,
       limitsize = FALSE)

#### ggplot density facet_wrap ####
cord_x <- c("Accuracy")
cord_y <- c("density (y_scale free)")
ggplot_title <- c("Density plot:Accuracy  (each Model)")

gg_acc_fw <- ggplot(df_loocv,
                 aes(x = Loocv,
                     col = MODELS)) +
    geom_density(linewidth = 4.5) +
    scale_color_discrete(breaks = new_order) +
    labs(x = cord_x,
         y = cord_y,
         title = ggplot_title,
         col = "MODELS"
         ) +
    scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 90)) +
    facet_wrap(~factor(MODELS, levels=new_order),
               ncol = 4,
               scales = "free")

ggsave(filename = args_output_fw,
       plot = gg_acc_fw,
       dpi = 50,
       width = 65.0,
       height = 50.0,
       limitsize = FALSE)

#### ggplot Dimention of X ####
seq(nrow(df_loocv)) |>
    purrr::map(.return_dim_x) |>
        unlist() -> dim_x_vec
df_loocv |>
    dplyr::mutate(dim_exp_x=dim_x_vec) -> df_loocv_dim

df_model_dim_acc <- dplyr::select(df_loocv_dim,
                                  MODELS,
                                  dim_exp_x,
                                  Loocv)
cord_x <- c("Dimention of X")
cord_y <- c("Accuracy")
ggplot_title <- c("plot Dimention of X")

gg_dim <- ggplot(df_model_dim_acc,
             aes(x = dim_exp_x,
                 y = Loocv,
                 col = MODELS
                 )
             ) +
    geom_point(size = 6.0,
               alpha = 0.6) +
    scale_color_discrete(breaks = new_order) +
    scale_y_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
    labs(x = cord_x,
         y = cord_y,
         title = ggplot_title,
         col = "MODELS"
         ) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 90))

ggsave(filename = args_output_dim,
       plot = gg_dim,
       dpi = 50,
       width = 50.0,
       height = 40.0,
       limitsize = FALSE)

#### ggplot Number of Parameters ####
seq(nrow(df_loocv)) |>
  purrr::map(.return_Num_Para_x) |>
      unlist() -> Num_Para_vec

df_loocv |>
    dplyr::mutate(num_para=Num_Para_vec) |>
        dplyr::select(MODELS, num_para, Loocv) -> df_model_para_acc

cord_x <- c("Number of Parameters")
cord_y <- c("Accuracy")
ggplot_title <- c("plot Number of Parameters")

gg_para <- ggplot(df_model_para_acc,
                 aes(x = num_para,
                     y = Loocv,
                     col = MODELS
                     )
                 ) +
    geom_point(size = 6.0,
               alpha = 0.6) +
    scale_color_discrete(breaks = new_order) +
    scale_y_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
    scale_x_continuous(breaks = seq(1, 6, 1), limits = c(1, 6)) +
    labs(x = cord_x,
         y = cord_y,
         title = ggplot_title,
         col = "MODELS"
         ) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 90))

ggsave(filename = args_output_para,
       plot = gg_para,
       dpi = 50,
       width = 50.0,
       height = 40.0,
       limitsize = FALSE)