---
title: "Pour JvH"
output:
  html_document:
    df_print: paged
    keep_md: TRUE
editor_options:
  chunk_output_type: console
---

# Load and clean data


```r
thedate <- "2022-05-02"
dat <- read.csv(paste0("data/", thedate, "_", "France.tsv"), sep = "\t", stringsAsFactors = FALSE, header = FALSE)

# Load data DROM
dat2 <- read.csv(paste0("data/", thedate, "_", "Martinique.tsv"), sep = "\t", stringsAsFactors = FALSE, header = FALSE)
dat3 <- read.csv(paste0("data/", thedate, "_", "Guadeloupe.tsv"), sep = "\t", stringsAsFactors = FALSE, header = FALSE)

# Add column to distinguish metro from DROM
dat$metropole <- TRUE
dat2$metropole <- FALSE
dat3$metropole <- FALSE

# Join the datasets
dat <- rbind(dat, dat2, dat3)

# Add names 
# (names are not in the datafiles because "grep" was used to extract data)
names(dat) <- c("Virus.name", "Type", "Accession.ID", "Collection.date", "Location", "Additional.location.information", "Sequence.length", "Host", "Patient.age", "Gender", "Clade", "Pango.lineage", "Pangolin.version", "Variant", "AA.Substitutions", "Submission.date", "Is.reference", "Is.complete", "Is.high.coverage", "Is.low.coverage", "N.Content", "GC.Content")
```


```r
# Reformat dates
source("funcs_cleanDates.R")

# Full date
dat$Collection.date.YMD <- getDate(dat$Collection.date)
dat$Submission.date.YMD <- getDate(dat$Submission.date)

# Year-Month
dat$Collection.date.YM <- getYM(dat$Collection.date)
dat$Submission.date.YM <- getYM(dat$Submission.date)

# Year only
dat$Collection.date.Y <- getY(dat$Collection.date)
dat$Submission.date.Y <- getY(dat$Submission.date)

# Week
dat$Collection.date.Wk <- getWk(dat$Collection.date.YMD)
dat$Submission.date.Wk <- getWk(dat$Submission.date.YMD)
```


```r
tbS <- table(dat$Submission.date.YM)
tbS
```

```
## 
## 2020-01 2020-02 2020-03 2020-04 2020-05 2020-06 2020-07 2020-08 2020-09 2020-10 
##       2       8     109     129     142       3      15     156      79     846 
## 2020-11 2020-12 2021-01 2021-02 2021-03 2021-04 2021-05 2021-06 2021-07 2021-08 
##     758     696    1370    3627    6901   13111   14381   11671    7953   24289 
## 2021-09 2021-10 2021-11 2021-12 2022-01 2022-02 2022-03 2022-04 
##   20923   18081   22509   30458   30951   37850   52151   26457
```

```r
tbC <- table(dat$Collection.date.YM)
tbC
```

```
## 
## 2020-01 2020-02 2020-03 2020-04 2020-05 2020-06 2020-07 2020-08 2020-09 2020-10 
##      93      49    2656    2194     293      89     223    1604    1930    2662 
## 2020-11 2020-12 2021-01 2021-02 2021-03 2021-04 2021-05 2021-06 2021-07 2021-08 
##    1994    1383    6359    7761   17851   11190    7256    4902   26813   28245 
## 2021-09 2021-1- 2021-10 2021-11 2021-12 2022-01 2022-02 2022-03 2022-04 
##   11324       1   17197   34269   36735   39471   25319   25337    8071
```

```r
table(dat$Collection.date.Wk)
```

```
## 
## 2020-W01 2020-W03 2020-W04 2020-W05 2020-W06 2020-W07 2020-W08 2020-W09 
##        3        5       10        4        2        5       43      158 
## 2020-W10 2020-W11 2020-W12 2020-W13 2020-W14 2020-W15 2020-W16 2020-W17 
##      279      570      808      820      635      287      136      117 
## 2020-W18 2020-W19 2020-W20 2020-W21 2020-W22 2020-W23 2020-W24 2020-W25 
##       82       33       32       33       10       28       16       13 
## 2020-W26 2020-W27 2020-W28 2020-W29 2020-W30 2020-W31 2020-W32 2020-W33 
##       13       33       38       48       94       92      149      134 
## 2020-W34 2020-W35 2020-W36 2020-W37 2020-W38 2020-W39 2020-W40 2020-W41 
##      117      408      415      345      145      203      225      262 
## 2020-W42 2020-W43 2020-W44 2020-W45 2020-W46 2020-W47 2020-W48 2020-W49 
##      604      621      401      337      285      167      179      154 
## 2020-W50 2020-W51 2020-W52 2021-W01 2021-W02 2021-W03 2021-W04 2021-W05 
##      250      238      276      658      829      948     2009     1587 
## 2021-W06 2021-W07 2021-W08 2021-W09 2021-W10 2021-W11 2021-W12 2021-W13 
##     1037     1644     1368     3619     2314     4878     2585     3501 
## 2021-W14 2021-W15 2021-W16 2021-W17 2021-W18 2021-W19 2021-W20 2021-W21 
##     1652     3229     1698     2723     1077     2102      998     1954 
## 2021-W22 2021-W23 2021-W24 2021-W25 2021-W26 2021-W27 2021-W28 2021-W29 
##      637     1383      431     1271     1490     2774     5962    10322 
## 2021-W30 2021-W31 2021-W32 2021-W33 2021-W34 2021-W35 2021-W36 2021-W37 
##     7166     5214     5776     5393     4606     3625     2605     2146 
## 2021-W38 2021-W39 2021-W40 2021-W41 2021-W42 2021-W43 2021-W44 2021-W45 
##     1934     1626     1760     1980     3738     7501     6374     5686 
## 2021-W46 2021-W47 2021-W48 2021-W49 2021-W50 2021-W51 2021-W52 2022-W01 
##     6611     5498     6956     6833     7541     6816    10493     8474 
## 2022-W02 2022-W03 2022-W04 2022-W05 2022-W06 2022-W07 2022-W08 2022-W09 
##     7760     7110     6663     6232     5653     4317     6573     6106 
## 2022-W10 2022-W11 2022-W12 2022-W13 2022-W14 2022-W15 2022-W16 2022-W17 
##     5871     5787     6638     6163     4212     3168      282        8
```

```r
table(dat$Submission.date.Wk)
```

```
## 
## 2020-W04 2020-W05 2020-W06 2020-W07 2020-W10 2020-W11 2020-W12 2020-W13 
##        2        2        1        5       17       27       44       69 
## 2020-W14 2020-W15 2020-W16 2020-W17 2020-W19 2020-W24 2020-W27 2020-W29 
##       37        1       22       21      142        3       13        2 
## 2020-W30 2020-W31 2020-W35 2020-W39 2020-W41 2020-W42 2020-W43 2020-W44 
##        2      146        8      811       16       93        5       78 
## 2020-W45 2020-W46 2020-W47 2020-W48 2020-W49 2020-W50 2020-W51 2020-W52 
##       63      359      179      196      190       67      127      195 
## 2021-W01 2021-W02 2021-W03 2021-W04 2021-W05 2021-W06 2021-W07 2021-W08 
##      130      213      223      804     1184      601      774     1068 
## 2021-W09 2021-W10 2021-W11 2021-W12 2021-W13 2021-W14 2021-W15 2021-W16 
##      968     1212     1546     1784     2290     1481     1657     3917 
## 2021-W17 2021-W18 2021-W19 2021-W20 2021-W21 2021-W22 2021-W23 2021-W24 
##     5161     1936     2369     2607     6118     3377     2891     2878 
## 2021-W25 2021-W26 2021-W27 2021-W28 2021-W29 2021-W30 2021-W31 2021-W32 
##     2810     1761     1832     1376     2030     2016     2878     4886 
## 2021-W33 2021-W34 2021-W35 2021-W36 2021-W37 2021-W38 2021-W39 2021-W40 
##     8793     3467     6256     1052     8557     6393     4008     3871 
## 2021-W41 2021-W42 2021-W43 2021-W44 2021-W45 2021-W46 2021-W47 2021-W48 
##     1860     1527     9745     1842     3380     8902     5469     5517 
## 2021-W49 2021-W50 2021-W51 2021-W52 2022-W01 2022-W02 2022-W03 2022-W04 
##     9052     8220     6785     3806     9719     6961     6970     4657 
## 2022-W05 2022-W06 2022-W07 2022-W08 2022-W09 2022-W10 2022-W11 2022-W12 
##     9167    11841    11028     7933     8825     6684     7217    23197 
## 2022-W13 2022-W14 2022-W15 2022-W16 2022-W17 
##     6952     5247     5964     5713     9328
```

Submissions in 2022: 147409  
Submissions since 2022-03-15: 63317
