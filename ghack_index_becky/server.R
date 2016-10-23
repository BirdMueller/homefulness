library(shiny)
library(DT)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(dplyr)
library(leaflet)

###begin Becky's data import code
filepath <- paste0(getwd(),"/data/") 	# Change to filepath where data is contained
files <- dir(filepath) 	# Grab list of .tsv files
alldata <- lapply(files, function(x) read.csv(paste0(filepath, x), sep = "\t", header = TRUE, stringsAsFactors = FALSE))
names(alldata) <- sub('[.]tsv', '', files)
#lapply(alldata, function(x) names(x) <- gsub('_', '', names(x))) # Doesn't do anything
attach(alldata)
names(Client)[1] <- "PersonalID" # Rename for consistency
###end Becky's data import code

supplement_cols<-function(dataFrame,shelterFrame){
  
  dataFrame$scoreOne<-round(runif(nrow(dataFrame)),2)
  dataFrame$scoreTwo<-round(runif(nrow(dataFrame)),2)
  
  dataFrame$shelterIndex<-sapply(dataFrame$UUID,function(row){return(sample(1:nrow(shelterFrame),1))})
  
  dataFrame$lat<-sapply(dataFrame$shelterIndex,function(row){
    return(shelterFrame$lat[[row]]+runif(1,0,0.025))
  })
  dataFrame$long<-sapply(dataFrame$shelterIndex,function(row){
    return(shelterFrame$long[[row]]+runif(1,0,0.025))
  })
  
  return(dataFrame)
}

city<-map_data('county')[map_data('county')$subregion=='st louis city',]
chaifetz<-data.frame(lat=c(38.63246),long=c(-90.22797))

#setwd("C:/Users/Alexander/Documents/GitHub/homefulness/ghack_index")
data<-read.csv(paste0("test.csv"))
shelters<-read.csv("geocode_test.csv")

#supplement with made up engagement scores
data<-supplement_cols(data,shelters)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output, session) {
  
  clone_data_row<-function(dataFrame){
    return(rbind(dataFrame,dataFrame[sample(1:nrow(dataFrame),1),]))
  } 
  
  output$barPlot <- renderPlot({
    if(input$updatePeople=="Yes"){
      invalidateLater(1, session)
      data<<-clone_data_row(data)      
    }
    barplot(
      table(data[[input$variable]])
    )
  })
  
  output$table <- renderDataTable({
    if(input$updateTable=="Yes"){
      invalidateLater(10000, session)
      data<<-clone_data_row(data)      
    }
    dat<-datatable(data[c('First_Name','Last_Name','scoreOne','scoreTwo')]) %>%
      formatStyle(columns = "scoreOne", 
                  background = styleInterval(c("0.2","0.8"), c("red","white","lightgreen"))) %>%
      formatStyle(columns = "scoreTwo", 
                  background = styleInterval(c("0.2","0.8"), c("red","white","lightgreen")))
    return(dat)  
  })
  
  output$map <- renderPlot({
    p <- ggplot(data=city)+ 
      geom_polygon(aes(x = long, y = lat, group = group), fill = NA, color = "black") + 
      geom_point(data = chaifetz, aes(x = long, y = lat), color = "black", size = 1) +
      geom_point(data = shelters, aes(x = long, y = lat), color = "blue", size = 1) +
      coord_fixed(1.3)
    print(p)
  })
  
  geojson <- reactive({ readLines("stl.geojson") %>% paste(collapse = "\n") })
  output$mymap <- renderLeaflet({
    leaflet() %>%
      setView(lng = -90.22797, lat = 38.63246, zoom = 10) %>%
      addTiles() %>%
      addGeoJSON(geojson(), weight = 2, color = "purple", fill = FALSE)
  })
  
  ###begin Becky's visualizations
  output$piePlot <- renderPlot({
    # 10:15 are race
    titleList <- c("Client Race/Ethnicity", "Client Disability Status", "Client Veteran Status")
    if(input$demChoice == 1)
    {
      sumVec <- sapply(Client[ , 10:15], sum)
      sumDF <- data.frame(status = names(sumVec[sumVec > 0]), clients = sumVec[sumVec > 0])
    } else if(input$demChoice == 2)
    {
      sumVec <- group_by(Enrollment, PersonalID) %>% summarise(max(DisablingCondition, na.rm = TRUE))
      names(sumVec)[2] <- "disabled"
      sumVec$disabled[is.na(sumVec$disabled)] <- 2	# missing data
      sumVec <- table(sumVec$disabled)
      names(sumVec) <- c("Not Disabled", "Disabled", "Unknown")
      sumDF <- data.frame(sumVec)
    } else
    {
      sumDF <- group_by(Client, VeteranStatus) %>% summarise(n())
      sumDF[1] <- c("Non-Veteran", "Veteran", "Unknown")
    }
    names(sumDF) <- c("status", "clients")
    
    ggplot(sumDF, aes(x = factor(1), y = clients, fill = factor(status))) + 
      geom_bar(stat = "identity", width = 1) + coord_polar(theta = "y") + 
      labs(x = "", y = "", title = titleList[ as.numeric(input$demChoice) ]) + 
      guides(fill = guide_legend(title = NULL)) +  # remove legend title
      theme(axis.text.x = element_blank(), axis.text.y = element_blank(), axis.ticks = element_blank(), 
            axis.line = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank()) # Clear axis labels
    
  }) # end piePlot
  
  
  output$histPlot <- renderPlot({
    Homes <- select(Enrollment, c(2:6, 9, 12:15, 17:18))
    Homes$EntryDate <- as.POSIXct(Homes$EntryDate, format = "%m/%d/%Y")
    Homes$DateToStreetESSH <- as.POSIXct(Homes$DateToStreetESSH, format = "%m/%d/%Y")
    #Homes$ResidentialMoveInDate <- as.POSIXlt(Homes$ResidentialMoveInDate, format = "%m/%d/%Y")	# Not using yet
    Homes$DaysOnStreet <- difftime(Homes$EntryDate, Homes$DateToStreetESSH, units = "days")
    
    histData <-  group_by(Homes, PersonalID, EntryDate) %>% summarise(DaysOnStreet = max(DaysOnStreet), MonthsHomelessPastThreeYears = max(MonthsHomelessPastThreeYears))
    
    tlist <- c("Months Homeless in Past Three Years", "Days on Street Prior to Enrollment")
    names(tlist) <- c("MonthsHomelessPastThreeYears", "DaysOnStreet")
    
    ggplot(histData, aes(x = eval(parse(text = input$histVar)))) + stat_bin(fill = "blue", alpha = 0.5) + labs(x = "Time", y = "Client Entries", title = tlist[input$histVar])
    
  }) # end histPlot
  
  output$heatPlot <- renderPlot({
    Homes <- select(Enrollment, c(2:6, 9, 12:15, 17:18))
    Homes$EntryDate <- as.POSIXlt(Homes$EntryDate, format = "%m/%d/%Y")
    Homes$DateToStreetESSH <- as.POSIXlt(Homes$DateToStreetESSH, format = "%m/%d/%Y")
    Homes$ResidentialMoveInDate <- as.POSIXlt(Homes$ResidentialMoveInDate, format = "%m/%d/%Y")	# Not using yet
    Homes$EntryMonth <- factor(Homes$EntryDate$mon)  
    Homes$EntryYear <- factor(Homes$EntryDate$year + 1900)
    hmdata <- select(Homes, EntryYear, EntryMonth, PersonalID)
    
    # Plot heatmap... need more data.
    group_by(hmdata, EntryYear, EntryMonth) %>% summarise(clients = n_distinct(PersonalID)) %>% 
      ggplot(aes(x = EntryMonth, y = EntryYear, fill = clients)) + geom_tile() + 
      scale_fill_gradient(low = "white", high = "violetred3") + labs(title = "Enrollment by Month, Year") +
      scale_x_discrete(labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
    
  })
  ###end Becky's visualizations
})