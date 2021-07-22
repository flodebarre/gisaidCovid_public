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

# Save GISAID data in there
dat.gisaid.FR <- dat.tessy.FR[dat.tessy.FR$source == "GISAID", ]

# Check that no duplicates
stopifnot(!any(duplicated(dat.gisaid.FR[dat.gisaid.FR$variant == "B.1.351", "year_week"])))
nBetaG <- sum(dat.gisaid.FR[dat.gisaid.FR$variant == "B.1.351", "number_detections_variant"])
ntotG  <- sum(dat.gisaid.FR[dat.gisaid.FR$variant == "B.1.351", "number_sequenced"])

# Extract TESSy data only
dat.tessy.FR <- dat.tessy.FR[dat.tessy.FR$source == "TESSy", ]
stopifnot(!any(duplicated(dat.tessy.FR[dat.tessy.FR$variant == "B.1.351", "year_week"])))
nBetaT <- sum(dat.tessy.FR[dat.tessy.FR$variant == "B.1.351", "number_detections_variant"])
ntotT <- sum(dat.tessy.FR[dat.tessy.FR$variant == "B.1.351", "number_sequenced"])


ecdc <- data.frame(cbind(source = c("TESSy", "GISAID")))
ecdc$nb_seq_beta <- c(nBetaT, nBetaG)
ecdc$nb_seq_tot <- c(ntotT, ntotG)
ecdc$p <- ecdc$nb_seq_beta/ecdc$nb_seq_tot
ecdc


