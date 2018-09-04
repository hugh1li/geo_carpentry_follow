source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")

library(rhdf5)
library(raster)
library(rhdf5)
library(rgdal)


f <- 'data/NEONDSImagingSpectrometerData.h5'

h5ls(f, all = T)

spInfo <- h5readAttributes(f, 'spatialInfo') 
refInfo <- h5readAttributes(f, 'Reflectance')
wavelengths <- h5read(f, 'wavelength')

temp <- h5readAttributes(f, 'wavelength')

nRows <- refInfo$row_col_band[1]
nCols <- refInfo$row_col_band[2]
nBands <- refInfo$row_col_band[3]

b34 <- h5read(f, 'Reflectance', index = list(1:nCols, 1:nRows, 34))

dim(b34)

class(b34)

b34 <- b34[, , 1]

class(b34)

h5readAttributes(f, 'Reflectance')

image(b34)

image(log(b34))


hist(b34, breaks = 40, col = 'darkmagenta')

hist(b34, breaks= 40, col = 'darkmagenta', xlim = c(0, 5000))

hist(b34, breaks= 40, col = 'darkmagenta', xlim = c(5000, 15000), ylim = c(0, 100))

myNoDataValue <- as.numeric(refInfo$`data ignore value`)

myNoDataValue


b34[b34 == myNoDataValue] <- NA

image(b34)

image(log(b34))

b34 <- t(b34)

image(log(b34), main = 'Transposed Image')

mapInfo <- h5read(f, 'map info')

mapInfo <- unlist(strsplit(mapInfo, ','))

mapInfo

myCRS <- spInfo$projdef

myCRS

b34r <- raster(b34, crs = myCRS)

b34r
image(log(b34r), xlab  = 'UTM Easting', ylab = 'UTM Northing', main = 'Properly Positioned Raster')

res <- spInfo$xscale

res

xMin <- as.numeric(mapInfo[4])
yMax <- as.numeric(mapInfo[5])
xMin
yMax

xMax <- (xMin + (ncol(b34)) * res)
yMin <- (yMax - (nrow(b34)) * res)

xMax
yMin

rasExt <- extent(xMin, xMax, yMin, yMax)
rasExt

extent(b34r) <- rasExt

b34r

col <- terrain.colors(25)

image(b34r, xlab = 'UTM Easting', ylab ='UTM Northing', main = 'Raster w Custom Colors',  col = col, zlim = c(0, 3000))


writeRaster(b34r, file = 'band34.tif', format = 'GTiff', overwrite = TRUE)

H5close()

# create other rasters

raster2 <- h5read(f, 'Reflectance', index = list(1:nCols, 1:nRows, 34))

aPixel<- h5read(f,"Reflectance",index=list(54,36,NULL))


b46 <- h5read(f, 'Reflectance', index = list(1:nCols, 1:nRows, 46))
b46 <- b46[, , 1]
image(b46)
image(log(b46))

#Q2: vary distribution of values
b34 <- b34[, , 1]
class(b34)

b34[b34 > 6000] <- 10000
image(b34)
image(log(b34))
