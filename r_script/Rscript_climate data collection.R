#load library
library(ncdf.tools)
library(ncdf4)
library(raster)
library(rgdal)
library(ncdf4.helpers)

#load dataset
nc_data <- ncdf4::nc_open("g:/data_gis/tirol_klima/oeks15/daily_values/rr_rcp45.nc")
nc_data <- ncdf4::nc_open("g:/data_gis/tirol_klima/oeks15/daily_values/rr_rcp85.nc")
nc_data <- ncdf4::nc_open("g:/data_gis/tirol_klima/oeks15/daily_values/mt_rcp45.nc")
nc_data <- ncdf4::nc_open("g:/data_gis/tirol_klima/oeks15/daily_values/mt_rcp85.nc")

print(nc_data)

#nc_prj <- nc.get.proj4.string(nc_data, "pr")

##extract time variable
obsdatadates <- as.Date(nc_data$dim$time$vals, origin="1949-12-01")
obsdatadates[1]
obsdatadates[54787]

##set location of study site
pkt_x <- 273459  # longitude of location
pkt_y <- 382287 # latitude  of location


#pkt_x <- 11.653735  # longitude of location
#pkt_y <- 47.330707 # latitude  of location


## extract data at location ##################################################### 
## precipitation data -> varid= "pr"
obsoutput <- ncvar_get(nc_data, varid = 'pr',
                       start= c(which.min(abs(nc_data$dim$x$vals - pkt_x)), # look for closest x-coordinate (lon)
                                which.min(abs(nc_data$dim$y$vals - pkt_y)),  # look for closest y-cooridnate (lat)
                                1),
                       count = c(1,1,-1)) #count '-1' means 'all values along that dimension'that dimension

## merge time and data
data_rr_45 <- data.frame(dates= obsdatadates, rr_45 = obsoutput)
data_rr_85 <- data.frame(dates= obsdatadates, rr_85 = obsoutput)

## temperature data -> varid= "tas"
obsoutput <- ncvar_get(nc_data, varid = 'tas',
                       start= c(which.min(abs(nc_data$dim$x$vals - pkt_x)), # look for closest x-coordinate (lon)
                                which.min(abs(nc_data$dim$y$vals - pkt_y)),  # look for closest y-cooridnate (lat)
                                1),
                       count = c(1,1,-1)) #count '-1' means 'all values along that dimension'that dimension

## merge time and data
data_tas_45 <- data.frame(dates= obsdatadates, tas_45 = obsoutput)
data_tas_85 <- data.frame(dates= obsdatadates, tas_85 = obsoutput)

data <- cbind(data_rr_45, data_rr_85$rr_85, data_tas_45$tas_45, data_tas_85$tas_85)
names(data) <- c("date", "rr45", "rr85", "tas45", "tas85")

data[1:10,]

data$month <- as.numeric(format(data$date, format="%m"))
data$season <- "x"
for(i in 1:length(data$month)){
  data$season[i] <- if(data$month[i] == 12) {"winter"} else if(data$month[i] == 1) {"winter"} else if(data$month[i] == 2) {"winter"
  }else if (data$month[i] == 3) {"spring"}else if(data$month[i] == 4) {"spring"}else if(data$month[i] == 5) {"spring"
  }else if(data$month[i] == 6) {"summer"} else if(data$month[i] == 7) {"summer"} else if(data$month[i] == 8) {"summer"
  }else {"fall"}
}
unique(data$season)

data$year <- as.numeric(format(data$date, format="%Y"))


##split dataset into time ranges
data_1981_2010 <- subset(data, date >= as.Date("1981-01-01") & date <= as.Date("2010-12-31"))
write.csv(data_1981_2010, "c:/data/nawi/ws_2020/I3_project/data_climate/data_1981_2010.csv")

data_2021_2070 <- subset(data, date >= as.Date("2021-01-01") & date <= as.Date("2070-12-31"))
write.csv(data_2021_2070, "c:/data/nawi/ws_2020/I3_project/data_climate/data_2021_2070.csv")

data_2071_2100 <- subset(data, date >= as.Date("2071-01-01") & date <= as.Date("2100-12-31"))
write.csv(data_2071_2100, "c:/data/nawi/ws_2020/I3_project/data_climate/data_2071_2100.csv")