##create xml site file as input to ForClim 

##current climate########################################################################################################  
library("XML")
sitexml <- xmlTreeParse("c:/data/nawi/ws_2020/I3_project/forclim/orginal/SampleData4.0.1/Data/Sites/Site_v4.xml")
root_site       <- xmlRoot(sitexml)

# create ForClim v4.0.1 sitefile and save
curclim <- xmlOutputDOM("siteData")
curclim$addTag("version", "4.0.1") 
curclim$addTag("general", close=FALSE)
curclim$addTag("kPatchSize", 400)                 # patch size
curclim$addTag("kDistP", 0.003)                   #300years disturbance intensity
curclim$closeTag()
curclim$addTag("water", close=FALSE) 
curclim$addTag("kBS", 8.5)                          #plant-available water storage capacity 
curclim$addTag("kCw", 12.0) 
curclim$addTag("kIcpt", 0.3)
curclim$addTag("kLat", 47.3)
curclim$addTag("kSlAsp", 2)      
curclim$closeTag()
#curclim$addNode(xmlChildren(root_site)[[4]])     #copy plant tag 
curclim$addTag("plant", close=FALSE)
curclim$addTag("kBrPr", "20")
curclim$addTag("kEstP", "0.04")                  #set if model structure (setup) is chanaged to 24 to 0.04
curclim$addTag("kEstDens", "0.006")
curclim$addTag("kTrMax", "30000.0")
curclim$addTag("kTreeCohort", "50")
curclim$addTag("kInitDBH", "1.27")
curclim$addTag("kInitDBHSd", "0.1")
curclim$addTag("kInitDBHMin", "0.5")
curclim$addTag("kDBHDiffMax", "0.5")
curclim$addTag("kLAtt", "0.25")
curclim$addTag("kAlpha", "2.3")
curclim$addTag("kDeathP", "4.605")
curclim$addTag("kMinRelInc", "0.1")
curclim$addTag("kMinAbsInc", "0.03")
curclim$addTag("kSGrT", "2")
curclim$addTag("kSlowGrP", "0.368")
curclim$addTag("kAshFree", "0.929")
curclim$addTag("kRSR", "0.0025")
curclim$addTag("kConv", "4.0")
curclim$addTag("kDTT", "5.5")
curclim$addTag("uWiT", "-2.17")
curclim$addTag("uDrAn", "0.023")
curclim$addTag("uDrSe", "0.023")
curclim$addTag("uDDAn", "1933.4")
curclim$addTag("uDDSe", "1933.4")
curclim$closeTag()
curclim$addTag("soil", close=FALSE)  #replace information for 'soil' incl. new bucket size
curclim$addTag("kAvN", 60)  #N stock 
curclim$addTag("kLossW", 0.03)
curclim$addTag("kLossT", 0.2)
curclim$addTag("kNC", 0.005)
curclim$closeTag()   

for (j in 0:12) {  #insert climate information into new sitefile
  i <- ifelse(j==0, 12, j)
  curclim$addTag("weather", close=FALSE)
  curclim$addTag("ID", formatC(j, width=2, flag="0"))
  curclim$addTag("name", as.character(mean_1981_2010[i,"month_name"]))
  curclim$addTag("mT", mean_1981_2010[i,"m_tas45"])
  curclim$addTag("sdT", mean_1981_2010[i,"sd_tas45"])
  curclim$addTag("mP", mean_1981_2010[i,"m_rr45"])
  curclim$addTag("sdP", mean_1981_2010[i,"sd_rr45"])
  curclim$addTag("rTP", mean_1981_2010[i,"cc_45"])
  curclim$closeTag()
}

### Save XML Site file with climatic information
saveXML(curclim$value(), file=paste("c:/data/nawi/ws_2020/I3_project/forclim/setup_cc/Data/Sites/Site.xml")) 
saveXML(curclim$value(), file=paste("c:/data/nawi/ws_2020/I3_project/forclim/setup_rcp45/Data/Sites/Site.xml")) 
saveXML(curclim$value(), file=paste("c:/data/nawi/ws_2020/I3_project/forclim/setup_rcp85/Data/Sites/Site.xml")) 



##climate change ########################################################################################################  

### RCP 4.5 ###
CC <- xmlOutputDOM("climateData")
CC$addTag("version", "4.0.1") 
# 1st climate change period
CC$addTag("climate", close=FALSE)  #copy climate tag 
CC$addTag("CC_start", 2021)
CC$addTag("CC_end", 2070)
#add temperature
CC$addTag("CC_mTsp", anomalies_season_2021_2070$CC_mT45[which(anomalies_season_2021_2070$season=="spring")])
CC$addTag("CC_mTs", anomalies_season_2021_2070$CC_mT45[which(anomalies_season_2021_2070$season=="summer")])
CC$addTag("CC_mTf", anomalies_season_2021_2070$CC_mT45[which(anomalies_season_2021_2070$season=="fall")])
CC$addTag("CC_mTw", anomalies_season_2021_2070$CC_mT45[which(anomalies_season_2021_2070$season=="winter")])
#add precipitation
CC$addTag("CC_mPsp", anomalies_season_2021_2070$CC_mP45[which(anomalies_season_2021_2070$season=="spring")])
CC$addTag("CC_mPs", anomalies_season_2021_2070$CC_mP45[which(anomalies_season_2021_2070$season=="summer")])
CC$addTag("CC_mPf", anomalies_season_2021_2070$CC_mP45[which(anomalies_season_2021_2070$season=="fall")])
CC$addTag("CC_mPw", anomalies_season_2021_2070$CC_mP45[which(anomalies_season_2021_2070$season=="winter")])
#add standard deviation temperature
CC$addTag("CC_sdTsp", anomalies_season_2021_2070$CC_sdT45[which(anomalies_season_2021_2070$season=="spring")])
CC$addTag("CC_sdTs", anomalies_season_2021_2070$CC_sdT45[which(anomalies_season_2021_2070$season=="summer")])
CC$addTag("CC_sdTf", anomalies_season_2021_2070$CC_sdT45[which(anomalies_season_2021_2070$season=="fall")])
CC$addTag("CC_sdTw", anomalies_season_2021_2070$CC_sdT45[which(anomalies_season_2021_2070$season=="winter")])
#add standard deviation precipitation
CC$addTag("CC_sdPsp", anomalies_season_2021_2070$CC_sdP45[which(anomalies_season_2021_2070$season=="spring")])
CC$addTag("CC_sdPs", anomalies_season_2021_2070$CC_sdP45[which(anomalies_season_2021_2070$season=="summer")])
CC$addTag("CC_sdPf", anomalies_season_2021_2070$CC_sdP45[which(anomalies_season_2021_2070$season=="fall")])
CC$addTag("CC_sdPw", anomalies_season_2021_2070$CC_sdP45[which(anomalies_season_2021_2070$season=="winter")])
#add cross-correlation 
CC$addTag("CC_rTPsp", anomalies_season_2021_2070$CC_rTP45[which(anomalies_season_2021_2070$season=="spring")])
CC$addTag("CC_rTPs", anomalies_season_2021_2070$CC_rTP45[which(anomalies_season_2021_2070$season=="summer")])
CC$addTag("CC_rTPf", anomalies_season_2021_2070$CC_rTP45[which(anomalies_season_2021_2070$season=="fall")])
CC$addTag("CC_rTPw", anomalies_season_2021_2070$CC_rTP45[which(anomalies_season_2021_2070$season=="winter")])
CC$closeTag() 

# 2nd climate change period
CC$addTag("climate", close=FALSE)  #copy climate tag 
CC$addTag("CC_start", 2071)
CC$addTag("CC_end", 2100)
#add temperature
CC$addTag("CC_mTsp", anomalies_season_2071_2100$CC_mT45[which(anomalies_season_2071_2100$season=="spring")])
CC$addTag("CC_mTs", anomalies_season_2071_2100$CC_mT45[which(anomalies_season_2071_2100$season=="summer")])
CC$addTag("CC_mTf", anomalies_season_2071_2100$CC_mT45[which(anomalies_season_2071_2100$season=="fall")])
CC$addTag("CC_mTw", anomalies_season_2071_2100$CC_mT45[which(anomalies_season_2071_2100$season=="winter")])
#add precipitation
CC$addTag("CC_mPsp", anomalies_season_2071_2100$CC_mP45[which(anomalies_season_2071_2100$season=="spring")])
CC$addTag("CC_mPs", anomalies_season_2071_2100$CC_mP45[which(anomalies_season_2071_2100$season=="summer")])
CC$addTag("CC_mPf", anomalies_season_2071_2100$CC_mP45[which(anomalies_season_2071_2100$season=="fall")])
CC$addTag("CC_mPw", anomalies_season_2071_2100$CC_mP45[which(anomalies_season_2071_2100$season=="winter")])
#add standard deviation temperature
CC$addTag("CC_sdTsp", anomalies_season_2071_2100$CC_sdT45[which(anomalies_season_2071_2100$season=="spring")])
CC$addTag("CC_sdTs", anomalies_season_2071_2100$CC_sdT45[which(anomalies_season_2071_2100$season=="summer")])
CC$addTag("CC_sdTf", anomalies_season_2071_2100$CC_sdT45[which(anomalies_season_2071_2100$season=="fall")])
CC$addTag("CC_sdTw", anomalies_season_2071_2100$CC_sdT45[which(anomalies_season_2071_2100$season=="winter")])
#add standard deviation precipitation
CC$addTag("CC_sdPsp", anomalies_season_2071_2100$CC_sdP45[which(anomalies_season_2071_2100$season=="spring")])
CC$addTag("CC_sdPs", anomalies_season_2071_2100$CC_sdP45[which(anomalies_season_2071_2100$season=="summer")])
CC$addTag("CC_sdPf", anomalies_season_2071_2100$CC_sdP45[which(anomalies_season_2071_2100$season=="fall")])
CC$addTag("CC_sdPw", anomalies_season_2071_2100$CC_sdP45[which(anomalies_season_2071_2100$season=="winter")])
#add cross-correlation 
CC$addTag("CC_rTPsp", anomalies_season_2071_2100$CC_rTP45[which(anomalies_season_2071_2100$season=="spring")])
CC$addTag("CC_rTPs", anomalies_season_2071_2100$CC_rTP45[which(anomalies_season_2071_2100$season=="summer")])
CC$addTag("CC_rTPf", anomalies_season_2071_2100$CC_rTP45[which(anomalies_season_2071_2100$season=="fall")])
CC$addTag("CC_rTPw", anomalies_season_2071_2100$CC_rTP45[which(anomalies_season_2071_2100$season=="winter")])
CC$closeTag() 

### Save XML Site file with climatic information
saveXML(CC$value(), file=paste("c:/data/nawi/ws_2020/I3_project/forclim/setup_rcp45/Data/Climate/seasonalCC.xml"))


### RCP 8.5 ###
CC <- xmlOutputDOM("climateData")
CC$addTag("version", "4.0.1") 
# 1st climate change period
CC$addTag("climate", close=FALSE)  #copy climate tag 
CC$addTag("CC_start", 2021)
CC$addTag("CC_end", 2070)
#add temperature
CC$addTag("CC_mTsp", anomalies_season_2021_2070$CC_mT85[which(anomalies_season_2021_2070$season=="spring")])
CC$addTag("CC_mTs", anomalies_season_2021_2070$CC_mT85[which(anomalies_season_2021_2070$season=="summer")])
CC$addTag("CC_mTf", anomalies_season_2021_2070$CC_mT85[which(anomalies_season_2021_2070$season=="fall")])
CC$addTag("CC_mTw", anomalies_season_2021_2070$CC_mT85[which(anomalies_season_2021_2070$season=="winter")])
#add precipitation
CC$addTag("CC_mPsp", anomalies_season_2021_2070$CC_mP85[which(anomalies_season_2021_2070$season=="spring")])
CC$addTag("CC_mPs", anomalies_season_2021_2070$CC_mP85[which(anomalies_season_2021_2070$season=="summer")])
CC$addTag("CC_mPf", anomalies_season_2021_2070$CC_mP85[which(anomalies_season_2021_2070$season=="fall")])
CC$addTag("CC_mPw", anomalies_season_2021_2070$CC_mP85[which(anomalies_season_2021_2070$season=="winter")])
#add standard deviation temperature
CC$addTag("CC_sdTsp", anomalies_season_2021_2070$CC_sdT85[which(anomalies_season_2021_2070$season=="spring")])
CC$addTag("CC_sdTs", anomalies_season_2021_2070$CC_sdT85[which(anomalies_season_2021_2070$season=="summer")])
CC$addTag("CC_sdTf", anomalies_season_2021_2070$CC_sdT85[which(anomalies_season_2021_2070$season=="fall")])
CC$addTag("CC_sdTw", anomalies_season_2021_2070$CC_sdT85[which(anomalies_season_2021_2070$season=="winter")])
#add standard deviation precipitation
CC$addTag("CC_sdPsp", anomalies_season_2021_2070$CC_sdP85[which(anomalies_season_2021_2070$season=="spring")])
CC$addTag("CC_sdPs", anomalies_season_2021_2070$CC_sdP85[which(anomalies_season_2021_2070$season=="summer")])
CC$addTag("CC_sdPf", anomalies_season_2021_2070$CC_sdP85[which(anomalies_season_2021_2070$season=="fall")])
CC$addTag("CC_sdPw", anomalies_season_2021_2070$CC_sdP85[which(anomalies_season_2021_2070$season=="winter")])
#add cross-correlation 
CC$addTag("CC_rTPsp", anomalies_season_2021_2070$CC_rTP85[which(anomalies_season_2021_2070$season=="spring")])
CC$addTag("CC_rTPs", anomalies_season_2021_2070$CC_rTP85[which(anomalies_season_2021_2070$season=="summer")])
CC$addTag("CC_rTPf", anomalies_season_2021_2070$CC_rTP85[which(anomalies_season_2021_2070$season=="fall")])
CC$addTag("CC_rTPw", anomalies_season_2021_2070$CC_rTP85[which(anomalies_season_2021_2070$season=="winter")])
CC$closeTag() 

# 2nd climate change period
CC$addTag("climate", close=FALSE)  #copy climate tag 
CC$addTag("CC_start", 2071)
CC$addTag("CC_end", 2100)
#add temperature
CC$addTag("CC_mTsp", anomalies_season_2071_2100$CC_mT85[which(anomalies_season_2071_2100$season=="spring")])
CC$addTag("CC_mTs", anomalies_season_2071_2100$CC_mT85[which(anomalies_season_2071_2100$season=="summer")])
CC$addTag("CC_mTf", anomalies_season_2071_2100$CC_mT85[which(anomalies_season_2071_2100$season=="fall")])
CC$addTag("CC_mTw", anomalies_season_2071_2100$CC_mT85[which(anomalies_season_2071_2100$season=="winter")])
#add precipitation
CC$addTag("CC_mPsp", anomalies_season_2071_2100$CC_mP85[which(anomalies_season_2071_2100$season=="spring")])
CC$addTag("CC_mPs", anomalies_season_2071_2100$CC_mP85[which(anomalies_season_2071_2100$season=="summer")])
CC$addTag("CC_mPf", anomalies_season_2071_2100$CC_mP85[which(anomalies_season_2071_2100$season=="fall")])
CC$addTag("CC_mPw", anomalies_season_2071_2100$CC_mP85[which(anomalies_season_2071_2100$season=="winter")])
#add standard deviation temperature
CC$addTag("CC_sdTsp", anomalies_season_2071_2100$CC_sdT85[which(anomalies_season_2071_2100$season=="spring")])
CC$addTag("CC_sdTs", anomalies_season_2071_2100$CC_sdT85[which(anomalies_season_2071_2100$season=="summer")])
CC$addTag("CC_sdTf", anomalies_season_2071_2100$CC_sdT85[which(anomalies_season_2071_2100$season=="fall")])
CC$addTag("CC_sdTw", anomalies_season_2071_2100$CC_sdT85[which(anomalies_season_2071_2100$season=="winter")])
#add standard deviation precipitation
CC$addTag("CC_sdPsp", anomalies_season_2071_2100$CC_sdP85[which(anomalies_season_2071_2100$season=="spring")])
CC$addTag("CC_sdPs", anomalies_season_2071_2100$CC_sdP85[which(anomalies_season_2071_2100$season=="summer")])
CC$addTag("CC_sdPf", anomalies_season_2071_2100$CC_sdP85[which(anomalies_season_2071_2100$season=="fall")])
CC$addTag("CC_sdPw", anomalies_season_2071_2100$CC_sdP85[which(anomalies_season_2071_2100$season=="winter")])
#add cross-correlation 
CC$addTag("CC_rTPsp", anomalies_season_2071_2100$CC_rTP85[which(anomalies_season_2071_2100$season=="spring")])
CC$addTag("CC_rTPs", anomalies_season_2071_2100$CC_rTP85[which(anomalies_season_2071_2100$season=="summer")])
CC$addTag("CC_rTPf", anomalies_season_2071_2100$CC_rTP85[which(anomalies_season_2071_2100$season=="fall")])
CC$addTag("CC_rTPw", anomalies_season_2071_2100$CC_rTP85[which(anomalies_season_2071_2100$season=="winter")])
CC$closeTag() 

### Save XML Site file with climatic information
saveXML(CC$value(), file=paste("c:/data/nawi/ws_2020/I3_project/forclim/setup_rcp85/Data/Climate/seasonalCC.xml"))
