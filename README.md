# Preamble

The code in this repository was taken from Appendices 1 and 2 of Caitlin Kupp's senior thesis in the Department of Geosciences at the Pennsylvania State University.  

> Kupp, C.  Contrasting inundation patterns of two Pacific islands under sea-level rise.  Senior thesis, Department of Geosciences, The Pennsylvania State University, 32 pp.  

The thesis investigates the potential effects of sea-level rise on islands in the Pacific, particularly coral atoll islands such as the Midway Islands.  

Caitlin's thesis work was supervised by Profs. Klaus Keller and Peter Heaney in the Department of Geosciences, and by Patrick Applegate, a Research Associate in the Earth and Environmental Systems Institute.  

Patrick Applegate and Greg Garner contributed to Caitlin's code.  Kelsey Ruckert formatted the code, as copied from the thesis, so that it would run in R.  Greg Garner is a Postdoctoral Scholar and Kelsey Ruckert is a Scientific Programmer, both also in the Earth and Environmental Systems Institute.  

# Contents

* `caitlin_thesis.pdf`: Caitlin's thesis (posted here with her permission)
* `abstract.md`: abstract for thesis
* `CaitlinKupp_code_Appendix1.R`: Makes maps showing the progressive inundation of the island in question
* `CaitlinKupp_code_Appendix2.R`: Makes a cumulative density figure and a table showing the fraction of the island in question that will be covered by various amounts of sea-level rise

# Requirements

## Software

These scripts were tested under R v3.3.0 (https://www.r-project.org/).  They also require the `fields` package (tested using v8.4-1).  You can install the `fields` package in R using the command `install.packages("fields")`.  The R integrated development environment RStudio (https://www.rstudio.com/) is optional, but highly recommended.  

## Data

These scripts require a digital elevation model (DEM) of island topography and the surrounding bathymetry in order to work.  The figures in Caitlin's thesis are based on 1/3 arc-second DEMs for the Midway Islands and Oahu.  These DEMs were developed by NOAA.  You can download these DEMs from the following URLs.  

Midway Islands: http://www.ngdc.noaa.gov/dem/squareCellGrid/download/4372  
Oahu: http://www.ngdc.noaa.gov/dem/squareCellGrid/download/3410

The unzipped files should be ESRI ArcGrid ASCII files.  You can find a description of this file format on Wikipedia at https://en.wikipedia.org/wiki/Esri_grid

You'll also need to know the difference in height between mean high water (MHW) and mean sea level (MSL) at the island of interest.  At the Midway Islands, this difference is 0.132 m.  

# Instructions

* Download a `.zip` file containing the DEM of interest into the same directory as the R scripts.
* Unzip the `.zip` file.
* Open the `.R` files in R or RStudio.  Change the path in the `read.table` command in both `.R` files so that it points to the `.asc` file.  
* Also in the `.R` files, change the `MHW2MSL` variable to correspond to the difference between mean high water and mean sea level at the island of interest.  
* Source the `.R` files.  

