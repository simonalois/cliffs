###R-script for multiple model runs

library(XML)
#species 02:Picea abies, 00:Abies alba, 17:Fagus sylvatica, 09:Acer pseudoplatanus, 13:Betula pendula, 05:Pinus sylvestris,
#21:Quercus petraea, 27:Tilia cordata, 01:Larix decidua, 25:Sorbus aria
#best species 
#def_species <- c("02", "00", "17", "09", "13", "05", "21", "27", "01", "25")
#only species present in stand
def_species <- c("02", "00", "09", "05", "01")

####setup of current climate########################################################################################### 
for (b in 1:100){ 
  seed <- b
  setupxml <- xmlTreeParse("c:/data/nawi/ws_2020/I3_project/forclim/orginal/SampleData4.0.1/ForClim_Setup.xml")
  root_setup       <- xmlRoot(setupxml)
  
  #create ForClim v4.0.1 sitefile and save
  setup <- xmlOutputDOM("configData")
  setup$addTag("version", "4.0.1") 
  setup$addTag("siteParam", close=FALSE)
  setup$addTag("name", "Site.xml")
  setup$addTag("path", "Data/Sites/")
  setup$closeTag()
  setup$addNode(xmlChildren(root_setup)[[3]])  #copy species parametrisation tag 
  setup$addTag("climateParam", close=FALSE)
  setup$addTag("isCC", "False")                #climate change is not active
  setup$addTag("name", "seasonalCC.xml")
  setup$addTag("path", "Data/Climate/")
  setup$closeTag()
  setup$addNode(xmlChildren(root_setup)[[5]])  #copy snow modul tag 
  setup$addTag("modelStructure", close=FALSE)
  setup$addTag("variant", "14")                #variant=24: Establishment E6*(higher recruitment of shade tolerant species), Growth A2(stronger hight growth of shade tolerant species), background mortality M1(for natural forest development)
  setup$closeTag()
  setup$addTag("weatherParam", close=FALSE)
  setup$addTag("isWeatherInput", "False")
  setup$addTag("name", "weather.xml")
  setup$addTag("path", "Data/Weather/")
  setup$closeTag()
  setup$addTag("managementParam", close=FALSE)
  setup$addTag("isHarvest", "False")
  setup$addTag("name", "Management.xml")
  setup$addTag("path", "Data/Management/")
  setup$closeTag()
  setup$addTag("states", close=FALSE)
  setup$addTag("name", "stand_terfens.xml")
  #setup$addTag("name", "stand_terfens_planted.xml")
  setup$addTag("path", "Data/States/")
  setup$addTag("standDataIn", "True")         #initialisation with stand data
  setup$addTag("stateIn", "False")
  setup$addTag("stateOut", "False")
  setup$closeTag()
  setup$addTag("results", close=FALSE)
  setup$addTag("name", "CurrentClimate")       #define model run
  setup$addTag("path", "output/")
  setup$addTag("cohortOut", "False")
  setup$addTag("logDIncOut", "False")
  setup$addTag("limFactOut", "True")
  setup$addTag("cohortsSQLiteOut", "True")
  setup$closeTag()
  setup$addTag("simulation", close=FALSE)
  setup$addTag("name", "Terfens")
  setup$addTag("initTime", "2020")
  setup$addTag("endTime", "2100")
  setup$addTag("runNumber", "200")
  setup$addTag("viewStep", "1")
  setup$addTag("viewStepSQL", "1")
  setup$addTag("startOutput", "0")
  setup$addTag("seedValue", paste(seed))       #set each time new seed
  setup$closeTag()
  setup$addTag("output", close=FALSE)
  setup$addTag("disable", "False")
  setup$closeTag()
  for (i in 1:length(def_species)) {     #insert spcies to xml
    setup$addTag("actualSpecies", close=FALSE)
    setup$addTag("kID", def_species[i])
    setup$closeTag()
  }
  setup$closeTag()
  saveXML(setup$value(), file=paste("c:/eigene_programme/ForClim/ForClim_Setup.xml"))
  #start model
  setwd("c:/eigene_programme/ForClim")  
  system(shQuote("c:/eigene_programme/ForClim/ForClim.exe"))
  #save data
  file.copy("c:/eigene_programme/ForClim/output/CurrentClimate_Terfens_Results/Species_Results/BA_Mean.DAT",
              paste("c:/data/nawi/ws_2020/I3_project/forclim/results_batch/cc/BA_Mean_",b,".DAT"))
  file.copy("c:/eigene_programme/ForClim/output/CurrentClimate_Terfens_Results/Species_Results/Vol_Mean.DAT",
              paste("c:/data/nawi/ws_2020/I3_project/forclim/results_batch/cc/Vol_Mean_",b,".DAT")) 
  file.copy("c:/eigene_programme/ForClim/output/CurrentClimate_Terfens_Results/Stand_Results/Mean.DAT",
              paste("c:/data/nawi/ws_2020/I3_project/forclim/results_batch/cc/Stand_Mean_",b,".DAT"))    
} 

####setup of RCP 4.5 ########################################################################################### 
#replace climate file for RCP 4.5
file.copy("c:/data/nawi/ws_2020/I3_project/forclim/setup_rcp45/Data/Climate/seasonalCC.xml",
          "c:/eigene_programme/ForClim/Data/Climate/seasonalCC.xml", overwrite=TRUE)

#performe 100-times model runs with changed seedvalue
for (b in 1:100){ 
  seed <- b
  setupxml <- xmlTreeParse("c:/data/nawi/ws_2020/I3_project/forclim/orginal/SampleData4.0.1/ForClim_Setup.xml")
  root_setup       <- xmlRoot(setupxml)
  
  # create ForClim v4.0.1 sitefile and save
  setup <- xmlOutputDOM("configData")
  setup$addTag("version", "4.0.1") 
  setup$addTag("siteParam", close=FALSE)
  setup$addTag("name", "Site.xml")
  setup$addTag("path", "Data/Sites/")
  setup$closeTag()
  setup$addNode(xmlChildren(root_setup)[[3]])  #copy species parametrisation tag 
  setup$addTag("climateParam", close=FALSE)
  setup$addTag("isCC", "True")                 #apply climate change szenarios 
  setup$addTag("name", "seasonalCC.xml")
  setup$addTag("path", "Data/Climate/")
  setup$closeTag()
  setup$addNode(xmlChildren(root_setup)[[5]])  #copy snow modul tag 
  setup$addTag("modelStructure", close=FALSE)
  setup$addTag("variant", "14")                #variant=24: Establishment E6*(higher recruitment of shade tolerant species), Growth A2(stronger hight growth of shade tolerant species), background mortality M1(for natural forest development)
  setup$closeTag()
  setup$addTag("weatherParam", close=FALSE)
  setup$addTag("isWeatherInput", "False")
  setup$addTag("name", "weather.xml")
  setup$addTag("path", "Data/Weather/")
  setup$closeTag()
  setup$addTag("managementParam", close=FALSE)
  setup$addTag("isHarvest", "False")
  setup$addTag("name", "Management.xml")
  setup$addTag("path", "Data/Management/")
  setup$closeTag()
  setup$addTag("states", close=FALSE)
  setup$addTag("name", "stand_terfens.xml")
  #setup$addTag("name", "stand_terfens_planted.xml")
  setup$addTag("path", "Data/States/")
  setup$addTag("standDataIn", "True")         #initialisation with stand data
  setup$addTag("stateIn", "False")
  setup$addTag("stateOut", "False")
  setup$closeTag()
  setup$addTag("results", close=FALSE)
  setup$addTag("name", "rcp45")              #define model run
  setup$addTag("path", "output/")
  setup$addTag("cohortOut", "False")
  setup$addTag("logDIncOut", "False")
  setup$addTag("limFactOut", "True")
  setup$addTag("cohortsSQLiteOut", "True")
  setup$closeTag()
  setup$addTag("simulation", close=FALSE)
  setup$addTag("name", "Terfens")
  setup$addTag("initTime", "2020")
  setup$addTag("endTime", "2100")
  setup$addTag("runNumber", "200")
  setup$addTag("viewStep", "1")
  setup$addTag("viewStepSQL", "1")
  setup$addTag("startOutput", "0")
  setup$addTag("seedValue", paste(seed))        #set each time new seed
  setup$closeTag()
  setup$addTag("output", close=FALSE)
  setup$addTag("disable", "False")
  setup$closeTag()
  for (i in 1:length(def_species)) {     #insert spcies to xml
    setup$addTag("actualSpecies", close=FALSE)
    setup$addTag("kID", def_species[i])
    setup$closeTag()
  }
  setup$closeTag()
  saveXML(setup$value(), file=paste("c:/eigene_programme/ForClim/ForClim_Setup.xml"))
  #start model
  setwd("c:/eigene_programme/ForClim")  
  system(shQuote("c:/eigene_programme/ForClim/ForClim.exe"))
  #save data
  file.copy("c:/eigene_programme/ForClim/output/rcp45_Terfens_Results/Species_Results/BA_Mean.DAT",
            paste("c:/data/nawi/ws_2020/I3_project/forclim/results_batch/rcp45/BA_Mean_",b,".DAT"))
  file.copy("c:/eigene_programme/ForClim/output/rcp45_Terfens_Results/Species_Results/Vol_Mean.DAT",
            paste("c:/data/nawi/ws_2020/I3_project/forclim/results_batch/rcp45/Vol_Mean_",b,".DAT")) 
  file.copy("c:/eigene_programme/ForClim/output/rcp45_Terfens_Results/Stand_Results/Mean.DAT",
            paste("c:/data/nawi/ws_2020/I3_project/forclim/results_batch/rcp45/Stand_Mean_",b,".DAT"))    
}


####setup of RCP 8.5########################################################################################### 
#replace climate file for RCP 8.5
file.copy("c:/data/nawi/ws_2020/I3_project/forclim/setup_rcp85/Data/Climate/seasonalCC.xml",
          "c:/eigene_programme/ForClim/Data/Climate/seasonalCC.xml",overwrite=TRUE)

#performe 100-times model runs with changed seedvalue
for (b in 1:100){ 
    seed <- b

    setupxml <- xmlTreeParse("c:/data/nawi/ws_2020/I3_project/forclim/orginal/SampleData4.0.1/ForClim_Setup.xml")
    root_setup       <- xmlRoot(setupxml)

    #create ForClim v4.0.1 sitefile and save
    setup <- xmlOutputDOM("configData")
    setup$addTag("version", "4.0.1") 
    setup$addTag("siteParam", close=FALSE)
    setup$addTag("name", "Site.xml")
    setup$addTag("path", "Data/Sites/")
    setup$closeTag()
    setup$addNode(xmlChildren(root_setup)[[3]])  #copy species parametrisation tag 
    setup$addTag("climateParam", close=FALSE)
    setup$addTag("isCC", "True")                 #apply climate change szenarios 
    setup$addTag("name", "seasonalCC.xml")
    setup$addTag("path", "Data/Climate/")
    setup$closeTag()
    setup$addNode(xmlChildren(root_setup)[[5]])  #copy snow modul tag 
    setup$addTag("modelStructure", close=FALSE)
    setup$addTag("variant", "14")                #variant=24: Establishment E6*(higher recruitment of shade tolerant species), Growth A2(stronger hight growth of shade tolerant species), background mortality M1(for natural forest development)
    setup$closeTag()
    setup$addTag("weatherParam", close=FALSE)
    setup$addTag("isWeatherInput", "False")
    setup$addTag("name", "weather.xml")
    setup$addTag("path", "Data/Weather/")
    setup$closeTag()
    setup$addTag("managementParam", close=FALSE)
    setup$addTag("isHarvest", "False")
    setup$addTag("name", "Management.xml")
    setup$addTag("path", "Data/Management/")
    setup$closeTag()
    setup$addTag("states", close=FALSE)
    setup$addTag("name", "stand_terfens.xml")
    #setup$addTag("name", "stand_terfens_planted.xml")
    setup$addTag("path", "Data/States/")
    setup$addTag("standDataIn", "True")         #initialisation with stand data
    setup$addTag("stateIn", "False")
    setup$addTag("stateOut", "False")
    setup$closeTag()
    setup$addTag("results", close=FALSE)
    setup$addTag("name", "rcp85")       #define model run
    setup$addTag("path", "output/")
    setup$addTag("cohortOut", "False")
    setup$addTag("logDIncOut", "False")
    setup$addTag("limFactOut", "True")
    setup$addTag("cohortsSQLiteOut", "True")
    setup$closeTag()
    setup$addTag("simulation", close=FALSE)
    setup$addTag("name", "Terfens")
    setup$addTag("initTime", "2020")
    setup$addTag("endTime", "2100")
    setup$addTag("runNumber", "200")
    setup$addTag("viewStep", "1")
    setup$addTag("viewStepSQL", "1")
    setup$addTag("startOutput", "0")
    setup$addTag("seedValue", paste(seed))     #set each time new seed
    setup$closeTag()
    setup$addTag("output", close=FALSE)
    setup$addTag("disable", "False")
    setup$closeTag()
    for (i in 1:length(def_species)) {     #insert spcies to xml
      setup$addTag("actualSpecies", close=FALSE)
      setup$addTag("kID", def_species[i])
      setup$closeTag()
    }
    setup$closeTag()
    saveXML(setup$value(), file=paste("c:/eigene_programme/ForClim/ForClim_Setup.xml"))
    #start model
    setwd("c:/eigene_programme/ForClim")  
    system(shQuote("c:/eigene_programme/ForClim/ForClim.exe"))
    #save data
    file.copy("c:/eigene_programme/ForClim/output/rcp85_Terfens_Results/Species_Results/BA_Mean.DAT",
              paste("c:/data/nawi/ws_2020/I3_project/forclim/results_batch/rcp85/BA_Mean_",b,".DAT"))
    file.copy("c:/eigene_programme/ForClim/output/rcp85_Terfens_Results/Species_Results/Vol_Mean.DAT",
              paste("c:/data/nawi/ws_2020/I3_project/forclim/results_batch/rcp85/Vol_Mean_",b,".DAT")) 
    file.copy("c:/eigene_programme/ForClim/output/rcp85_Terfens_Results/Stand_Results/Mean.DAT",
              paste("c:/data/nawi/ws_2020/I3_project/forclim/results_batch/rcp85/Stand_Mean_",b,".DAT"))    
}