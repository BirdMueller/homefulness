library(shiny)
library(DT)

# Define UI for miles per gallon application
shinyUI(
  navbarPage("My Application",
    tabPanel("Race Bar Plot",
      pageWithSidebar(
        headerPanel("People"),
        sidebarPanel(
          selectInput("variable", "Variable:",
                      list("White" = "White",
                           "Black" = "Black"))
        ),
        mainPanel(
          plotOutput("barPlot")
        )
      )
    ),
    tabPanel("Table With Scores",
      pageWithSidebar(
        headerPanel("People"),
        sidebarPanel(
          selectInput("variable", "Variable:",
          list("White" = "White",
          "Black" = "Black"))
        ),
        mainPanel(
          dataTableOutput("table")
        )
      )    
    ),
    tabPanel("A Map",
      pageWithSidebar(
        headerPanel("Map"),
        sidebarPanel(
         selectInput("variable", "Variable:",
                     list("White" = "White",
                          "Black" = "Black"))
        ),
        mainPanel(
          plotOutput("map")
        )
      )     
             
             
    )
  )  
)
