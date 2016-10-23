library(shiny)
library(DT)
library(leaflet)

# Define UI for miles per gallon application
shinyUI(
  navbarPage("Homefulness Portal",
    tabPanel("Population Summary",
      pageWithSidebar(
        headerPanel("People"),
        sidebarPanel(
          selectInput("variable", "Variable:",
                      list("White" = "White",
                           "Black" = "Black")),
          selectInput("updatePeople", "Auto-Update:",
                      list("No" = "No",
                           "Yes" = "Yes"))
        ),
        mainPanel(
          plotOutput("barPlot")
        )
      )
    ),
    tabPanel("Population Demographics", plotOutput("piePlot")),	# end tabPanel
    tabPanel("Population Detail",
      pageWithSidebar(
        headerPanel("People"),
        sidebarPanel(
          selectInput("variable", "Variable:",
            list("White" = "White",
            "Black" = "Black")),
          selectInput("updateTable", "Auto-Update:",
                      list("No" = "No",
                           "Yes" = "Yes"))
        ),
        mainPanel(
          dataTableOutput("table")
        )
      )    
    ),
    tabPanel("Geography",
      pageWithSidebar(
        headerPanel("Map"),
        sidebarPanel(
         selectInput("variable", "Variable:",
                     list("White" = "White",
                          "Black" = "Black")),
         selectInput("updateMap", "Auto-Update:",
                     list("No" = "No",
                          "Yes" = "Yes"))
        ),
        mainPanel(
          plotOutput("mymap")
        )
      )
    ),
    ###begin Becky's visualizations
    tabPanel("Changes Over Time", 
             pageWithSidebar(
               headerPanel("Numerics To Plot"),
               sidebarPanel(
                 selectInput("histVar", "Info to Plot:",
                             list("Months Homeless" = "MonthsHomelessPastThreeYears",
                                  "Days on Street" = "DaysOnStreet"))
               ),
               mainPanel(
                 plotOutput("histPlot")
               ) # end mainPanel
             ) # end pageWithSidebar
    ), # end tabPanel
    tabPanel("Enrollment Heatmap", 
             plotOutput("heatPlot")
    ) # end tabPanel
    ###end Becky's visualizations
  )  
)
