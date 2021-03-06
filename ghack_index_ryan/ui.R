library(shiny)
library(DT)
library(leaflet)

# Define UI for miles per gallon application
shinyUI(
  navbarPage("My Application",
    tabPanel("Race Bar Plot",
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
    tabPanel("Table With Scores",
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
    tabPanel("A Map",
      pageWithSidebar(
        headerPanel("Map"),
        sidebarPanel(
         selectInput("variable", "Variable:",
                     list("White" = "White",
                          "Black" = "Black")),
         selectInput("updateMap", "Auto-Update:",
                     list("City" = "City",
                          "County" = "County"))
        ),
        mainPanel(
          leafletOutput("mymap"),
          br(),
          verbatimTextOutput("out")
        )
      )
    ),
    ###begin Becky's visualizations
    tabPanel("Disability Status", plotOutput("piePlot")),	# end tabPanel
    tabPanel("Histograms", 
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
    tabPanel("Heatmap", 
             plotOutput("heatPlot")
    ) # end tabPanel
    ###end Becky's visualizations
  )  
)
