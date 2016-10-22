library(shiny)

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
    tabPanel("Disability Status", plotOutput("piePlot")),
    tabPanel("YourViz2")
  )  
)
