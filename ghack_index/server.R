library(shiny)
library(DT)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

city<-map_data('county')[map_data('county')$subregion=='st louis city',]
chaifetz<-data.frame(lat=c(38.63246),long=c(-90.22797))

#setwd("C:/Users/Alexander/Documents/GitHub/homefulness/ghack_index")
data=read.csv(paste0("test.csv"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output, session) {
  
  clone_data_row<-function(dataFrame){
    return(rbind(dataFrame,dataFrame[sample(1:nrow(dataFrame),1),]))
  } 
  
  output$barPlot <- renderPlot({
    if(input$updatePeople=="Yes"){
      invalidateLater(1, session)
      data<<-clone_data_row(data)      
    }
    barplot(
      table(data[[input$variable]])
    )
  })
  
  output$table <- renderDataTable({
    if(input$updateTable=="Yes"){
      invalidateLater(10000, session)
      data<<-clone_data_row(data)      
    }
    data[c('First_Name','Last_Name')]
  })
  
  output$map <- renderPlot({
    p <- ggplot(data=city)+ 
      geom_polygon(aes(x = long, y = lat, group = group), fill = NA, color = "black") + 
      geom_point(data = chaifetz, aes(x = long, y = lat), color = "black", size = 1) +
      coord_fixed(1.3)
    print(p)
  })
})