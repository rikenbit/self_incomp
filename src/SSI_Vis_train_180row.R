source("src/functions_SSI_Vis_train_180row.R")

#### args setting####
args <- commandArgs(trailingOnly = T)
args_input <- args[1]
args_rec_error <- args[2]
args_rel_change <- args[3]
#### test args####
args_input_dir <- c("output/toy/MT_train_X/tensor")
args_input_dir2 <- c("output/toy/MT_train_X/tensor/")
args_input_pattern <- c("MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row")

args_rel_change <- c("output/toy/Vis_train/MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row.png")
args_rel_change_F <- c("output/toy/Vis_train_F1/MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row.png")

args_rec_error <- c("output/toy/Vis_train/MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row.png")
args_rec_error_F <- c("output/toy/Vis_train_F1/MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row.png")

# get dirname
list.files(args_input_dir,
           pattern = args_input_pattern,
           full.names = TRUE) |>
    str_subset(pattern = ".RData") -> cv_dirnames
# get filename
list.files(args_input_dir,
           pattern = args_input_pattern,
           full.names = FALSE) |>
    str_subset(pattern = ".RData") -> cv_filenames
# get sort order
cv_filenames |>
    str_remove(args_input_pattern) |>
    str_remove("_") |>
    str_remove(".RData") |>
    as.numeric() |>
    sort() -> cv_sort

# file pass list ,sort by row num
input_path_list <- c()
for(i in cv_sort){
    eval(parse(text=paste0("path <- c('", args_input_dir2, args_input_pattern, "_", i, ".RData')")))
    input_path_list <- c(input_path_list, path)
}

# purrr
purrr::map_dfc(cv_sort, .df_rel_change) |>
    rownames_to_column("order") -> df_rel_change
# pivot_longer
df_rel_change |>
    pivot_longer(!order,
                 names_to = "Pullout_row",
                 values_to = "RelChange") -> df_rel_change_long

row_order <- c()
for (i in cv_sort) {
    eval(parse(text=paste0("row_order <- c(row_order,'row_",i,"')")))
}
order_order <- df_rel_change$order

gg_rel_change <- ggplot(df_rel_change_long,
                        aes(x = factor(order, levels = order_order),
                            y = RelChange,
                            color = factor(Pullout_row, levels = row_order)
                            )
                        ) +
    geom_point(size=2.0, alpha = 0.6) +
    # theme(legend.position = "none") +
    labs(title = "RelChange",
         color="Pullout_row",
         x = "order") +
    theme(text = element_text(size = 60)) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(
        legend.position = c(1, 1),
        legend.justification = c(1, 1),
        legend.text = element_text(size=30),
        legend.title = element_text(size=30)
        ) +
    scale_y_log10()
#### ggsave####
ggsave(filename = args_rel_change,
       plot = gg_rel_change,
       dpi = 100,
       width = 30.0,
       height = 30.0,
       limitsize = FALSE)

# filter
df_rel_change_long |> dplyr::filter(order!="1") -> df_rel_change_long_F

gg_rel_change_F <- ggplot(df_rel_change_long,
                          aes(x = factor(order, levels = order_order),
                              y = RelChange,
                              color = factor(Pullout_row, levels = row_order)
                              )
                        ) +
    geom_point(size=2.0, alpha = 0.6) +
    labs(title = "RelChange",
         color="Pullout_row",
         x = "order") +
    theme(text = element_text(size = 60)) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(
        legend.position = c(1, 1),
        legend.justification = c(1, 1),
        legend.text = element_text(size=30),
        legend.title = element_text(size=30)
    ) +
    scale_y_log10()
#### ggsave####
ggsave(filename = args_rel_change_F,
       plot = gg_rel_change_F,
       dpi = 100,
       width = 30.0,
       height = 30.0,
       limitsize = FALSE)