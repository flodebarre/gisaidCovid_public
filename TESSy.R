# Source https://www.ecdc.europa.eu/en/publications-data/data-virus-variants-covid-19-eueea
URL <- "https://opendata.ecdc.europa.eu/covid19/virusvariant/csv/data.csv"

# Can set dlData in another file
# Boolean to say whether to download the data again or not
if(!exists("dlData")){
  dlData <- TRUE
}

if(dlData){
  download.file(URL, 
              destfile="data/tessy.csv",
              method="curl",
              extra='-L')
}
# Load data
dat.tessy <- read.csv("data/tessy.csv", sep = ",", stringsAsFactors = FALSE)

# Subselect data for France
dat.tessy.FR <- dat.tessy[dat.tessy$country == "France", ]
dim(dat.tessy.FR)

# Clear memory and remove other data
rm(dat.tessy)

head(dat.tessy.FR)

# Extract week and year information -- separate them
dat.tessy.FR$week <- substr(dat.tessy.FR$year_week, 6, 7)
dat.tessy.FR$year <- substr(dat.tessy.FR$year_week, 1, 4)

# Restrict to 2021
dat.tessy.FR <- dat.tessy.FR[dat.tessy.FR$year == 2021, ]
# Select only TESSy source
dat.tessy.FR <- dat.tessy.FR[dat.tessy.FR$source == "TESSy", ]
