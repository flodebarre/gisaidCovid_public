# Load public data on mutations ####

URL_France <- "https://www.data.gouv.fr/fr/datasets/r/848debc4-0e42-4e3b-a176-afc285ed5401"

download.file(URL_France, 
              destfile="data/muts_France.csv",
              method="curl",
              extra='-L')
dat.France <- read.csv("data/muts_France.csv", sep = ";", stringsAsFactors = FALSE)


# Clean data #####
# Format date
dat.France$date1 <- as.Date(substring(dat.France$semaine, 1, 10))
dat.France$date2 <- as.Date(substring(dat.France$semaine, 12, 21))
# Rewrite time as days since beginning of the data
dat.France$time <- dat.France$date2 - min(dat.France$date2)

dat.France$dateMid <- as.Date(dat.France$date1 + 3)
head(dat.France)

# Get week

endDay <- max(dat.France$date2)
beginDay <- seq(base::as.Date("2021-01-04"), base::as.Date("2021-12-27"), by = 7)
endDay <- seq(base::as.Date("2021-01-10"), base::as.Date("2022-01-02"), by = 7)
weeks <- data.frame(week = 1:52)
weeks$weekBegin <- beginDay
weeks$weekEnd <- endDay

# Assign weeks
# Initialize week numbers
dat.France$week <- NA

for(iw in weeks$week){
  dat.France[which(as.Date(dat.France$date1) == as.Date(weeks[iw, "weekBegin"])), "week"] <- iw
}
table(dat.France$week, useNA = "ifany")

source('usefulFunctions.R')
