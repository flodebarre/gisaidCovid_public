#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load data
# (obtained from `loadData.R`)
load("data.RData")

# Load functions
source("functions.R")
source("plotParameters.R")

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
    output$variantsPlot <- renderPlot({
      plotVariants(input$country, type = input$type, withOther = input$withOther, ymax = 0, palName = input$palette, minDate = input$minDate)
    })
    
    output$downloadPlot <- downloadHandler(
      # Source: https://stackoverflow.com/questions/14810409/save-plots-made-in-a-shiny-app
      filename = function(){ paste('variants_', input$country, '-', input$type, '.pdf', sep='') },
      content = function(file){
        pdf(width = 9, height = 6, file = file)
        print(
          plotVariants(input$country, type = input$type, withOther = input$withOther, ymax = 0, palName = input$palette, minDate = input$minDate)
          )
        dev.off()
      }
    )

})
