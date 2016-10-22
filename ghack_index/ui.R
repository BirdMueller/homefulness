library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("People"),
  sidebarPanel(
    selectInput("variable", "Variable:",
                list("White" = "White",
                     "Black" = "Black"))
  ),
  
  
  
  # Show the caption and plot of the requested variable against mpg
  mainPanel(
    plotOutput("barPlot")
  )
))