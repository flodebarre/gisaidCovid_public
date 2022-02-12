#### sliding.window ####

# Function to compute a sliding window 
sliding.window <- function(v, winwdt = 7, pos = 4, na.rm = TRUE, FUN = mean){
  # v vector to be averaged/summed
  # winwdt width of the window 
  # pos position of the focal day in the window
  # FUN function to apply
  n <- length(v)
  # Initialize output vector
  out <- 0 * v + (-1)
  out[1:(pos-1)] <- NA
  out[(n + 1 - winwdt + pos) : n] <- NA
  
  for(i in pos : (n - winwdt + pos)){
    out[i] <- FUN(v[(i - pos + 1):(i + winwdt - pos)], na.rm = na.rm)
  }
  return(out[1:n])
}


#### plotVariants #####

plotVariants <- function(country, type = "proportions", withOther = FALSE, ymax = 0, palName = "Nextstrain", minDate = "2020-10-05"){
  
  pal <- getPalette(palName)
  
  # print(country)
  # print(type)
  # print(withOther)
   
  # Subset of the data
  subdat.gisaid <- dat.gisaid[which(dat.gisaid$country == country & dat.gisaid$date1 >= minDate), ]
  subdat.cases <- cas.ECDC[which(cas.ECDC$countriesAndTerritories == country), ]
  
  # Population size
  pop <- unique(subdat.cases$popData2020)
  pop <- pop[!is.na(pop)]
#  print(pop)
  
  ### CASE DATA
  # Add potentially missing dates
  dates.df <- data.frame(date = seq(min(subdat.cases$date), max(subdat.cases$date), by = "day"))
  subdat.cases <- merge(subdat.cases, dates.df, by = "date", all = TRUE)
  # Check order
  subdat.cases <- subdat.cases[order(subdat.cases$date), ]
  
  # Compute 7-d averages for cases
  subdat.cases$cases.7J <- sliding.window(subdat.cases$cases)
  subdat.cases$cases.sum7J <- 7 * subdat.cases$cases.7J
  
  # indices of non-NA values (spline only possible on non-NA)
  inona <- which(!is.na(subdat.cases$cases.7J))#4:(nrow(subdat.cases)-3)
  
  
  # Smoothen the data
  column <- "cases.7J"
  tmp <- smooth.spline(as.numeric(as.Date(subdat.cases[inona, ]$date) - as.Date(min(subdat.cases$date))), subdat.cases[inona, column], 
                       spar = 0.2)
  tmp.df <- data.frame(date = as.Date(tmp$x + min(subdat.cases$date)), cases.smoothed = tmp$y)
  # Add smoothed data to dataset
  subdat.cases <- merge(subdat.cases, tmp.df, by = "date")
  #  subdat.cases$cases.smoothed <- c(rep(NA, 3), tmp$y, rep(NA, 3))
  
  ### VARIANT DATA  
  # Aggregate variant data
  
  ####
  # 1) with "Other"
  ####
  aggVOC <- aggregate(subdat.gisaid$number_detections_variant, by = list(date1 = subdat.gisaid$date1, VOC = subdat.gisaid$VOC), FUN = sum)
  
  # Add Sample sizes
  aggSam <- aggregate(aggVOC$x, by = list(date1 = aggVOC$date1), FUN = sum)
  names(aggSam)[2] <- "tot"
  aggVOC <- merge(aggVOC, aggSam, by = "date1")
  # Compute proportions of the variants
  aggVOC$prop <- aggVOC$x / aggVOC$tot
  
  # Add case data (ECDC)
  aggVOC <- merge(aggVOC, subdat.cases, by.x = "date1", by.y = "date")
  
  ####
  # 2) Without "Other"
  ####
  aggVOC.noOther <- aggVOC[which(aggVOC$VOC != "Unknown"), c("date1", "VOC", "x")]
  
  # Sample sizes
  tmp <- aggregate(aggVOC.noOther$x, by = list(date1 = aggVOC.noOther$date1), FUN = sum)
  names(tmp)[2] <- "tot"
  aggVOC.noOther <- merge(aggVOC.noOther, tmp, by = "date1")
  aggVOC.noOther$prop <- aggVOC.noOther$x / aggVOC.noOther$tot
  
  # Add case data (ECDC)
  aggVOC.noOther <- merge(aggVOC.noOther, subdat.cases, by.x = "date1", by.y = "date")
  
  
  ## Plot proportions
  # Rename columns - latest variants first, because we want them at the bottom of the plot
  aggVOC$VOC2 <- dicc.props[aggVOC$VOC]
  aggVOC.noOther$VOC2 <- dicc.props[aggVOC.noOther$VOC]
  
  aggVOC$VOC3 <- dicc.cases[aggVOC$VOC]
  aggVOC.noOther$VOC3 <- dicc.cases[aggVOC.noOther$VOC]
  
  # Get colors in the right order
  cc.props <- vapply(names(dicc.props), function(i) pal[[paste0("col", i)]], FUN.VALUE = "x") 
  cc.cases <- vapply(names(dicc.cases), function(i) pal[[paste0("col", i)]], FUN.VALUE = "x") 
  
#  print(cc.props)
#  print(cc.cases)
  
  
  if(withOther){
    ii.props <- seq_len(length(cc.props))
    ii.cases <- seq_len(length(cc.cases))
    agg <- aggVOC
  }else{
    ii.props <- which(names(cc.props)!= "Unknown")
    ii.cases <- which(names(cc.cases)!= "Unknown")
    agg <- aggVOC.noOther
  }
  
  agg[is.na(agg$prop), "prop"] <- 0
  
  opar <- par(lwd = 0.01)
  
  agg$n <- agg$prop * agg$cases.sum7J
  
  # Standardize 
  std <- 1 / pop * 10^5
  agg$n <- agg$n * std
  
  
  
  # Initialize plot
  layout(matrix(1:2, ncol = 2), widths = c(4, 1))
  par(mar = c(4, 2.5, 2.5, 1))
  
  if(type == "proportions"){
    bp <- barplot(agg$prop ~ agg$VOC2 + agg$date1, col = cc.props[ii.props], border = "gray", 
                  axes = FALSE, names.arg = rep("", length(unique(agg$date1))), 
                  xlab = "", ylab = "")
  }
  
  if(type == "cases"){
    if(ymax == 0){
      ymax <- 1.1 * max(agg$cases.sum7J * std, na.rm = TRUE)
    }
    bp <- barplot(agg$n ~ agg$VOC3 + agg$date1, col = cc.cases[ii.cases], border = "gray", 
                  axes = FALSE, names.arg = rep("", length(unique(agg$date1))), 
                  xlab = "", ylab = "", 
                  ylim = c(0, ymax))
    
  }
  
  axis(2, pos = bp[1] - (bp[2] - bp[1])/2, lwd = 0, lwd.ticks = 1, las = 1)
  
  dates <- sort(unique(agg$date1)) # Dates in the data
  cf <- coefficients(lm(bp ~ as.numeric(dates))) # get their x positions from a linear model
  datePosition <- function(date){
    cf[1] + as.numeric(date) * cf[2]
  }
  # Position months
  months <- seq(as.Date(paste0(substr(minDate, 1, 7), "-01")), Sys.Date(), by = "month")
  
  par(xpd = TRUE)
  text(datePosition(months), rep(0, length(months)), labels = format.Date(months, "%b\n%Y"), adj = c(0.5, 1.5), cex = 0.8)
  
  axis(1, at = datePosition(months), labels = rep("", length(months)), pos = 0)
  
  title(main = country)
  
  if(type == "cases"){
    # Add daily cases
    subdat.cases <- subdat.cases[subdat.cases$date >= min(subdat.gisaid$date1), ]
    lines(datePosition(subdat.cases$date), 7* subdat.cases$cases.smoothed * std, lwd = 2)
  }
  
  # Credits
  mtext(paste0("@flodebarre, ", Sys.Date(), "
Variant Data: GISAID via ECDC, https://www.ecdc.europa.eu/en/publications-data/data-virus-variants-covid-19-eueea
Case Data: https://www.ecdc.europa.eu/en/publications-data/data-daily-new-cases-covid-19-eueea-country
Code: https://github.com/flodebarre/gisaidCovid_public/tree/main/ecdc_variants"), family = "mono", cex = 0.45, side = 1, line = 3, col = gray(0.3), adj = 0)
  
  if(type == "cases"){
    mtext(side = 3, text = "Weekly cases per 100'000 inhabitants", line = 0, cex = 0.8)
  }

  
  # Legend in separate plot
  # Initialize empty plot
  par(mar = rep(0, 4))
  plot(0, xlab = "", ylab = "", axes = FALSE, frame.plot = FALSE, type = "n")
  
  legend("left", pch = 15, col = cc.cases[ii.cases], legend = names(cc.cases[ii.cases]), inset = c(0.05, 0), bty = "n")
  
}
