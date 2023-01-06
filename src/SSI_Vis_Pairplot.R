source("src/functions_SSI_Vis_Pairplot.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input_x <- args[1]
args_input_y <- args[2]
args_output <- args[3]
args_output_umap <- args[4]

#### test args####
# args_input_x <- c("output/X_Tensor/MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx.csv")
# args_input_y <- c("output/SSI/y_r.csv")
# args_output <- c("output/Vis_Pairplot/MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx.png")
# args_output_umap <- c("output/Vis_Umap/MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx.png")
#### create dataframe of Xy ####
X_csv <- read_csv(args_input_x)
X_df <- as.data.frame(X_csv)
#### filter dim15####
if(ncol(X_df) <= 15) {
    n_dim <- ncol(X_df)
} else {
    n_dim <- 15
}
X_df <- X_df[,1:n_dim]
####
colnames(X_df) <- str_replace(colnames(X_df), 'V', 'col')
read_csv(args_input_y, col_names ="y",skip =1) -> y_csv
as.character(as.vector(y_csv)$y) -> y
X_df |> mutate(y) -> Xy_df

#### ggpairs####
Xy_df |>
    ggpairs(columns = 1:ncol(X_df),
            aes_string(color="y", alpha=0.5),
            upper = list(continuous="points"),
            legend = 1
            ) +
    labs(title= "") -> gg_Xy

ggsave(filename = args_output,
       plot = gg_Xy,
       dpi = 100,
       width = 20.0,
       height = 20.0,
       limitsize = FALSE)

#### umap ggplot####
set.seed(1234)
X_umap <- umap::umap(X_df)$layout
X_umap$layout |> 
    as.data.frame() |> 
        mutate(y) -> umap_df
colnames(umap_df) <- c("cord_1","cord_2","y")

gg_umap <- ggplot(umap_df,
                  aes(x = cord_1,
                      y = cord_2, 
                      color = y
                      )
                  ) +
  geom_point(size = 6.0,alpha = 0.6) +
  theme(text = element_text(size = 60))

ggsave(filename = args_output_umap,
       plot = gg_umap,
       dpi = 100,
       width = 20.0,
       height = 20.0,
       limitsize = FALSE)