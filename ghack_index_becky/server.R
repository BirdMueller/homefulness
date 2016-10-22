library(shiny)
library(dplyr)	# For data manipulation
library(ggplot2)

#setwd("C:/Users/Alexander/Documents/r sandox/globalhack6/ghack_index")
data=read.csv(paste0("test.csv"))
filepath <- "/data/" 	# Change to filepath where data is contained
files <- dir(filepath) 	# Grab list of .tsv files
alldata <- lapply(files, function(x) read.csv(paste0(filepath, x), sep = "\t", header = TRUE, stringsAsFactors = FALSE))
attach(alldata)
names(Client)[1] <- "PersonalID" # Rename for consistency

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
	#pie(ethdata[ethdata > 0])	# Let's not do this again
	disStatus <- group_by(Enrollment, PersonalID) %>% summarise(max(DisablingCondition, na.rm = TRUE))
	names(disStatus)[2] <- "disabled"
	disStatus$disabled[is.na(disStatus$disabled)] <- 2	# missing data
	disSummary <- table(disStatus$disabled)
	names(disSummary) <- c("Not Disabled", "Disabled", "Unknown")
	pie(disSummary, col = c("aliceblue", "tomato1", "grey"), main = "Client Disability Status")
  }) # end piePlot

  output$histPlot <- renderPlot({
	Homes <- select(Enrollment, c(2:6, 9, 12:15, 17:18))
	Homes$EntryDate <- as.POSIXct(Homes$EntryDate, format = "%m/%d/%Y")
	Homes$DateToStreetESSH <- as.POSIXct(Homes$DateToStreetESSH, format = "%m/%d/%Y")
	Homes$ResidentialMoveInDate <- as.POSIXct(Homes$ResidentialMoveInDate, format = "%m/%d/%Y")
	Homes$DaysOnStreet <- difftime(Homes$EntryDate, Homes$DateToStreetESSH, units = "days")
	
	tlist <- c("Months Homeless in Past Three Years", "Days on Street Prior to Enrollment")
	names(tlist) <- c("MonthsHomelessPastThreeYears", "DaysOnStreet")
	
	ggplot(Homes, aes(x = eval(parse(text = input$histVar)))) + stat_bin(fill = "blue", alpha = 0.5) + labs(x = "Time", y = "Clients", title = tlist[input$histVar])

  }) # end histPlot

  
})