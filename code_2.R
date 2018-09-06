library(tidyverse)
library(raster)

DSM_SJER <- raster('data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif')

DSM_SJER_df <- as.data.frame(DSM_SJER, xy = TRUE)

DSM_hill_SJER <- raster('data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmHill.tif')

DSM_hill_SJER_df <- as.data.frame(DSM_hill_SJER, xy = TRUE)

ggplot() + geom_raster(data= DSM_SJER_df, aes(x = x, y =  y, fill = SJER_dsmCrop, alpha = 0.8)) + geom_raster(data = DSM_hill_SJER_df, aes(x =x , y = y, alpha = SJER_dsmHill)) + scale_fill_viridis_c() + guides(fill = guide_colorbar()) + scale_alpha(range= c(0.4, 0.7), guide = 'none') + theme_bw()  + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + xlab('UTM Westing Coordinate (m)') + ylab('UTM Northing Coordinate (m)') + ggtitle('DSM with Hillshade') + coord_quickmap()


DTM_SJER <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmCrop.tif")
DTM_SJER_df <- as.data.frame(DTM_SJER, xy = TRUE)

# DTM Hillshade
DTM_hill_SJER <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DTM/SJER_dtmHill.tif")
DTM_hill_SJER_df <- as.data.frame(DTM_hill_SJER, xy = TRUE)

ggplot() + geom_raster(data  = DTM_SJER_df, aes( x= x, y = y, fill = SJER_dtmCrop, alpha= 2.0)) + geom_raster(data = DTM_hill_SJER_df, aes( x= x, y = y, alpha = SJER_dtmHill)) + scale_fill_viridis_c() + guides(fill = guide_colorbar()) + scale_alpha(range = c(0.4, 0.7), guide = 'none') +theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(axis.title.x = element_blank(), axis.title.y = element_blank()) + ggtitle("DTM with Hillshade") + coord_quickmap()

##### projecting raster data
DTM_HARV <- raster('data/NEON-DS-Airborne-Remote-Sensing/harv/dtm/HARV_dtmCrop.tif')

DTM_hill_HARV <- raster('data/NEON-DS-Airborne-Remote-Sensing/harv/dtm/HARV_DTMhill_WGS84.tif')

DTM_HARV_df <- as.data.frame(DTM_HARV, xy = TRUE)

DTM_hill_HARV_df <- as.data.frame(DTM_hill_HARV, xy = TRUE)

ggplot() + geom_raster(data = DTM_hill_HARV_df, aes(x = x, y =y, alpha = HARV_DTMhill_WGS84)) + geom_raster(data = DTM_HARV_df, aes( x= x, y = y, fill = HARV_dtmCrop, alpha = 0.8)) + scale_fill_gradientn(name= 'Elevation', colors = terrain.colors(10))+ guides(fill = guide_colorbar()) + scale_alpha( range = c(0.25, 0.65), guide = 'none') + coord_quickmap()

# check CRS
raster::crs(DTM_hill_HARV)
raster::crs(DTM_HARV)


DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, crs = crs(DTM_HARV))

crs(DTM_hill_UTMZ18N_HARV)

extent(DTM_hill_UTMZ18N_HARV)

extent(DTM_hill_HARV)

res(DTM_hill_UTMZ18N_HARV)

res(DTM_hill_HARV)

DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, crs = crs(DTM_HARV), res = 1)

res(DTM_hill_UTMZ18N_HARV)

DTM_hill_HARV_2_df <- as.data.frame(DTM_hill_UTMZ18N_HARV, xy = TRUE)

ggplot() + geom_raster(data = DTM_HARV_df, aes(x = x, y = y, fill = HARV_dtmCrop)) + geom_raster(data = DTM_hill_HARV_2_df, aes(x = x, y = y, alpha = HARV_DTMhill_WGS84)) + scale_fill_gradientn(name = 'Elevation', colors = terrain.colors(10)) + coord_quickmap()

# challenge
# create a amap of 
SJER1 <- raster('data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_DSMhill_WGS84.tif')

SJER2 <- raster("data/NEON-DS-Airborne-Remote-Sensing/SJER/DSM/SJER_dsmCrop.tif")

# check crs
crs(SJER1)
crs(SJER2)

plot(SJER1)
plot(SJER2)

SJER2_2 <- projectRaster(SJER2, crs = crs(SJER1))

SJER1_df <- as.data.frame(SJER1, xy = TRUE)
SJER2_df <- as.data.frame(SJER2_2, xy = TRUE)

ggplot() + geom_raster(data = SJER1_df, aes(x = x, y = y, fill = SJER_DSMhill_WGS84)) + coord_quickmap()

##### raster calculation
library(rgdal)
GDALinfo('data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif')
GDALinfo('data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif')
                       
ggplot() + geom_raster(data = DTM_HARV_df, aes(x= x, y = y, fill = HARV_dtmCrop)) + scale_fill_gradientn(name = 'Elevation', colors= terrain.colors(10))+ coord_quickmap()

DTM_HARV <- raster('data/NEON-DS-Airborne-Remote-Sensing/harv/dtm/HARV_dtmCrop.tif')

DSM_HARV <- raster('data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif')

CHM_HARV <- DSM_HARV - DTM_HARV

CHM_HARV_df <- as.data.frame(CHM_HARV, xy = TRUE)

ggplot() + geom_raster(data = CHM_HARV_df, aes(x =x, y = y, fill = layer)) + scale_fill_gradientn(name = 'Canopy Height', colors = terrain.colors(10)) + coord_quickmap()

ggplot(CHM_HARV_df) + geom_histogram(aes(layer), bins = 6)

raster::minValue(CHM_HARV)
raster::maxValue(CHM_HARV)                   

CHM_ov_HARV <- overlay(DSM_HARV, DTM_HARV, fun = function(r1, r2){return(r1 - r2)})

CHM_ov_HARV_df <- as.data.frame(CHM_ov_HARV, xy =TRUE)

ggplot() + geom_raster(data =  CHM_ov_HARV_df, aes( x= x, y = y, fill = layer)) + scale_fill_gradientn(name = 'Canopy Height', colors  = terrain.colors(10)) + coord_quickmap()

writeRaster(CHM_ov_HARV, 'CHM_HARV.tiff', format = 'GTiff', overwrite = TRUE, NAflag = -9999) 

##### working with multi bands
RGB_band1_HARV <- raster('data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif')

RGB_band1_HARV_df <- as.data.frame(RGB_band1_HARV, xy = TRUE)

# ggplot() + geom_raster(data = RGB_band1_HARV_df, aes(x = x, y =y, alpha = HARV_RGB_Ortho)) + coord_quickmap()
library(sf)
library(rgdal)
GDALinfo(RGB_band1_HARV_DF)

RGB_band1_HARV

RGB_band2_HARV <- raster('data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif', band = 2)

RGB_band2_HARV_df <- as.data.frame(RGB_band2_HARV, xy = TRUE)

RGB_stack_HARV <- stack('data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif')

RGB_stack_HARV

RGB_stack_HARV@layers

RGB_stack_HARV[[2]]

temp <- stack('data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif')

temp
library(rgdal)
GDALinfo('data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif')

object.size(RGB_stack_HARV)

RGB_brick_HARV <- brick(RGB_stack_HARV)
object.size(RGB_brick_HARV)

methods(class = class(RGB_stack_HARV))

methods(class= class(RGB_stack_HARV[1]))

# open and plot shapefiles in R----
library(sf)

aoi_boundary_HARV <- st_read('data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp')

st_geometry_type(aoi_boundary_HARV)

st_crs(aoi_boundary_HARV)

st_bbox(aoi_boundary_HARV)

library(tidyverse)
ggplot() + geom_sf(data = aoi_boundary_HARV, size = 3, color = 'black', fill ='cyan1') + ggtitle('AOI Boundary plot') + coord_sf()

# challenges
temp1 <- st_read('data/NEON-DS-Site-Layout-Files/HARV/HARV_roads.shp')
temp2 <- st_read('data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp')

class(temp1)
class(temp2)

names(temp1)
names(temp2)

ncol(aoi_boundary_HARV)
ncol(temp2)
temp2$Ownership

names(temp2)

temp1$TYPE
levels(temp1$TYPE)

footpath_HARV <- temp1 %>% filter(TYPE == 'footpath')
nrow(footpath_HARV)

ggplot() + geom_sf(data = footpath_HARV) + ggtitle('NEON Harvard Forest Field Site', subtitle = 'Footpaths') + coord_sf()

ggplot() +geom_sf(data = footpath_HARV, aes(color = factor(OBJECTID)), size= 1.5) + labs(color = 'Footpath ID') + ggtitle('neon harvard forest field site', subtitle = 'footpaths') + coord_sf()

stone_wall <- temp1 %>% filter(TYPE == 'stone wall')
ggplot() + geom_sf(data = stone_wall, aes(color = factor(OBJECTID)))


boardwalk <- temp1 %>% filter(TYPE == 'boardwalk')
ggplot() + geom_sf(data = boardwalk)

levels(temp1$TYPE)
road_colors <- c('blue', 'green', 'navy', 'purple')
ggplot()+ geom_sf(data  = temp1, aes(color = TYPE)) + scale_color_manual(values  = road_colors) + labs(color = 'Road Type') + ggtitle("NEON harvard forest field site", subtitle= 'roads & trails') + coord_sf()

line_widths <- c(1, 2, 3, 4)
ggplot() +
  geom_sf(data = temp1, aes(color = TYPE, size = TYPE)) + 
  scale_color_manual(values = road_colors) +
  labs(color = 'Road Type') +
  scale_size_manual(values = line_widths) +
  ggtitle("NEON Harvard Forest Field Site", subtitle = "Roads & Trails - Line width varies") + 
  coord_sf()

line_widths <- c(1, 3, 2, 6)

ggplot() + geom_sf(data = temp1, aes(color = TYPE), size = 1.5) + scale_color_manual(values = road_colors) + labs(color = 'road type') + ggtitle('neon harvard forest field site', subtitle = 'roads & trails') + coord_sf() + theme(legend.text = element_text(size = 20), legend.box.background = element_rect(size = 1))

new_colors <- c('springgreen', 'blue', 'magenta', 'orange')

temp1$BicyclesHo


temp3 <- st_read('data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-State-Boundaries-Census-2014.shp')

ggplot() + geom_sf(data = temp3, aes(fill = region))+coord_sf()


# putting multiple shapefiles ---------------------------------------------

ggplot()+ geom_sf(data = aoi_boundary_HARV, fill = 'grey', color = 'grey') + geom_sf(data = temp1, aes(color = TYPE),  size =1, show.legend = 'line' ) + geom_sf(data = temp2) + ggtitle('neon harvard forest field site') + coord_sf()

ggplot() + geom_sf(data = aoi_boundary_HARV, fill = 'grey', color ='grey') + geom_sf(data = temp2, aes(fill = Sub_Type)) + geom_sf(data = temp1, aes(color = TYPE), show.legend = 'line', size= 1) + scale_color_manual(values = road_colors, name= 'Line Type') + scale_fill_manual(values= 'black', name = 'Tower Location') + ggtitle('NEON Harvard Forest Field Site')+ coord_sf()


ggplot() + geom_sf(data = aoi_boundary_HARV, fill = 'grey', color = 'grey') + geom_sf(data = temp2, aes(fill = Sub_Type), shape = 15) + geom_sf(data = temp1, aes(color = TYPE), show.legend =  'line', size = 1) + scale_color_manual(values = road_colors, name = 'Line Type') + scale_fill_manual(values = 'black', name = 'Tower Location') + ggtitle("NEON Harvard Forest Field Site") + coord_sf()

# challenge
temp4 <- st_read('data/NEON-DS-Site-Layout-Files/HARV/PlotLocations_HARV.shp')
ggplot() + geom_sf(data = temp1) + geom_sf(data = temp4, aes(color = soilTypeOr), shape = 6)+ coord_sf()


# handling spatial projection ---------------------------------------------

state_boundary_US <- st_read('data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-State-Boundaries-Census-2014.shp')

ggplot() + geom_sf(data = state_boundary_US) + ggtitle('Map of Contiguous US State Boundaries') + coord_sf()

country_boundary_US <- st_read('data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/US-Boundary-Dissolved-States.shp')

ggplot() + geom_sf(data = country_boundary_US, color = 'grey18', size = 2) + geom_sf(data= state_boundary_US, color = 'grey40') + ggtitle('Map of Contiguous US State Boundaries') + coord_sf()

st_crs(temp1)
st_crs(state_boundary_US)

st_crs(country_boundary_US)

st_bbox(temp1)
st_bbox(temp2)

st_bbox(state_boundary_US)

ggplot() + geom_sf(data = country_boundary_US, size = 2, color = 'grey18') + geom_sf(data = state_boundary_US, color = 'grey40') + geom_sf(data = temp1, shape = 19, color = 'purple') + ggtitle('Map of Contiguous US State Boundaries') + coord_sf()

temp5 <- st_read('data/NEON-DS-Site-Layout-Files/US-Boundary-Layers/Boundary-US-State-NEast.shp')

ggplot() + geom_sf(data = temp5, aes(color = NAME)) + geom_sf(data = temp2) + ggtitle('lul')  
ggplot() + geom_sf(data = temp5, aes(color = 'color'), show.legend = 'line') + scale_color_manual(name = '', labels = 'State Boundary', values = c('color'= 'gray18')) + geom_sf(data= temp2, aes(shape  = 'shape') , color= 'purple') + scale_shape_manual(name = '', labels ='Fisher Tower', values = c('shape' = 19)) + ggtitle('Fisher Tower location') + theme(legend.background =  element_rect(color = NA)) +coord_sf()


# csv to shapefiele -------------------------------------------------------

plot_location_HARV <- read.csv('data/NEON-DS-Site-Layout-Files/HARV/HARV_PlotLocations.csv')

str(plot_location_HARV)
plot_locations_HARV <- plot_location_HARV
names(plot_locations_HARV)

head(plot_locations_HARV$easting)

head(plot_location_HARV$geodeticDa)

utm18nCRS <- st_crs(temp2)

class(utm18nCRS)

plot_locations_sp_HARV <- st_as_sf(plot_locations_HARV, coords = c('easting', 'northing'), crs= utm18nCRS)
st_crs(plot_locations_sp_HARV)
ggplot() + geom_sf(data = plot_locations_sp_HARV) + ggtitle('Map of Plot Locations')

ggplot() + geom_sf(data = aoi_boundary_HARV) + geom_sf(data = plot_locations_sp_HARV) + ggtitle('AOI boundary plot')

temp6 <- read.csv('data/NEON-DS-Site-Layout-Files/HARV/HARV_2NewPhenPlots.csv')

names(temp6)

head(temp6)

temp6_sf <- st_as_sf(temp6, coords = c('decimalLon', 'decimalLat'), crs = st_crs(country_boundary_US)) 

ggplot() + geom_sf(data = temp6_sf, aes(color = 'red'))  + geom_sf(data = plot_locations_sp_HARV, color = 'blue')+ coord_sf()

st_write(plot_locations_sp_HARV, 'data/plotlocations_harv.shp', driver = 'Esri Shapefile')


# manupulating rater data in R --------------------------------------------

ggplot() + geom_raster(data = CHM_ov_HARV_df, aes(x = x, y = y, fill = HARV_chmCrop)) + scale_fill_gradientn(name = 'Canopy Height', colors = terrain.colors(10)) + geom_sf(data = aoi_boundary_HARV, color = 'blue', fill = NA) + coord_sf()

CHM_HARV_Cropped <- crop(x= CHM_HARV, y = as(aoi_boundary_HARV, 'Spatial'))

CHM_HARV_Cropped_df <- as.data.frame(CHM_HARV_Cropped, xy = TRUE)
ggplot() + geom_sf(data= st_as_sfc(st_bbox(CHM_HARV_sp)), fill = 'green', color = 'green', alpha = .2) + geom_raster(data = CHM_HARV_Cropped_df, aes(x= x, y =y, fill = HARV_chmCrop)) + scale_fill_gradientn(name = 'Canopy Height', colors = terrain.colors(10)) + coord_sf()

ggplot()+ geom_raster(data= CHM_HARV_Cropped_df, aes( x= x, y = y, fill = HARV_chmCrop)) + geom_sf(data= aoi_boundary_HARV, color = 'blue', fill = NA) + scale_fill_gradientn(name = 'canopy height', colors= terrain.colors(10)) + coord_sf()

new_extent <- extent(732161.2, 732238.7, 4713249, 4713333)
class(new_extent)

CHM_HARV_manual_cropped <- crop(x = CHM_HARV, y = new_extent)
CHM_HARV_manual_cropped_df <- as.data.frame(CHM_HARV_manual_cropped, xy = TRUE)
ggplot() +geom_sf(data = aoi_boundary_HAR, color = 'blue', fill = NA) + geom_raster(data = CHM_HARV_manual_cropped_df, aes(x =x , y = y, fill = HARV_chmCrop)) + scale_fill_gradientn(name = 'canopy height', colors = terrain.colors(10)) + coord_sf()

tree_height <- extract( x= CHM_HARV, y = as(aoi_boundary_HARV, 'Spatial'), df = TRUE)
str(tree_height)

mean_tree_height_AOI <- extract(x = CHM_HARV, y  = as(aoi_boundary_HARV, 'Spatial'), fun = mean)

mean_tree_height_tower <- extract(x = CHM_HARV, y = as(temp1, 'Spatial'), buffer  =20, fun = mean)

mean_tree_height_plots_harv <- extract(x = CHM_HARV, y = as(plot_locations_sp_HARV, 'Spatial'), buffer = 20,  fun = mean, df = TRUE)


# raster time series ------------------------------------------------------
library(rgdal)
library(reshape)
library(scales)

NDVI_HARV_path <- "data/NEON-DS-Landsat-NDVI/HARV/2011/NDVI"
all_NDVI_HARV <- list.files(NDVI_HARV_path, full.names = TRUE, pattern = '.tif$')

NDVI_HARV_stack <- stack(all_NDVI_HARV)

crs(NDVI_HARV_stack)

NDVI_HARV_stack_df <- as.data.frame(NDVI_HARV_stack, xy = TRUE) %>% melt(id.vars = c('x', 'y'))

ggplot() + geom_raster(data = NDVI_HARV_stack_df, aes( x= x, y = y, fill = value))  + facet_wrap(~variable)

NDVI_HARV_stack <- NDVI_HARV_stack/10000

temp7 <- as.data.frame(NDVI_HARV_stack, xy = TRUE)

NDVI_HARV_stack_df <- as.data.frame(NDVI_HARV_stack, xy = TRUE) %>%
  melt(id.vars = c('x','y'))
names(NDVI_HARV_stack_df)

ggplot(NDVI_HARV_stack_df) + geom_histogram(aes(value)) + facet_wrap(~variable)

har_met_daily <- read.csv('data/NEON-DS-Met-Time-Series/HARV/FisherTower-Met/hf001-06-daily-m.csv')
str(har_met_daily)

har_met_daily$date <- as.Date(har_met_daily$date, format = '%Y-%m-%d')

yr_11_daily_avg <- subset(har_met_daily, date >= as.Date('2011-01-01') & date <= as.Date('2011-12-31'))

ggplot() + geom_point(data = yr_11_daily_avg, aes(jd, airt)) + ggtitle('what') + xlab('Julian Day 2011') + ylab('Mean air temperature')

RGB_277 <- stack('data/NEON-DS-Landsat-NDVI/HARV/2011/RGB/277_HARV_landRGB.tif')
RGB_277 <- RGB_277/255

RGB_277_df <- as.data.frame(RGB_277, xy = TRUE)


# create publcation ready graphics! ---------------------------------------

ggplot() + geom_raster(data = NDVI_HARV_stack_df, aes( x= x, y =y, fill = value)) + facet_wrap(~variable) + ggtitle('landsat NDVI', subtitle ='neon harvard forest') + theme_void() + theme(plot.title = element_text(hjust  = 0.5, face= 'bold'), plot.subtitle = element_text(hjust = 0.5)) + scale_fill_gradientn(name = 'NDVI', colours = green_colors(20))


green_colors <- RColorBrewer::brewer.pal(9, 'YlGn') %>% colorRampPalette()

names(NDVI_HARV_stack)

raster_names <- names(NDVI_HARV_stack)
raster_names <- gsub('_HARV_ndvi_crop', '', raster_names)
raster_names

rater_names <- gsub('X', 'Day ', raster_names)


raster_names  <- gsub("X", "Day ", raster_names)
raster_names

labels_names <- setNames(raster_names, unique(NDVI_HARV_stack_df$variable))

ggplot() +
  geom_raster(data = NDVI_HARV_stack_df , aes(x = x, y = y, fill = value)) +
  facet_wrap(~variable, ncol = 5, labeller = labeller(variable = labels_names)) +
  ggtitle("Landsat NDVI", subtitle = "NEON Harvard Forest") + 
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5)) + 
  scale_fill_gradientn(name = "NDVI", colours = green_colors(20))


# derive values from rasters ----------------------------------------------

avg_NDVI_HARV <- cellStats(NDVI_HARV_stack, mean)

avg_NDVI_HARV
avg_NDVI_HARV <- as.data.frame(avg_NDVI_HARV)

names(avg_NDVI_HARV) <- 'meanNDVI'

avg_NDVI_HARV$site <- 'HARV'

avg_NDVI_HARV$year <- '2011'

julianDays <- gsub('X|_HARV_ndvi_crop', '', row.names(avg_NDVI_HARV))

