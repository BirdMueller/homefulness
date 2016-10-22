library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("NFL Play-By-Play"),
  sidebarPanel(
    selectInput("variable", "Variable:",
                list("All Yards" = "Yds",
                      "Running" = "Yds.2", 
                     "Passing" = "Yds.1"))
  ),
  
  
  
  # Show the caption and plot of the requested variable against mpg
  mainPanel(
    plotOutput("barPlot")
  )
))