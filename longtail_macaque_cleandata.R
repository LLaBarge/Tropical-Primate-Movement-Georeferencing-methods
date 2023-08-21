# script for importing and exploratory analysis of long-tailed macaque
#data collected at Ketambe, Sumatra between 1976 - 1989
# contains data on House, Ketambe, Atas, Bawah, Timour, Amnatara groups

pcks <- list("dplyr", "lubridate", "adehabitatLT", "ggplot2", "move", "readr", "sf", "amt")
sapply(pcks, require, char = TRUE)

library(readr)
LT_data_combined <- read_csv("LT_data_combined.csv")
head(LT_data_combined)
View(LT_data_combined)

# time column is missing ":" 
LT_data_combined$Time_new<- parse_time(LT_data_combined$Time, "%H%M")

# combine day month year and time into a single timestamp 

# create a datetime object for the timestamp
LT_data_combined$Date<-paste(LT_data_combined$Year, LT_data_combined$Month, LT_data_combined$Day, sep = "-")
str(LT_data_combined$Date)


LT_data_combined$timestamp<- as.POSIXct(paste(LT_data_combined$Date, LT_data_combined$Time_new), format="%Y-%m-%d %H:%M:%S")
str(LT_data_combined$timestamp)


# select out variables relevant for making tracks
Ket.lt_selected<-LT_data_combined%>% dplyr::select('timestamp', 'Group', 'X', 'Y')
str(Ket.lt_selected)

Ket.lt_selected <- filter(Ket.lt_selected, Ket.lt_selected$X < 98, Ket.lt_selected$Y < 4)
str( Ket.lt_selected)


# create tracks
lt_track<-na.omit(Ket.lt_selected)

lt_tracks <- lt_track %>% make_track(X, Y, .t=timestamp, id = Group, crs = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
lt_tracks
class(lt_tracks)
plot(lt_tracks)

require(ggplot2)
ggplot(Ket.lt_selected, aes(x = X, y = Y, col = Group)) + geom_path()

# create a raster for the study site
library(raster)
Ketambe_rast<-raster()
extent(Ketambe_rast)<-extent(330000, 355000, 400000, 410000)
res(Ketambe_rast)<-25
projection(Ketambe_rast) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"


# occurrence distributions


