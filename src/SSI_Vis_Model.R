source("src/functions_SSI_Vis_Model.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input_dir <- args[1]

args_output_Dens <- args[2]
args_output_Dens_FW <- args[3]
args_output_DimX <- args[4]
args_output_Para <- args[5]
args_output_Hist_Id <- args[6]
args_output_Hist_Fill <- args[7]
args_Hist_Id_FW <- args[8]
#### test args####
# args_input_dir  <- c("output/LOOCV_rf")

# args_output_Dens    <- c("output/Vis_Model/Dens.png")
# args_output_Dens_FW <- c("output/Vis_Model/Dens_FW.png")
# args_output_DimX <- c("output/Vis_Model/DimX.png")
# args_output_Para <- c("output/Vis_Model/NumPara.png")
# args_output_Hist_Id <- c("output/Vis_Model/Hist_Id.png")
# args_output_Hist_Fill <- c("output/Vis_Model/Hist_Fill.png")
# args_Hist_Id_FW <- c("output/Vis_Model/Hist_Id_FW.png")

#### ディレクトリ一覧取得####
cv_dirnames <- list.files(args_input_dir, full.names = TRUE)
#### ファイル名一覧取得####
cv_filenames <- list.files(args_input_dir, full.names = FALSE)

#### create dataframe####
purrr::map_dfr(seq(length(cv_filenames)), .df_onerow) |>
    dplyr::mutate(All_Tensor_Params = str_remove(cv_filenames, ".csv"), .before=1) -> df_loocv
# http://www.g36cmsky.com/archives/28118887.html
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
df_loocv$MODELS <- factor(df_loocv$MODELS, levels=new_order)

#### ggplot density group scaled by count ####
cord_x <- c("Accuracy")
cord_y <- c("Density (scaled)")

gg_acc <- ggplot(df_loocv,
                 aes(x = Loocv,
                     col = MODELS,
                     number_of_cases = nrow(df_loocv),
                     y = (..count..)/number_of_cases
                     )
                 ) +
  geom_density(linewidth = 4.5) +
  labs(x = cord_x,
       y = cord_y
       ) +
  scale_x_continuous(breaks = seq(0.2, 0.9, 0.1), limits = c(0.2, 0.9)) +
  ylim(c(0, 2)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(text = element_text(size = 90))

ggsave(filename = args_output_Dens,
       plot = gg_acc,
       dpi = 50,
       width = 50.0,
       height = 40.0,
       limitsize = FALSE)

#### ggplot density facet_wrap ####
cord_x <- c("Accuracy")
cord_y <- c("Density (y_scale free)")

gg_acc_fw <- ggplot(df_loocv,
                 aes(x = Loocv,
                     col = MODELS)) +
    geom_density(linewidth = 4.5) +
    labs(x = cord_x,
         y = cord_y
         ) +
    scale_x_continuous(breaks = seq(0.2, 0.9, 0.2), limits = c(0.2, 0.9)) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 90)) +
    facet_wrap(~factor(MODELS, levels=new_order),
               ncol = 4,
               scales = "free")

ggsave(filename = args_output_Dens_FW,
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

gg_dim <- ggplot(df_model_dim_acc,
             aes(x = dim_exp_x,
                 y = Loocv,
                 col = MODELS
                 )
             ) +
    geom_point(size = 6.0) +
    scale_y_continuous(breaks = seq(0.2, 0.9, 0.1), limits = c(0.2, 0.9)) +
    labs(x = cord_x,
         y = cord_y
         ) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 90))

ggsave(filename = args_output_DimX,
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

gg_para <- ggplot(df_model_para_acc,
                 aes(x = num_para,
                     y = Loocv,
                     col = MODELS
                     )
                 ) +
    geom_point(size = 6.0) +
    scale_y_continuous(breaks = seq(0.2, 0.9, 0.1), limits = c(0.2, 0.9)) +
    scale_x_continuous(breaks = seq(1, 6, 1), limits = c(1, 6)) +
    labs(x = cord_x,
         y = cord_y
         ) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 90))

ggsave(filename = args_output_Para,
       plot = gg_para,
       dpi = 50,
       width = 50.0,
       height = 40.0,
       limitsize = FALSE)
#### ggplot hist group id####
cord_x <- c("Accuracy")
cord_y <- c("Count")

gg_hist <- ggplot(df_loocv,
                 aes(x = Loocv,
                     fill = MODELS
                     )
                 ) +
    # https://best-biostatistics.com/excel/sturges.html スタージェス ヒストグラムの階級数(ビンの数)
    geom_histogram(position="identity", alpha=0.8) +
    # geom_histogram(position="fill")+
    labs(x = cord_x,
         y = cord_y
         ) +
    scale_x_continuous(breaks = seq(0.2, 0.9, 0.1), limits = c(0.2, 0.9)) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text = element_text(size = 90))

ggsave(filename = args_output_Hist_Id,
       plot = gg_hist,
       dpi = 50,
       width = 50.0,
       height = 40.0,
       limitsize = FALSE)
#### ggplot hist group fill####
cord_x <- c("Accuracy")
cord_y <- c("Ratio")

gg_hist_fill <- ggplot(df_loocv,
                  aes(x = Loocv,
                      fill = MODELS
                      )
                  ) +
  # https://best-biostatistics.com/excel/sturges.html スタージェス ヒストグラムの階級数(ビンの数)
  geom_histogram(position="fill")+
  labs(x = cord_x,
       y = cord_y
  ) +
  scale_x_continuous(breaks = seq(0.2, 0.9, 0.1), limits = c(0.2, 0.9)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(text = element_text(size = 90))

ggsave(filename = args_output_Hist_Fill,
       plot = gg_hist_fill,
       dpi = 50,
       width = 50.0,
       height = 40.0,
       limitsize = FALSE)
#### ggplot hist facet_wrap ####
cord_x <- c("Accuracy")
cord_y <- c("Count")

gg_hist_fw <- ggplot(df_loocv,
                     aes(x = Loocv,
                         fill = MODELS)
                     ) +
  geom_histogram(position="identity") +
  labs(x = cord_x,
       y = cord_y
  ) +
  scale_x_continuous(breaks = seq(0.2, 0.9, 0.2), limits = c(0.2, 0.9)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(text = element_text(size = 90)) +
  facet_wrap(~MODELS,
             ncol = 4,
             scales = "free")

ggsave(filename = args_Hist_Id_FW,
       plot = gg_hist_fw,
       dpi = 50,
       width = 65.0,
       height = 50.0,
       limitsize = FALSE)
