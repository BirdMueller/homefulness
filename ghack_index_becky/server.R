library(shiny)
library(dplyr)	# For data manipulation
library(ggplot2)

#setwd("C:/Users/Alexander/Documents/r sandox/globalhack6/ghack_index")
data=read.csv(paste0("test.csv"))
filepath <- "/data/" 	# Change to filepath where data is contained
files <- dir(filepath) 	# Grab list of .tsv files
alldata <- lapply(files, function(x) read.csv(paste0(filepath, x), sep = "\t", header = TRUE, stringsAsFactors = FALSE))
attach(alldata)
names(Client)[1] <- "PersonalID"

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  output$barPlot <- renderPlot({
    barplot(
      table(data[[input$variable]])
    )
  })
  
  output$piePlot <- renderPlot({
	# 10:15 are race
	#ethdata <- select(Client, 10:15) %>% sapply(sum)
	#pie(ethdata[ethdata > 0])
	disStatus <- group_by(Enrollment, PersonalID) %>% summarise(max(DisablingCondition, na.rm = TRUE))
	names(disStatus)[2] <- "disabled"
	disStatus$disabled[is.na(disStatus$disabled)] <- 2	# missing data
	disSummary <- table(disStatus$disabled)
	names(disSummary) <- c("Not Disabled", "Disabled", "Unknown")
	pie(disSummary, col = c("aliceblue", "tomato1", "grey"), main = "Client Disability Status")
  }) # end beckyPlot
  
})