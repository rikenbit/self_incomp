source("src/functions_SSI_Vis_Model.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input_dir <- args[1]
args_output <- args[2]
args_output_fw <- args[3]
#### test args####
# args_input_dir  <- c("output/LOOCV_rf")
# args_output    <- c("output/Vis_Model/Acc_Dens_plot.png")
# args_output_fw <- c("output/Vis_Model/Acc_Dens_plot_FW.png")

#### ディレクトリ一覧取得####
cv_dirnames <- list.files(args_input_dir, full.names = TRUE)
#### ファイル名一覧取得####
cv_filenames <- list.files(args_input_dir, full.names = FALSE)

#### create dataframe####
purrr::map_dfr(seq(length(cv_filenames)), .df_onerow) -> df_loocv
df_loocv |>
  dplyr::mutate(All_Tensor_Params=str_remove(cv_filenames,".csv"), .before=1) -> df_loocv

#### ggplot density group scaled by count ####
# scale https://stackoverflow.com/questions/45098389/normalizing-y-axis-in-density-plots-in-r-ggplot-to-proportion-by-group
# https://qiita.com/hoxo_b/items/13d034ab0ed60b4dca88
# The dot-dot notation (`..count..`) was deprecated in ggplot2 3.4.0.
# ℹ Please use `after_stat(count)` instead.
# https://mukkujohn.hatenablog.com/entry/2016/09/17/142036
cord_x <- c("Accuracy")
cord_y <- c("density (scaled)")
ggplot_title <- c("Density plot:Accuracy")
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
nrow(df_loocv) |> purrr::map(, .mutate_dim_x) -> dim_x