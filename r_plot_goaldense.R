library(ggplot2)
library(ggridges)

data <- read.csv("G:/My Drive/05. Project/01. MUFC Performance 2021-2022/output/count_goals_bigsix.csv")
head(data)

#mycolors <- c("gold", "dodgerblue1", "firebrick", "skyblue1", "red1", "gainsboro")

ggplot(data, aes(x = goals, y = squad)) + 
  scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24)) +
  geom_density_ridges(fill = "#3d195b", alpha = 0.75, size = 1) + 
  theme_ridges() + 
  theme(legend.position = "none") +
  ylab("")
  #scale_color_manual(values = mycolors)

ggsave('myplot.png', dpi = 300)