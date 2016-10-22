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
	) # end tabPanel
  )  
)
