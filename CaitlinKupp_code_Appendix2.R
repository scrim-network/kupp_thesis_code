# -----------------------------------------------------------------------
# CaitlinKupp_code_Appendix2.R
# -----------------------------------------------------------------------
# Appendix 2. This is a script for sea-level rise scenarios of 0.5-2, plotting a cumulative
# density function of Midway, and making a table of the results. This can be changed to
# read in other digital elevation models.
# Reads in a DEM (probably for an island threatened by sea level rise),
# calculates the area that will be covered by different amounts of
# sea level rise, makes a table of the results, and plots the CDF.
# Change this script so that it automatically converts
# the values in the data file, which are in meters above Mean High Water,
# to meters above mean sea level.
# -----------------------------------------------------------------------
# Collaboration w/ Dr. Patrick Applegate, Dr. Greg Garner, and Dr. Klaus Keller at Penn state
# -----------------------------------------------------------------------
# Author: Caitlin Kupp; cik5134@psu.edu 
# Writen: Spring 2015
# -----------------------------------------------------------------------

# http://tidesandcurrents.noaa.gov/datums.html?units=1&epoch=0&id=1619910&name=Sand+Island%2C+Midway+Islands&state=
#MHW = 1.152, MSL = 1.020
# Mise en place.
# Clear variables and figures.
rm(list = ls())
graphics.off()

# Change the working directory. Your directory should contain the
# unzipped data set.
# setwd('C:/Documents/Midway_Atoll_v2_DEM_4373')
# Set some values.
is_name = 'Midway' # name of island
MHW2MSL = 0.132
dem_res = 10 # m; horizontal resolution of the DEM
sl_rise = seq(0.5, 2, by = 0.5)

# m of sea level rise
# Read in the data. You may need to change the file name to get this script
# to work.
# data = read.table('Midway_Atoll_DEM_1107/midway_atoll_1_3s.asc',skip = 6) # v1 -- wrong
# data = read.table('Midway_Atoll_v2_DEM_4373/midway_1_3s_v2.asc', skip = 6)
data = read.table('Midway_Atoll_v2_DEM_4373/midway_1_3s_v2.asc', skip = 6) # v2

#convert MHW to MSL
data = data - MHW2MSL

# Rotate the matrix so that it has the correct orientation. Uses code
# from http://stackoverflow.com/questions/16496210/rotate-a-matrixin-r
rot90_data = as.matrix(t(data[nrow(data): 1, ]))

# Find the extent, in the x and y directions, of the land above sea level.
which_land = which(rot90_data > 0, arr.ind = TRUE)
min_x = min(which_land[, 2])
max_x = max(which_land[, 2])
min_y = min(which_land[, 1])
max_y = max(which_land[, 1])
# Subset the data set so that it defines the smallest rectangle that includes
# all points above sea level. Also set all water-covered points to NAs.
sub_data = rot90_data[seq(min_y, max_y, by = 1), seq(min_x, max_x, by = 1)]
sub_data[sub_data < 0] = NA
# How many grid cells are there in the x and y directions?
n_x = length(sub_data[, 1])
n_y = length(sub_data[1, ])
# Create x and y vectors for plotting.
grid_x = seq(0.5* dem_res, by = dem_res, length.out = n_x)
grid_y = seq(0.5* dem_res, by = dem_res, length.out = n_y)

# Identify the fraction of the total island area covered by water for the
# different values in sl_rise.
elev_ecdf = ecdf(sub_data)
frac_cover = elev_ecdf(sl_rise)
# Estimate the total island area (remember to compare this estimate to
# Wikipedia or some other source as a check).
tot_area = dem_res^2* sum(sub_data > 0, na.rm = TRUE)
# Calculate the area covered by various amounts of sea level rise.
area_cover = tot_area* frac_cover
# Print off a table relating sea level rise to the fraction of the
# island covered and the area covered.
out_table = matrix(cbind(sl_rise, frac_cover, area_cover), byrow =
                     FALSE, nrow = length(sl_rise), ncol = 3, 
                   dimnames = list(NULL,c('Sea level rise [m]', 'Fraction of area covered', 'Area covered [m^2]')))
print(out_table)
# Save the table to a file.
table_file = sprintf('%s_table.txt', is_name)
write.csv(out_table, table_file, row.names = FALSE)
# Plot the results.
fig_file = sprintf('%s_figures.pdf', is_name)
pdf(fig_file)
# par(pty = 's')
plot.ecdf(sub_data, xlab = 'Height above Mean Sea Level [m]', ylab ='Cumulative density', main = is_name, 
          xlim = range(sub_data, na.rm = TRUE))
segments(x0 = sl_rise, x1 = sl_rise, y0 = rep(0, length(sl_rise)),
         y1 = frac_cover, lty = 2)
segments(x0 = sl_rise, x1 = rep(0, length(sl_rise)), y0 =
           frac_cover, y1 = frac_cover, lty = 2)
dev.off()
# -----------------------------------------------------------------------
