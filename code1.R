library(raster)
library(rgdal)
library(tidyverse)

GDALinfo('data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif')
HARV_dsmCrop_info <- capture.output(
  GDALinfo("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
)

DSM_HARV <- raster('data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif')
DSM_HARV

summary(DSM_HARV)

DSM_HARV_df <- as.data.frame(DSM_HARV, xy = TRUE)

str(DSM_HARV_df)

ggplot() + geom_raster(data = DSM_HARV_df, aes( x= x , y = y, fill = HARV_dsmCrop)) + scale_fill_viridis_c() + coord_quickmap()

crs(DSM_HARV)
minValue(DSM_HARV)
maxValue(DSM_HARV)
DSM_HARV <- setMinMax(DSM_HARV)

nlayers(DSM_HARV)

GDALinfo('data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif')

ggplot() + geom_histogram(data = DSM_HARV_df, aes(HARV_dsmCrop), bins = 40)


GDALinfo('data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif')

GDALinfo('data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif')

DSM_HARV_df <- DSM_HARV_df %>% mutate(fct_elevation = cut(HARV_dsmCrop, breaks= 3))
ggplot() + geom_bar(data = DSM_HARV_df, aes(fct_elevation))

DSM_HARV_df %>% group_by(fct_elevation) %>% summarize(counts = n())
custom_bins <- c(300, 350, 400, 450)
DSM_HARV_df <- DSM_HARV_df %>% mutate(fct_elevation_2 = cut(HARV_dsmCrop, breaks = custom_bins))
unique(DSM_HARV_df$fct_elevation_2)

ggplot() + geom_bar(data = DSM_HARV_df, aes(fct_elevation_2))

DSM_HARV_df %>% group_by(fct_elevation_2) %>% summarize(counts = n())

ggplot() + geom_raster(data = DSM_HARV_df, aes(x = x , y = y, fill = fct_elevation_2)) + coord_quickmap()

terrain.colors(3)

ggplot() + geom_raster(data = DSM_HARV_df, aes(x = x, y = y, fill = fct_elevation_2)) + scale_fill_manual(values = terrain.colors(3)) + coord_quickmap()

my_col <- terrain.colors(3)

ggplot() + geom_raster(data = DSM_HARV_df, aes(x = x, y = y, fill = fct_elevation_2)) + scale_fill_manual(values = my_col, name = 'Elevation') + coord_quickmap()

ggplot() + geom_raster(data = DSM_HARV_df, aes( x= x, y = y, fill = fct_elevation_2))  + scale_fill_manual(values = my_col, name = 'Elevation')  + theme(axis.title.x = element_blank(), axis.title.y = element_blank()) + coord_quickmap()

