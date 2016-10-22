library(shiny)

data=read.csv(paste0("2014_to.csv"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  output$barPlot <- renderPlot({
    barplot(
      data[[input$variable]][1:32],
      main="Yards By Team",
      las=2,
      names=sapply(as.character(data$Tm[1:32]),function(row){
        #print(row)
        wordVec<-strsplit(row[[1]]," ")
        #print(wordVec)
        return(wordVec[[1]][length(wordVec[[1]])])
      })
    )
  })
  
})