library(shiny)

#setwd("C:/Users/Alexander/Documents/r sandox/globalhack6/ghack_index")
data=read.csv(paste0("test.csv"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  
  
  output$barPlot <- renderPlot({
    barplot(
      table(data[[input$variable]])
    )
  })
  
})