# Radar chart with multiple overlapping individuals

library(fmsb)

# Construct the data set
data <- data.frame("saves" = c(1, 0, 
                               0.695
                               #0.720999985,
                               #0.753000031
                               #0.699000015
                               #0.736999969
                               #0.714000015
),
                   "cleansheets" = c(1, 0, 
                                     0.211000004
                                     #0.352999992,
                                     #0.555999985
                                     #0.540999985
                                     #0.412000008
                                     #0.420999985
                   ),
                   "passes 15 yards" = c(1, 0, 
                                         0.548672566
                                         #0.800884956,
                                         #0.800884956
                                         #0.876106195
                                         #0.995575221
                                         #0.871681416
                   ),
                   "passes 40 yards" = c(1, 0, 
                                         0.435736677
                                         #0.551724138,
                                         #0.586206897
                                         #0.485893417
                                         #0.357366771
                                         #0.498432602
                   ),
                   "pressured passes" = c(1, 0, 
                                          0.521367521
                                          #0.752136752,
                                          #0.820512821
                                          #0.794871795
                                          #0.905982906
                                          #0.495726496
                   ),
                   "sweep outside box" = c(1, 0, 
                                           0.142857143
                                           #0.555555556,
                                           #1
                                           #0.53968254
                                           #0.301587302
                                           #0.365079365
                   ),
                   row.names = c("max", "min", 
                                 "David de Gea"
                                 #"Aaron Ramsdale",
                                 #"Alisson"
                                 #"Ederson"
                                 #"Edouard Mendy"
                                 #"Hugo Lloris"
                   ))

# Define fill colors
colors_fill <- c(scales::alpha("gray", 0.4))
                 #scales::alpha("gold", 0))

# Define line colors
colors_line <- c(scales::alpha("gray", 0.9))
                 #scales::alpha("red", 1))

# Create plot
radarchart(data,
           axistype = 1,
           seg = 5,  # Number of axis segments
           title = "David de Gea",
           pcol = colors_line,
           pfcol = colors_fill,
           plwd = 2,
           cglcol="gray", cglty=1, axislabcol="black", caxislabels=seq(0,1,0.2), cglwd=0.8,
           vlcex = 1
           )