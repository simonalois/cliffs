###R-script for importing tree data to ForClim model

library(rgdal)
library(XML)

#create list of 200 modelling patches out of 8x24 + 8 random patches from the present forest stand 
patch_no <- rep(c(1:24), times=8)
patch_no <- append(patch_no, sample(1:24, 8, replace=FALSE))
length(patch_no)

#load tree data
setwd("C:/data/nawi/ws_2020/I3_project/argis_prj/shp/trees_patch/")
tree_patch.shp <- readOGR(".", "terfens_trees_patches")
tree_patch <- as.data.frame(tree_patch.shp) 
dim(tree_patch)
str(tree_patch)
tree_patch <- tree_patch[,-c(6,7)]
names(tree_patch) <- c("BaumNr", "ba", "bhd", "h", "ID")
tree_patch$ba <- plyr::revalue(tree_patch$ba, c("BAh"="Acer pseudoplatanus", "Fb"="Frangula alnus", "Fi"="Picea abies", "Ki"="Pinus sylvestris", 
                                                "LÃ¤"="Larix decidua", "Ski"="Pinus nigra", "Ta"="Abies alba", "Th"="deadwood"))
tree_patch <- tree_patch[!(tree_patch$ba %in% c("deadwood")),]
tree_patch <- tree_patch[!(tree_patch$ba %in% c("Frangula alnus")),]
tree_patch$ba <- plyr::revalue(tree_patch$ba, c("Pinus nigra"="Pinus sylvestris"))
tree_patch$ID <- as.numeric(tree_patch$ID)
tree_patch$h <- tree_patch$h*100
hist(tree_patch$ID)
dim(tree_patch)
str(tree_patch)

write.csv(tree_patch, "c:/data/nawi/ws_2020/I3_project/data_stand/tree_patch_data.csv")
tree_patch <- read.csv("C:/data/nawi/ws_2020/I3_project/data_stand/tree_patch_data.csv", row.names=1)

#add regeneration data, based on field estimations
regeneration_add <- read.csv("C:/data/nawi/ws_2020/I3_project/data_stand/regeneration_add2.csv", sep=";")
dim(regeneration_add)
tree_patch <- rbind(tree_patch, regeneration_add)
dim(tree_patch)

#add planting data, based on best species (400 Quercus petraea, 200 Tilia cordata)
planting_add <- read.csv("C:/data/nawi/ws_2020/I3_project/data_stand/planting_add.csv", sep=";")
tree_patch <- rbind(tree_patch, planting_add)

#speciesName <- c("Acer pseudoplatanus", "Picea abies",  "Pinus sylvestris", "Larix decidua", "Abies alba")
speciesName <- c("Acer pseudoplatanus", "Picea abies",  "Pinus sylvestris", "Larix decidua", "Abies alba", "Quercus petraea", "Tilia cordata" )
#speciesID <- c("09", "02", "05", "01", "00")
speciesID <- c("09", "02", "05", "01", "00", "21", "27")
species_df <- as.data.frame(cbind(speciesName, speciesID))
species_df

#create and fill XML-file with present tree data
stand<- xmlOutputDOM("plantState")
stand$addTag("version", "4.0.1") 
#loop for runID
for (i in 1:length(patch_no)){                    
  stand$addTag("modelRun", attrs=c("runID"=i-1), close=FALSE)
  i_patchID <- patch_no[i]
  i_tree_patch <- subset(tree_patch, ID == i_patchID)
  i_speciesList <- unique(i_tree_patch$ba)
  i_speciesList <- droplevels(i_speciesList)
  #loop for speciesID
  for (j in 1:length(i_speciesList)){                                             
    j_speciesName <- i_speciesList[j]   
    j_speciesName <- droplevels(j_speciesName)
    j_speciesID <- species_df$speciesID[species_df$speciesName %in% j_speciesName]
    j_tree_patch <- i_tree_patch[i_tree_patch$ba %in% j_speciesName,]
    
    stand$addTag("species", attrs=c("speciesID"=paste(j_speciesID), "speciesName"=paste(j_speciesName)), close=FALSE)
    #loop for trees
    for (k in 1:nrow(j_tree_patch)){
      stand$addTag("cohort", close=FALSE)
      stand$addTag("D", j_tree_patch[k, "bhd"])
      stand$addTag("H", j_tree_patch[k, "h"])
      stand$addTag("Trs", "1")
      stand$addTag("SGr", "0")
      stand$closeTag()
    }
    stand$closeTag()
  }
  stand$closeTag() #close modelRun
}

#save XML to folder
saveXML(stand$value(), file=paste("c:/data/nawi/ws_2020/I3_project/forclim/setup_cc/Data/States/stand_terfens.xml")) 
saveXML(stand$value(), file=paste("c:/data/nawi/ws_2020/I3_project/forclim/setup_rcp45/Data/States/stand_terfens.xml")) 
saveXML(stand$value(), file=paste("c:/data/nawi/ws_2020/I3_project/forclim/setup_rcp85/Data/States/stand_terfens.xml")) 
saveXML(stand$value(), file=paste("C:/eigene_programme/ForClim/Data/States/stand_terfens.xml"))
saveXML(stand$value(), file=paste("C:/eigene_programme/ForClim/Data/States/stand_terfens_planted.xml"))
