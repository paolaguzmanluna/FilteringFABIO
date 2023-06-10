#############################################################################################
##############################  FABIO FOOTPRINTS INPUT-OUTPUT  ##############################
#############################################################################################

library(Matrix)
library(tidyverse)
library(data.table)


#TRASH BUT DONT DELETE#
#is.finite.data.frame <- function(x) do.call(cbind, lapply(x, is.finite))


#-------------------------------------------------------------------------
# Make initial settings
#-------------------------------------------------------------------------
setwd("C:/Users/paola/OneDrive - Universidade de Santiago de Compostela/PhD/R/FABIO_IO_model")
getwd()
dir()

regions <- fread(file="regions.csv")
items <- fread(file="items.csv")

nrreg <- nrow(regions)
nrcom <- nrow(items)
index <- data.table(code = rep(regions$code, each = nrcom),
                    iso3c = rep(regions$iso3c, each = nrcom),
                    country = rep(regions$name, each = nrcom),
                    continent = rep(regions$continent, each = nrcom),
                    item = rep(items$item, nrreg),
                    group = rep(items$group, nrreg))

X <- readRDS(file=paste0("X.rds"))
Y <- readRDS(file=paste0("Y.rds"))
E <- readRDS(file=paste0("E.rds"))

#what year am I interested in?
#the most recent in FABIO is 2013, so, I picked that one
year <- 2013

Xi <- X[, as.character(year)]
Yi <- Y[[as.character(year)]]
Ei <- E[[as.character(year)]]

Y_codes <- data.frame(code = substr(colnames(Yi), 1, str_locate(colnames(Yi), "_")[,1]-1))
Y_codes$iso3c = regions$iso3c[match(Y_codes$code,regions$code)]
Y_codes$continent = regions$continent[match(Y_codes$iso3c,regions$iso3c)]
Y_codes$fd <- substr(colnames(Yi), str_locate(colnames(Yi), "_")[,1]+1, 100)


#What type of allocation do I want to?
#there is mass and value. I picked mass
allocation = "mass"
#L <- readRDS(file=paste0("2013_L_mass",year,"_L_",allocation,".rds"))


#Select for 2013 with mass allocation
L <- readRDS(file=paste0("2013_L_mass.rds"))

#######################################
# BEGINNING OF THE FOOTPRINT FUNCTION #
#######################################

footprint <- function(country = "EU27", extension = "landuse", consumption = "food", allocation = "value"){
  # Prepare Multipliers
  ext <- as.vector(as.matrix(as.vector(Ei[, ..extension]) / as.vector(Xi)))
  ext[!is.finite(ext)] <- 0
  MP <- ext * L
  
  # define final demand vector
  if(country=="EU27"){
    Y_country <- Yi[, (Y_codes$continent == "EU" & Y_codes$iso3c != "GBR"), with=FALSE]
    colnames(Y_country) <- Y_codes$fd[Y_codes$continent == "EU" & Y_codes$iso3c != "GBR"]
    Y_country <- agg(Y_country)
  } else if(country=="EU"){
    Y_country <- Yi[, Y_codes$continent == "EU", with=FALSE]
    colnames(Y_country) <- Y_codes$fd[Y_codes$continent == "EU"]
    Y_country <- agg(Y_country)
  } else {
    Y_country <- Yi[, Y_codes$iso3c == country]
    colnames(Y_country) <- Y_codes$fd[Y_codes$iso3c == country]
  }
  
  # calculate footprint
  if(consumption=="production"){
    FP <- t(t(MP) * as.vector(as.matrix(Xi)))
  } else {
    FP <- t(t(MP) * as.vector(as.matrix(Y_country[,consumption])))
  }
  
  colnames(FP) <- rownames(FP) <- paste0(index$iso3c, "_", index$item)
  # in case of calculating production footprints, we just keep those of the relevant countries
  if(consumption=="production"){
    if(country=="EU27"){
      FP <- FP[, index$continent=="EU" & index$iso3c!="GBR" & index$item %in% c("Milk - Excluding Butter", "Butter, Ghee")]
    } else if(country=="EU"){
      FP <- FP[, index$continent=="EU" & index$item %in% c("Milk - Excluding Butter", "Butter, Ghee")]
    } else {
      FP <- FP[, index$iso3c==country & index$item %in% c("Milk - Excluding Butter", "Butter, Ghee")]
    }
  }
  
  results <- FP %>% 
    as.matrix() %>% 
    as_tibble() %>% 
    mutate(origin = paste0(index$iso3c, "_", index$item)) %>% 
    gather(index, value, -origin) %>% 
    mutate(country_origin = substr(origin,1,3)) %>% 
    mutate(item_origin = substr(origin,5,100)) %>% 
    mutate(country_producer = substr(index,1,3)) %>% 
    mutate(final_product = substr(index,5,100)) %>% 
    select(-index, -origin) %>% 
    filter(value != 0)
  
  if(consumption!="production"){
    results <- results %>% 
      mutate(country_consumer = country)
  }
  
  results$group_origin <- items$comm_group[match(results$item_origin,items$item)]
  results$continent_origin <- regions$continent[match(results$country_origin, regions$iso3c)]
  results$continent_origin[results$country_origin==country] <- country
  
  return(results)
}

##################################
# END OF THE FOOTPRINT FUNCTION ##
##################################


# consumption_categories <- c("food","other","stock_addition","losses","balancing") I CAN USE EITHER ONE OF THESE CATEGORIES
consumption = "production"
# countries <- regions$iso3c[regions$continent=="EU"]
# countries <- country <- "EU27"
countries <- country <- "EU" #UK
extension = "biomass" #here i can also pick "land use" and it will appear as ha., now it is in tonnes 
agg <- function(x) { x <- as.matrix(x) %*% sapply(unique(colnames(x)),"==",colnames(x));  return(x) }

#--------------------------------------------------------------------------
# RUN BEFORE CALCULATING THE FOOTPRINTS. It solves the memory RAM problem 
#--------------------------------------------------------------------------

if(.Platform$OS.type == "windows") withAutoprint({
  memory.size()
  memory.size(TRUE)
  memory.limit()
})
memory.limit(size=56000)
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------

# calculate production footprints
results <- footprint(country = country, extension = extension, consumption = consumption, allocation = allocation)
View(results)


# calculate consumption footprints
results <- tibble()
for(country in countries){
  results <- rbind(results, 
                   footprint(country = country, extension = extension, consumption = consumption, allocation = allocation))
}


# write csv to continue on Matlab
View(results)
write.csv(results,"resultsMatlab.csv")