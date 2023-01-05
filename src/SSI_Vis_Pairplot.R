source("src/functions_SSI_Vis_Pairplot.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input_x <- args[1]
args_input_y <- args[2]
args_output <- args[3]

#### test args####
# args_input_x <- c("output/X_Tensor/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.csv")
# args_input_y <- c("output/SSI/y_r.csv")
# args_output <- c("output/Vis_Pairplot/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.png")

#### create dataframe of Xy ####
X_csv <- read_csv(args_input_x)
X_df <- as.data.frame(X_csv)
colnames(X_df) <- str_replace(colnames(X_df), 'V', 'col')

read_csv(args_input_y, col_names ="y",skip =1) -> y_csv
as.character(as.vector(y_csv)$y) -> y

X_df |> 
  mutate(y) -> Xy_df

#### ggpairs####
Xy_df |> 
    ggpairs(columns = 1:ncol(X),
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