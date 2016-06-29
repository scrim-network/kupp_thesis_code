# -----------------------------------------------------------------------
# CaitlinKupp_code_Appendix1.R
# -----------------------------------------------------------------------
# Appendix 1. This is a script for plotting figures of the progression of sea-level rise
# scenarios of 0.5-1.5 m for Midway Island. This can be changed to read in other digital
# elevation models.
# Reads in a DEM (probably for an island threatened by sea-level rise) and shows progression of inundation 
# from 0.5-1.5 meters of sea-level rise
# Change the working directory. Your directory should contain the
# unzipped data set.
# -----------------------------------------------------------------------
# Collaboration w/ Dr. Patrick Applegate, Dr. Greg Garner, and Dr. Klaus Keller at Penn state
# -----------------------------------------------------------------------
# Author: Caitlin Kupp; cik5134@psu.edu 
# Writen: Spring 2015
# -----------------------------------------------------------------------
# install.packages("fields")

#setwd('C:/Documents/Midway_Atoll_v2_DEM_4373')
# Uncomment the following line to read in the data.
# data = read.table('midway_1_3s_v2.asc', skip = 6) # v2
data = read.table('Midway_Atoll_v2_DEM_4373/midway_1_3s_v2.asc', skip = 6)

#Change this script so that it automatically converts
# the values in the data file, which are in meters above Mean High Water,
# to meters above mean sea level.
#http://tidesandcurrents.noaa.gov/datums.html?units=1&epoch=0&id=1619910&name=Sand+Island%2C+Midway+Islands&state=
MHW = 1.152; MSL = 1.020

# Set some values.
is_name = 'Midway' # name of island
#is_name = 'San Francisco Bay' # name of island
MHW2MSL = MHW - MSL # MHW2MSL = 0.132 convert from mean height water to mean sea-level
dem_res = 10 # m; horizontal resolution of the DEM
sl_rise = seq(0.5, 2, by = 0.5)

#convert MHW to MSL
data = data - MHW2MSL

# Define the latitude and longitude grid for the DEM.
# See xml file accompanied with the data.
lat <- seq(28.09, 28.42, l=3565)
lon <- seq(-177.57, -177.16, l=4429)

# Rotate the matrix so that it has the correct orientation. Uses code
# from http://stackoverflow.com/questions/16496210/rotate-a-matrixin-r
rot_data = as.matrix(t(data[nrow(data): 1, ]))

# Find the extent, in the x and y directions, of the land above sea-level.
which_land = which(rot_data > 0, arr.ind = TRUE)
min_x = min(which_land[, 2])
max_x = max(which_land[, 2])
min_y = min(which_land[, 1])
max_y = max(which_land[, 1])

# Subset the data set so that it defines the smallest rectangle that includes
# all points above sea level.
sub_data = rot_data[seq(min_y, max_y, by = 1), seq(min_x, max_x, by = 1)]

# Subset the latitudes and longitudes to match the subset of data
# above. Note that the data have been rotated, so the latitudes
# should span the x-range and longitudes span the y-range
sub_lat <- lat[min_x:max_x]
sub_lon <- lon[min_y:max_y]

# How many grid cells are there in the x and y directions?
n_x = length(sub_data[ ,1])
n_y = length(sub_data[1, ])

# Create x and y vectors for plotting.
grid_x = seq(0.5* dem_res, by = dem_res, length.out = n_x)
grid_y = seq(0.5* dem_res, by = dem_res, length.out = n_y)

# Create the ocean color ramp palette
my.blues <- colorRampPalette(colors = c("darkblue", "lightblue"))

# Create the vector of colors for...
# ...plotting
plot.cols <- c(my.blues(100), terrain.colors(100))
# ...colorbar
bar.cols <- c(my.blues(100), terrain.colors(400))

# Define the custom breaks for plotting the ocean
# and the terrain
# Ocean = [-30, 0], Land = (0, 12]
plot.breaks <- c(seq(-30,0,l=100), seq(0,12,l=102)[-1])
plot.breaks <- c(seq(-30,0,l=100), seq(0,100,l=102)[-1]) #SFB

# Plot the results.
# Load 'fields' library
library(fields)
# Rasterized version of plot
png("midway_slr_plot.png", w=4250, h=3500, res=500)

#No SLR
par(fig=c(0,0.5,0.575,1), mar=c(4,4,2,1)+0.1)
temp.data <- sub_data
temp.data[temp.data < -30] <- -30
image(x=sub_lon, y=sub_lat, z=temp.data, col=plot.cols,
      breaks=plot.breaks,
      main = "No SLR", xlab="Longitude [deg E]", ylab="Latitude [deg N]")

#0.5 M SLR
par(fig=c(0.5,1,0.575,1), mar=c(4,4,2,1)+0.1, new=T)
temp.data <- sub_data - 0.5
temp.data[temp.data < -30] <- -30
image(x=sub_lon, y=sub_lat, z=temp.data, col=plot.cols,
      breaks=plot.breaks,
      main = "0.5 Meter SLR", xlab="Longitude [deg E]",
      ylab="Latitude [deg N]")

#1 M SLR
par(fig=c(0,0.5,0.15,0.575), mar=c(4,4,2,1)+0.1, new=T)
temp.data <- sub_data - 1.0
temp.data[temp.data < -30] <- -30
image(x=sub_lon, y=sub_lat, z=temp.data, col=plot.cols,
      breaks=plot.breaks,
      main = "1.0 Meter SLR", xlab="Longitude [deg E]",
      ylab="Latitude [deg N]")

#1.5 M SLR
par(fig=c(0.5,1,0.15,0.575), mar=c(4,4,2,1)+0.1, new=T)
temp.data <- sub_data - 1.5
temp.data[temp.data < -30] <- -30
image(x=sub_lon, y=sub_lat, z=temp.data, col=plot.cols,
      breaks=plot.breaks, main = "1.5 Meter SLR", xlab="Longitude [deg E]", ylab="Latitude [deg N]")

# Put the legend at the bottom of the multi-panel figure
par(fig=c(0,1,0,1), new=T)
image.plot(zlim=c(0,5), legend.only=T,
           col=bar.cols, legend.shrink = 0.75,
           legend.width = 0.8, horizontal = TRUE,
           axis.args=list(at=seq(0,5,l=6), labels=c("< -30 m", "0m", "3 m", "6m", "9 m", "12 m")))
dev.off()
# -----------------------------------------------------------------------
