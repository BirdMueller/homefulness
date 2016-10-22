library(shiny)



#setwd("C:/Users/Alexander/Documents/GitHub/homefulness/ghack_index")
data=read.csv(paste0("test.csv"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output, session) {
  
  clone_data_row<-function(dataFrame){
    return(rbind(dataFrame,dataFrame[sample(1:nrow(dataFrame),1),]))
  } 
  
  output$barPlot <- renderPlot({
    invalidateLater(10, session)
    data<<-clone_data_row(data)
    barplot(
      table(data[[input$variable]])
    )
  })
  
})