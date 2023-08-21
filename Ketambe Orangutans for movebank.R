

setwd("~/")
# convert dbf files of orangutan movement to csvs
#install.packages("foreign")
#library(foreign)
#data = read.dbf("XY_all_27dec16.dbf")
#write.csv(data, "XY_all_27dec16.csv", row.names=F)

# read in csv and then select out relevant parameters for movebank
library(tidyverse)
Ketambe.orang<-read.csv("XY_all_27dec16.csv")
str(Ketambe.orang)

# select out variables relevant for making tracks
Ket.orang_selected<-Ketambe.orang%>% dplyr::select('COMMON', 'DAT_TIM_1', 'X', 'Y')
write.csv(Ket.orang_selected, "Ket.orang_selected")


# date is isnt in a useful format so change this
Ket.orang_selected$Timestamp<-as.POSIXct(Ket.orang_selected$DAT_TIM_1)

# check the data for NAs
str(Ket.orang_selected)
table(is.na(Ket.orang_selected$Timestamp))

Ket.orang<-na.omit(Ket.orang_selected)
str(Ket.orang)


write.csv(Ket.orang, file="Ket.orang.csv")

# manually upload these data to movebank


# then we can create tracks
library(amt)

orangutans_track<-na.omit(Ket.orang_selected)

#' Next we create tracks, 
orangs_track <- orangutans_track %>% make_track(X, Y, .t=Timestamp, id = COMMON, crs = CRS("+init=epsg:32750 +proj=utm +zone=47 +units=m +north"))
orangs_track
class(orangs_track)
plot(orangs_track)


# create a raster for the study site
library(raster)
min(orangs_track$x_)
max(orangs_track$x_)
min(orangs_track$y_)
max(orangs_track$y_)

Ketambe_rast<-raster()
extent(Ketambe_rast)<-extent(330000, 355000, 400000, 410000)
res(Ketambe_rast)<-25
projection(Ketambe_rast) <- "+init=epsg:32750 +proj=utm +zone=47 +units=m +north"









# occurrence distributions
orangs_OD_ket <- od(orangs_track, model=fit_ctmm(orangs_track,"bm"), n.points=30, show.progress = TRUE)

# daily travel length
# time in between rest periods on continuous days 
# primate sleep active periods nest to nest


ctmmweb::app()

