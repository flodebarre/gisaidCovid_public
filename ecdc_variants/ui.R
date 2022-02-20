# Flo Débarre, Feb 2022

library(shiny)

# Load data
# (obtained from `loadData.R`)
load("data.RData")

# Load functions
source("functions.R")
source("plotParameters.R")


# All countries (for drop-down list)
ctrs <- sort(unique(dat.gisaid$country))
  
# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Variants in ECDC countries"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        flowLayout(
          selectInput("country", "Country", ctrs, selected = "France"), 
          radioButtons("type", "Type of graph", choices = list("Proportions" = "proportions", "Cases" = "cases"), selected = "cases"), 
          radioButtons("withOther", "Show unknown variants", choices = list("Yes" = TRUE, "No" = FALSE), selected = FALSE), 
          dateInput("minDate", "Start date", value = "2020-10-05", min = "2020-10-05", max = max(dat.gisaid$date1) - 30, startview = "month", weekstart = 1),
          #
          selectInput("palette", "Color palette", c("Nextstrain", "SPF", "Hiroshige", "Isfahan2", "Moreau", "Signac", "Troy"), selected = "Nextstrain")
        ) 
      ),
      
        mainPanel(
          fluidRow(
            plotOutput("variantsPlot")
          ), 
          fluidRow(class = "text-center",
            downloadButton('downloadPlot', 'Download Plot')
          )
        )
    ),
    
    fluidRow(
    ),
    fluidRow(
      column(width = 6, 
             h5("Data"),
             HTML("<p>The data on which these plots are based come from the European Centre for Disease Prevention and Control (ECDC). <ul><li>Variant data come from <a href = 'https://www.ecdc.europa.eu/en/publications-data/data-virus-variants-covid-19-eueea'>there</a>, which synthetizes data extracted from GISAID. We gratefully acknowledge both the originating and submitting laboratories for the sequence data in GISAID EpiCoV on which these outputs are partially based.</li> 
<li>Case data come from <a href = 'https://www.ecdc.europa.eu/en/publications-data/data-daily-new-cases-covid-19-eueea-country'>this other page</a>. </li></ul></p>"),
      ), 
      column(width = 6, 
             h5("Code"),
             HTML("<p>The source code of this Shiny app is available <a href = 'https://github.com/flodebarre/gisaidCovid_public/tree/main/ecdc_variants'>on Github</a>. You are welcome to check it and to <a href = 'mailto:florence.debarre@normalesup.org?subject=ShinyApp_ECDC'>let me know</a> if you find mistakes or know better ways of doing things. </p>")
      )
    ), 
    h3("Credits"), 
    HTML("The default color palette is the one used on <a href = 'https://nextstrain.org/ncov/gisaid/global'>Nextstrain</a> in Feb 2022. The palettes with names of famous painters are from the <a href = 'https://github.com/BlakeRMills/MetBrewer'>MetBrewer</a> package."), 
    h3("Frequently Asked Questions"),
    h5("Why can I not find the UK?"),
    p("The UK has left the UE and does not participate in the ECDC network anymore."),
    h5("Why can I not find Switzerland?"), 
    p("Switzerland does not participate in the ECDC network."), 
    h5("But why can I find Norway?"), 
    HTML("As per the ECDC's <a href = 'https://www.ecdc.europa.eu/en/about-us/who-we-work/eu-partners'>own description</a>, they <i>[work] closely with the EU Member States and with the EEA countries (Norway, Iceland, and Liechtenstein).</i>"), 
    h5("What did you use to build this app / to plot the graphs?"),
    HTML("It is a <a href = 'https://shiny.rstudio.com/tutorial/'>Shiny app</a>, it is based on <a href = 'https://cran.r-project.org'>R code</a>. The app's source code is available <a href = 'https://github.com/flodebarre/gisaidCovid_public/tree/main/ecdc_variants'>on Github</a>."),
    fluidRow(HTML("&nbsp;"))
))
