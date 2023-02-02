source("src/functions_SSI_scikit_LDA.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input <- args[1]
args_output <- args[2]
args_params <- args[3]
#### test args####
# args_input <- c("output/OneDim_LDA/MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv")
# args_output <- c("output/OneDim_LDA/MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.svg")
# args_params <- c("output/SSI/y_r.csv")

# load X
one_X <- read_csv(args_input, 
                  col_names = FALSE)
colnames(one_X) <- c("LDA_X")
# load y
y_csv <- read_csv(args_params, 
                  col_names ="y",
                  skip =1)

# trans dataframe
y <- as.character(as.vector(y_csv)$y)
one_X |> 
    mutate(y) |> as.data.frame() -> df

# ggplot
gg_point <- ggplot(df, aes(x = LDA_X, y = y, color = y)) +
    geom_point(position = position_jitter(width=0.1), size = 4.0) +
    theme(axis.title = element_text(size = 40),
          axis.text.x = element_text(size = 40),
          axis.text.y = element_text(size = 40),
          legend.key.height = unit(2.5, "cm"),
          legend.key.width = unit(1.5, "cm"),
          legend.text = element_text(size = 40),
          legend.title = element_text(size = 40)
          )

gg_dens <- ggplot(df, aes(x = LDA_X, fill=y)) +
    geom_density(alpha=0.2) +
    theme(axis.title = element_text(size = 40),
          axis.text.x = element_text(size = 40),
          axis.text.y = element_text(size = 40),
          legend.key.height = unit(2.5, "cm"),
          legend.key.width = unit(1.5, "cm"),
          legend.text = element_text(size = 40),
          legend.title = element_text(size = 40)
    )

# patchwork
gg <- gg_dens +
    gg_point + 
    plot_layout(ncol = 1, heights = c(1, 1))

#### ggsave####
ggsave(filename = args_output,
       plot = gg,
       dpi = 100,
       width = 20.0,
       height = 20.0,
       limitsize = FALSE)