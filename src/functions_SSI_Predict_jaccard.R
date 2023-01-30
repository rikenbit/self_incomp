#library
##################################################
library(tidyverse)
library(RColorBrewer)
library(viridis)
library(openxlsx) # read.xlsxを追加
library(svglite) # svgでの保存できるようにする
##################################################
.model_u_name  = function(i) {
    args_model_u[i] |>
        str_remove(".csv") |>
            strsplit("_") |>
                unlist() -> return_object
  return(return_object[3])
}

jaccard <- function(a, b) {
  intersection = length(intersect(a, b))
  union = length(a) + length(b) - intersection
  return(intersection/union)
}

ggplot_ghm = function(x) {
  ghm <- ggplot(x, aes(x = jac_x_axis, y = jac_y_axis, fill = jaccard))
  ghm <- ghm + geom_tile()
  ghm <- ghm + theme_bw()
  ghm <- ghm + theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank(),
    panel.background = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    strip.background = element_rect(fill = "white", colour = "white"),
    plot.title = element_text(size = 60, hjust = 0.5),
    axis.title = element_text(size = 60),
    axis.text.x = element_text(size = 60, angle = 90),
    axis.text.y = element_text(size = 60),
    legend.key.height = unit(2.5, "cm"),
    legend.key.width = unit(1.5, "cm"),
    legend.text = element_text(size = 60),
    legend.title = element_text(size = 60)
  )
  ghm <- ghm + scale_fill_viridis(na.value = "grey", direction = 1) # heatmap color is viridis http://www.okadajp.org/RWiki/?色見本
  ghm <- ghm + labs(x = "",
                    y = "")
  ghm <- ghm + labs(fill = "Jaccard")
  return(ghm)
}