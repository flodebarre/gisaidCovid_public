## Quick date analysis

# Load data
dat <- read.csv("data/2022-03-07_France.csv")
dim(dat)
head(dat)

# Format dates
dat$SubmissionDate <- as.Date(dat$covv_subm_date)
dat$CollectionDate <- as.Date(dat$covv_collection_date)

dat$SubmissionWeek <- format(dat$SubmissionDate, "%Y-%W")

dat$lengthCollectionDate <- nchar(dat$covv_collection_date)
table(dat$lengthCollectionDate)

# Labs
sort(table(dat$covv_subm_lab), decreasing = TRUE)[1:10]

# Extract names of the main labs
mainLabs <- names(sort(table(dat$covv_subm_lab), decreasing = TRUE)[1:4])
mainLabs

names(mainLabs) <- c("HCL", "HMN", "IHU", "IPP")

# Turn into dictionary  
dicMainLabs <- names(mainLabs)
names(dicMainLabs) <- mainLabs

# Subset of the data from the main labs
sub <- dat[is.element(dat$covv_subm_lab, mainLabs), ]

# Restrict to 2021-Emergen
sub <- sub[sub$covv_subm_date >= "2021-02-01", ]

sub$SubmittingLab <- dicMainLabs[sub$covv_subm_lab]

table(sub$lengthCollectionDate, sub$SubmittingLab)

# Aggregate the data by week, submitting lab, and date format
out <- aggregate(sub$lengthCollectionDate, by = list(lab = sub$SubmittingLab, week = sub$SubmissionWeek, dateFormat = sub$lengthCollectionDate), FUN = length)
names(out)[names(out) == "x"] <- "nbSeq"

# Extract total number of sequences, irrespective of date format
tmp <- aggregate(sub$lengthCollectionDate, by = list(lab = sub$SubmittingLab, week = sub$SubmissionWeek), FUN = length)
names(tmp)[names(tmp) == "x"] <- "totSeq"

# Add tot number information
out <- merge(out, tmp, by = c("lab", "week"), all = TRUE)

out[1, ]

# Add missing combinations of parameters to homogenize barplots
allparms <- expand.grid(lab = unique(out$lab), week = sort(unique(out$week)), dateFormat = unique(out$dateFormat), stringsAsFactors = FALSE)
out <- merge(allparms, out, all = TRUE)

# Proportion of each date format for each date and lab
out$fracSeq <- out$nbSeq / out$totSeq
# Remove NAs to make sure plotting happens
out[is.na(out)] <- 0

# Format dates
weeks <- sort(unique(out$week))
weeksAsDays <- format(as.Date(paste0(weeks, "-1"), "%Y-%U-%u"), format = "%Y-%m-%d")
names(weeksAsDays) <- weeks
out$weekAsDate <- weeksAsDays[out$week]

#### PLOT ####

par(las = 1, mgp = c(2, 0.5, 0), tck = -0.015)
par(mar = c(3.5, 3.5, 3, 0.5))
cols <- c(gray(0.2), gray(0.5), "#77C66E")
layout(matrix(1:4, ncol = 2))
for(lab in unique(out$lab)){
  subout <- out[out$lab == lab, ]
  barplot(fracSeq ~ dateFormat + weekAsDate, data = subout, border = gray(0.9), lwd = 0.5,
          xlab = "Submission week", ylab = "Proportions of date formats ", main = lab, 
          col = cols)
  par(xpd = TRUE)
  legend(horiz = TRUE, cex = 0.7, x = "top", inset = c(0, -0.065), col = cols, legend = c("YYYY", "YYYY-MM", "YYYY-MM-DD"), pch = 15, bty = "n", pt.cex = 1.2)
  par(xpd = FALSE)
}






