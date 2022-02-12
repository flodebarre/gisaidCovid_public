#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

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
      
        # Show a plot of the generated distribution
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
      p("ablabalba")
    ),
    fluidRow(
      column(width = 6, 
             h5("Data"),
             HTML("<p>The data on which these plots are based come from the European Centre for Disease Prevention and Control (ECDC). <ul><li>Variant data come from <a href = 'https://www.ecdc.europa.eu/en/publications-data/data-virus-variants-covid-19-eueea'>there</a>, which synthetizes data extracted from GISAID. We gratefully acknowledge both the originating and submitting laboratories for the sequence data in GISAID EpiCoV on which these outputs are partially based.</li> 
<li>Case data come from <a href = 'https://www.ecdc.europa.eu/en/publications-data/data-daily-new-cases-covid-19-eueea-country'>this other page</a>. </li></ul></p>"),
      ), 
      column(width = 6, 
             h5("Code"),
             HTML("<p>The source code of this Shiny app is available <a href = 'https://github.com/flodebarre/covid_vaccination/tree/main/ecdc-vaccination'>on Github</a>. You are welcome to check it and to <a href = 'mailto:florence.debarre@normalesup.org?subject=ShinyApp'>let me know</a> if you find mistakes or know better ways of doing it. </p>")
      )
    )
)
)
