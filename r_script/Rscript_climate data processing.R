###R-script for calculating climate date for ForClim

#load library
library(readr)

#load data
data_1981_2010 <- read_csv("C:/data/nawi/ws_2020/I3_project/data_climate/data_1981_2010.csv")
data_2021_2070 <- read_csv("C:/data/nawi/ws_2020/I3_project/data_climate/data_2021_2070.csv")
data_2071_2100 <- read_csv("C:/data/nawi/ws_2020/I3_project/data_climate/data_2071_2100.csv")

##aggregated by month#########################################################################################

#current climate  
mean_1981_2010   <- round(aggregate(data_1981_2010$tas45, by = list(month = data_1981_2010$month), mean),2)
names(mean_1981_2010) <- c("month", "m_tas45")
mean_1981_2010$m_tas85 <- round(aggregate(data_1981_2010$tas85, by = list(data_1981_2010$month), mean)[,2],2)
mean_1981_2010$sd_tas45 <- round(aggregate(data_1981_2010$tas45, by = list(data_1981_2010$month), sd)[,2],2)
mean_1981_2010$sd_tas85 <- round(aggregate(data_1981_2010$tas85, by = list(data_1981_2010$month), sd)[,2],2)

MAP <- aggregate((data_1981_2010$rr45), by = list(year = data_1981_2010$year), sum)
mean(MAP$x)

rr <- round(aggregate((data_1981_2010$rr45/10), by = list(month = data_1981_2010$month, year = data_1981_2010$year), sum),2)
rr$rr_ln <- log(rr$x+1)
mean_1981_2010$m_rr45<- round(aggregate(rr$rr_ln, by = list(month = rr$month), mean)[,2],2)
mean_1981_2010$sd_rr45 <- round(aggregate(rr$rr_ln, by = list(rr$month), sd)[,2],2)
rr <- round(aggregate((data_1981_2010$rr85/10), by = list(month = data_1981_2010$month, year = data_1981_2010$year), sum),2)
rr$rr_ln <- log(rr$x+1)
mean_1981_2010$m_rr85<- round(aggregate(rr$rr_ln, by = list(month = rr$month), mean)[,2],2)
mean_1981_2010$sd_rr85 <- round(aggregate(rr$rr_ln, by = list(rr$month), sd)[,2],2)

mean_1981_2010$cc_45 <- round(as.vector(by(data_1981_2010, data_1981_2010$month, function(x) ccf(x$tas45, x$rr45, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2])),2)
mean_1981_2010$cc_85 <- round(as.vector(by(data_1981_2010, data_1981_2010$month, function(x) ccf(x$tas85, x$rr85, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2])),2)

mean_1981_2010$month_name <- c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec")

write.csv(mean_1981_2010, "c:/data/nawi/ws_2020/I3_project/data_climate/mean_1981_2010.csv")


rr_month <- round(aggregate(rr$x, by = list(month = rr$month), mean),2)


#climate change 2021-2070 
mean_2021_2070   <- aggregate(data_2021_2070$tas45, by = list(month = data_2021_2070$month), mean)
names(mean_2021_2070) <- c("month", "m_tas45")
mean_2021_2070$m_tas85 <- aggregate(data_2021_2070$tas85, by = list(data_2021_2070$month), mean)[,2]
mean_2021_2070$sd_tas45 <- aggregate(data_2021_2070$tas45, by = list(data_2021_2070$month), sd)[,2]
mean_2021_2070$sd_tas85 <- aggregate(data_2021_2070$tas85, by = list(data_2021_2070$month), sd)[,2]

rr <- aggregate((data_2021_2070$rr45/10), by = list(month = data_2021_2070$month, year = data_2021_2070$year), sum)
rr$rr_ln <- log(rr$x+1)
mean_2021_2070$m_rr45<- aggregate(rr$rr_ln, by = list(month = rr$month), mean)[,2]
mean_2021_2070$sd_rr45 <- aggregate(rr$rr_ln, by = list(rr$month), sd)[,2]
rr <- aggregate((data_2021_2070$rr85/10), by = list(month = data_2021_2070$month, year = data_2021_2070$year), sum)
rr$rr_ln <- log(rr$x+1)
mean_2021_2070$m_rr85<- aggregate(rr$rr_ln, by = list(month = rr$month), mean)[,2]
mean_2021_2070$sd_rr85 <- aggregate(rr$rr_ln, by = list(rr$month), sd)[,2]

mean_2021_2070$cc_45 <- as.vector(by(data_2021_2070, data_2021_2070$month, function(x) ccf(x$tas45, x$rr45, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2]))
mean_2021_2070$cc_85 <- as.vector(by(data_2021_2070, data_2021_2070$month, function(x) ccf(x$tas85, x$rr85, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2]))

mean_2021_2070$month_name <- c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec")

write.csv(mean_2021_2070, "c:/data/nawi/ws_2020/I3_project/data_climate/mean_2021_2070.csv")


#climate change 2071-2100 
mean_2071_2100  <- aggregate(data_2071_2100$tas45, by = list(month = data_2071_2100$month), mean)
names(mean_2071_2100) <- c("month", "m_tas45")
mean_2071_2100$m_tas85 <- aggregate(data_2071_2100$tas85, by = list(data_2071_2100$month), mean)[,2]
mean_2071_2100$sd_tas45 <- aggregate(data_2071_2100$tas45, by = list(data_2071_2100$month), sd)[,2]
mean_2071_2100$sd_tas85 <- aggregate(data_2071_2100$tas85, by = list(data_2071_2100$month), sd)[,2]

rr <- aggregate((data_2071_2100$rr45/10), by = list(month = data_2071_2100$month, year = data_2071_2100$year), sum)
rr$rr_ln <- log(rr$x+1)
mean_2071_2100$m_rr45<- aggregate(rr$rr_ln, by = list(month = rr$month), mean)[,2]
mean_2071_2100$sd_rr45 <- aggregate(rr$rr_ln, by = list(rr$month), sd)[,2]
rr <- aggregate((data_2071_2100$rr85/10), by = list(month = data_2071_2100$month, year = data_2071_2100$year), sum)
rr$rr_ln <- log(rr$x+1)
mean_2071_2100$m_rr85<- aggregate(rr$rr_ln, by = list(month = rr$month), mean)[,2]
mean_2071_2100$sd_rr85 <- aggregate(rr$rr_ln, by = list(rr$month), sd)[,2]

mean_2071_2100$cc_45 <- as.vector(by(data_2071_2100, data_2071_2100$month, function(x) ccf(x$tas45, x$rr45, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2]))
mean_2071_2100$cc_85 <- as.vector(by(data_2071_2100, data_2071_2100$month, function(x) ccf(x$tas85, x$rr85, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2]))

mean_2071_2100$month_name <- c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec")

write.csv(mean_2071_2100, "c:/data/nawi/ws_2020/I3_project/data_climate/mean_2071_2100.csv")


##aggregated by season########################################################################################################

#current climate 
mean_season_1981_2010   <- aggregate(data_1981_2010$tas45, by = list(season = data_1981_2010$season), mean)
names(mean_season_1981_2010) <- c("season", "m_tas45")
mean_season_1981_2010$m_tas85 <- aggregate(data_1981_2010$tas85, by = list(data_1981_2010$season), mean)[,2]
mean_season_1981_2010$sd_tas45 <- aggregate(data_1981_2010$tas45, by = list(data_1981_2010$season), sd)[,2]
mean_season_1981_2010$sd_tas85 <- aggregate(data_1981_2010$tas85, by = list(data_1981_2010$season), sd)[,2]

rr <- aggregate((data_1981_2010$rr45/10), by = list(season = data_1981_2010$season, year = data_1981_2010$year), sum)
rr$rr_ln <- log(rr$x+1)
mean_season_1981_2010$m_rr45<- aggregate(rr$rr_ln, by = list(season = rr$season), mean)[,2]
mean_season_1981_2010$sd_rr45 <- aggregate(rr$rr_ln, by = list(rr$season), sd)[,2]
rr <- aggregate((data_1981_2010$rr85/10), by = list(season = data_1981_2010$season, year = data_1981_2010$year), sum)
rr$rr_ln <- log(rr$x+1)
mean_season_1981_2010$m_rr85<- aggregate(rr$rr_ln, by = list(season = rr$season), mean)[,2]
mean_season_1981_2010$sd_rr85 <- aggregate(rr$rr_ln, by = list(rr$season), sd)[,2]

mean_season_1981_2010$cc_45 <- as.vector(by(data_1981_2010, data_1981_2010$season, function(x) ccf(x$tas45, x$rr45, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2]))
mean_season_1981_2010$cc_85 <- as.vector(by(data_1981_2010, data_1981_2010$season, function(x) ccf(x$tas85, x$rr85, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2]))

write.csv(mean_season_1981_2010, "c:/data/nawi/ws_2020/I3_project/data_climate/mean_season_1981_2010.csv")



#climate change 2021-2070 
mean_season_2021_2070   <- aggregate(data_2021_2070$tas45, by = list(season = data_2021_2070$season), mean)
names(mean_season_2021_2070) <- c("season", "m_tas45")
mean_season_2021_2070$m_tas85 <- aggregate(data_2021_2070$tas85, by = list(data_2021_2070$season), mean)[,2]
mean_season_2021_2070$sd_tas45 <- aggregate(data_2021_2070$tas45, by = list(data_2021_2070$season), sd)[,2]
mean_season_2021_2070$sd_tas85 <- aggregate(data_2021_2070$tas85, by = list(data_2021_2070$season), sd)[,2]

rr <- aggregate((data_2021_2070$rr45/10), by = list(season = data_2021_2070$season, year = data_2021_2070$year), sum)
rr$rr_ln <- log(rr$x+1)
mean_season_2021_2070$m_rr45<- aggregate(rr$rr_ln, by = list(season = rr$season), mean)[,2]
mean_season_2021_2070$sd_rr45 <- aggregate(rr$rr_ln, by = list(rr$season), sd)[,2]
rr <- aggregate((data_2021_2070$rr85/10), by = list(season = data_2021_2070$season, year = data_2021_2070$year), sum)
rr$rr_ln <- log(rr$x+1)
mean_season_2021_2070$m_rr85<- aggregate(rr$rr_ln, by = list(season = rr$season), mean)[,2]
mean_season_2021_2070$sd_rr85 <- aggregate(rr$rr_ln, by = list(rr$season), sd)[,2]

mean_season_2021_2070$cc_45 <- as.vector(by(data_2021_2070, data_2021_2070$season, function(x) ccf(x$tas45, x$rr45, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2]))
mean_season_2021_2070$cc_85 <- as.vector(by(data_2021_2070, data_2021_2070$season, function(x) ccf(x$tas85, x$rr85, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2]))

write.csv(mean_season_2021_2070, "c:/data/nawi/ws_2020/I3_project/data_climate/mean_season_2021_2070.csv")


#climate change 2071-2100 
mean_season_2071_2100  <- aggregate(data_2071_2100$tas45, by = list(season = data_2071_2100$season), mean)
names(mean_season_2071_2100) <- c("season", "m_tas45")
mean_season_2071_2100$m_tas85 <- aggregate(data_2071_2100$tas85, by = list(data_2071_2100$season), mean)[,2]
mean_season_2071_2100$sd_tas45 <- aggregate(data_2071_2100$tas45, by = list(data_2071_2100$season), sd)[,2]
mean_season_2071_2100$sd_tas85 <- aggregate(data_2071_2100$tas85, by = list(data_2071_2100$season), sd)[,2]

rr <- aggregate((data_2071_2100$rr45/10), by = list(season = data_2071_2100$season, year = data_2071_2100$year), sum)
rr$rr_ln <- log(rr$x+1)
mean_season_2071_2100$m_rr45<- aggregate(rr$rr_ln, by = list(season = rr$season), mean)[,2]
mean_season_2071_2100$sd_rr45 <- aggregate(rr$rr_ln, by = list(rr$season), sd)[,2]
rr <- aggregate((data_2071_2100$rr85/10), by = list(season = data_2071_2100$season, year = data_2071_2100$year), sum)
rr$rr_ln <- log(rr$x+1)
mean_season_2071_2100$m_rr85<- aggregate(rr$rr_ln, by = list(season = rr$season), mean)[,2]
mean_season_2071_2100$sd_rr85 <- aggregate(rr$rr_ln, by = list(rr$season), sd)[,2]

mean_season_2071_2100$cc_45 <- as.vector(by(data_2071_2100, data_2071_2100$season, function(x) ccf(x$tas45, x$rr45, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2]))
mean_season_2071_2100$cc_85 <- as.vector(by(data_2071_2100, data_2071_2100$season, function(x) ccf(x$tas85, x$rr85, type=c("correlation"), lag.max=1, plot=F, data=x)$acf[2]))

write.csv(mean_season_2071_2100, "c:/data/nawi/ws_2020/I3_project/data_climate/mean_season_2071_2100.csv")


##calculate climate change anomalies#########################################################################################
#climate change 2021-2070 
anomalies_season_2021_2070 <- as.data.frame(mean_season_2021_2070$season)
names(anomalies_season_2021_2070) <- c("season")
#absolute differences [°C]
anomalies_season_2021_2070$CC_mT45 <- round(mean_season_2021_2070$m_tas45 - mean_season_1981_2010$m_tas45,2)
anomalies_season_2021_2070$CC_mT85 <- round(mean_season_2021_2070$m_tas85 - mean_season_1981_2010$m_tas85,2)
anomalies_season_2021_2070$CC_sdT45 <- round(mean_season_2021_2070$sd_tas45 - mean_season_1981_2010$sd_tas45,2)
anomalies_season_2021_2070$CC_sdT85 <- round(mean_season_2021_2070$sd_tas85 - mean_season_1981_2010$sd_tas85,2)
#relative differences
anomalies_season_2021_2070$CC_mP45 <- round((mean_season_2021_2070$m_rr45/mean_season_1981_2010$m_rr45),2)
anomalies_season_2021_2070$CC_mP85 <- round((mean_season_2021_2070$m_rr85/mean_season_1981_2010$m_rr85),2)
anomalies_season_2021_2070$CC_sdP45 <- round((mean_season_2021_2070$sd_rr45/mean_season_1981_2010$sd_rr45),2)
anomalies_season_2021_2070$CC_sdP85 <- round((mean_season_2021_2070$sd_rr85/mean_season_1981_2010$sd_rr85),2)
#absolute differences 
anomalies_season_2021_2070$CC_rTP45 <- round(mean_season_2021_2070$cc_45 - mean_season_1981_2010$cc_45,2)
anomalies_season_2021_2070$CC_rTP85 <- round(mean_season_2021_2070$cc_85 - mean_season_1981_2010$cc_85,2)

write.csv(anomalies_season_2021_2070, "c:/data/nawi/ws_2020/I3_project/data_climate/anomalies_season_2021_2070.csv")

#climate change 2071-2100 
anomalies_season_2071_2100 <- as.data.frame(mean_season_2071_2100$season)
names(anomalies_season_2071_2100) <- c("season")
#absolute differences [°C]
anomalies_season_2071_2100$CC_mT45 <- round(mean_season_2071_2100$m_tas45 - mean_season_1981_2010$m_tas45,2)
anomalies_season_2071_2100$CC_mT85 <- round(mean_season_2071_2100$m_tas85 - mean_season_1981_2010$m_tas85,2)
anomalies_season_2071_2100$CC_sdT45 <- round(mean_season_2071_2100$sd_tas45 - mean_season_1981_2010$sd_tas45,2)
anomalies_season_2071_2100$CC_sdT85 <- round(mean_season_2071_2100$sd_tas85 - mean_season_1981_2010$sd_tas85,2)
#relative differences
anomalies_season_2071_2100$CC_mP45 <- round((mean_season_2071_2100$m_rr45/mean_season_1981_2010$m_rr45),2)
anomalies_season_2071_2100$CC_mP85 <- round((mean_season_2071_2100$m_rr85/mean_season_1981_2010$m_rr85),2)
anomalies_season_2071_2100$CC_sdP45 <- round((mean_season_2071_2100$sd_rr45/mean_season_1981_2010$sd_rr45),2)
anomalies_season_2071_2100$CC_sdP85 <- round((mean_season_2071_2100$sd_rr85/mean_season_1981_2010$sd_rr85),2)
#absolute differences 
anomalies_season_2071_2100$CC_rTP45 <- round(mean_season_2071_2100$cc_45 - mean_season_1981_2010$cc_45,2)
anomalies_season_2071_2100$CC_rTP85 <- round(mean_season_2071_2100$cc_85 - mean_season_1981_2010$cc_85,2)

#change between 1st period (2021-2070) and 2nd perioid (2071-2100)
anomalies_season_2071_2100$CC_mT45 <- round(mean_season_2071_2100$m_tas45 - mean_season_2021_2070$m_tas45,2)
anomalies_season_2071_2100$CC_mT85 <- round(mean_season_2071_2100$m_tas85 - mean_season_2021_2070$m_tas85,2)
anomalies_season_2071_2100$CC_mP45 <- round((mean_season_2071_2100$m_rr45/mean_season_2021_2070$m_rr45),2)
anomalies_season_2071_2100$CC_mP85 <- round((mean_season_2071_2100$m_rr85/mean_season_2021_2070$m_rr85),2)

write.csv(anomalies_season_2071_2100, "c:/data/nawi/ws_2020/I3_project/data_climate/anomalies_season_2071_2100.csv")

