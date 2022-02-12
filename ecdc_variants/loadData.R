#### VARIANT DATA ####

###### Load ######
# Load data
dat.tessy.all <- read.csv("../data_public/tessy.csv", sep = ",", stringsAsFactors = FALSE)

## Clean data
# Get first day of the week
dat.tessy.all$year_week2 <- dat.tessy.all$year_week
dat.tessy.all[dat.tessy.all$year_week == "2020-53", "year_week2"] <- "2021-00"
dat.tessy.all$date1 <- as.Date(paste0(dat.tessy.all$year_week2, "-1"), "%Y-%W-%w")
# Note: I am not sure about the date format used in the data. There is an error for 2020-53, which I why I am changing it to 2021-00. This is not ideal, but this is just one week so for the moment, we are juste noting the issue, and we'll see later who to fix it. 
# - it is one week in 2020
# - there are almost not VOCs in 2020

# https://www.epochconverter.com/weeks/2021
unique(dat.tessy.all[dat.tessy.all$year_week == "2020-53", "date1"])
# Supposed to be 28-Dec
unique(dat.tessy.all[dat.tessy.all$year_week == "2021-01", "date1"])
# OK, 4-Jan
unique(dat.tessy.all[dat.tessy.all$year_week == "2020-52", "date1"])
# Supposed to be 21-Dec

dat.gisaid <- dat.tessy.all[dat.tessy.all$source == "GISAID", ]
dat.tessy <- dat.tessy.all[dat.tessy.all$source == "TESSy", ]

###### Clean ######

## GISAID 

variants.gisaid <- unique(dat.gisaid$variant)

# vars is the unique variant names
# This may have to be updated
vars <- c("AT.1", 
          "AY.4.2", 
          "B.1.1.529", 
          "B.1.1.7", 
          "B.1.1.7+E484K", 
          "B.1.351", 
          "B.1.427/B.1.429", 
          "B.1.525", 
          "B.1.526",
          "B.1.616", 
          "B.1.617", 
          "B.1.617.1", 
          "B.1.617.2", 
          "B.1.617.3", 
          "B.1.620", 
          "B.1.621", 
          "B.1.640", 
          "C.1.2", 
          "C.37", 
          "P.1", 
          "P.3", 
          "UNK", 
          "Other")

stopifnot(all(vars == variants.gisaid))

# Convert into OMS names
OMS <- c("Other", 
         "Delta", 
         "Omicron", 
         "Alpha", 
         "Alpha", 
         "Beta", 
         "Epsilon", 
         "Eta", 
         "Iota",
         "Other", 
         "Other", # B.1.617
         "Kappa", 
         "Delta", 
         "Other", 
         "Other", 
         "Mu", 
         "B.1.640", 
         "C.1.2", 
         "Lambda", 
         "Gamma", 
         "Theta", 
         "Unknown", 
         "Other")

# Turn into dictionnary
dic.OMS <- OMS
names(dic.OMS) <- vars
dic.OMS

# Rename variants
dat.gisaid$varOMS <- dic.OMS[dat.gisaid$variant]

## TESSy

variants.tessy <- unique(dat.tessy$variant)

# Check that they are included
cbind(variants.tessy, is.element(variants.tessy, variants.gisaid))

# One difference: SGTF
# dat.tessy[dat.tessy$variant == "SGTF", ]


# More coarse description with just the VOCs and not all variants
dic.VOCs <- c("Other", 
              "Delta", 
              "Omicron", 
              "Alpha", 
              "Alpha", 
              "Beta", 
              "Other", 
              "Other", 
              "Other",
              "Other", 
              "Other", # B.1.617
              "Other", 
              "Delta", 
              "Other", 
              "Other", 
              "Other", 
              "Other", 
              "Other", 
              "Other", 
              "Gamma", 
              "Other", 
              "Unknown", 
              "Other")
names(dic.VOCs) <- vars
dic.VOCs

dat.gisaid$VOC <- dic.VOCs[dat.gisaid$variant]  
unique(dat.gisaid$VOC)

# Clean aberrant data
dat.gisaid[is.element(dat.gisaid$VOC, c("Omicron", "Delta")) & dat.gisaid$date1 < "2021-02-01", "number_detections_variant"] <- 0

##### Other #####

# Rename VOCs to reorder columns
# For proportions
dicc.props <- c("1_Omicron", "2_Delta", "3_Gamma", "4_Beta", "5_Alpha", "6_Unknown", "7_Other")
names(dicc.props) <- c("Omicron", "Delta", "Gamma", "Beta", "Alpha", "Unknown", "Other")

# For cases
dicc.cases <- c("7_Omicron", "6_Delta", "5_Gamma", "4_Beta", "3_Alpha", "2_Unknown", "1_Other")
names(dicc.cases) <- names(dicc.props)
dicc.cases <- dicc.cases[order(dicc.cases)]

#### CASES ####

##### Load #####

cas.ECDC <- read.csv("../data_public/ECDC_Cas.csv", na.strings = "", fileEncoding = "UTF-8-BOM") # As suggested on the ECDC webpage

head(cas.ECDC)

# Format data
# Date
cas.ECDC$date <- as.Date(cas.ECDC$dateRep, format = "%d/%m/%Y")
#data.frame(cas.ECDC$date, cas.ECDC$dateRep) # Check

# Ignore corrections
cas.ECDC[which(cas.ECDC$cases < 0), "cases"] <- NA

#### SAVE ####
save(file = "data.RData", cas.ECDC, dat.gisaid, dicc.cases, dicc.props)

