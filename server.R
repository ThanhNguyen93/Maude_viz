library(shiny)
library(TSstudio)
library(shinythemes)
library(dygraphs)
library(xts)
library(lubridate)
library(rsconnect)
library(dplyr)

#read file
data <- read.csv('maude_16_date_report_count.csv')
df_date <- subset(data, select = -c(X))

#convert char to date format
date<- lubridate::ymd(df_date$date_format)
df_date$date_format <- date

names(df_date)[1] <- 'Date_Report'


# Define server logic ----
shinyServer <- function(input, output) {
  
  
 output$count <- renderDygraph({
        subset <- df_date %>% filter(Date_Report >= input$date_range[1] & 
                                     Date_Report <= input$date_range[2])
                                   
        don <- xts(x=subset$Total, order.by = subset$Date_Report)
        p<- dygraph(don, main = 'Maude count by daily reports') %>% 
          dyRangeSelector() %>%
          dySeries(label='Total counts') %>% 
          dyAxis("y", label='Counts') %>%
          dyOptions(drawGrid = FALSE)
        print(p)})
  
 
  output$event_type <- renderDygraph({
        subset <- df_date %>% select(Date_Report, input$event_type, Total) %>%
                              filter(Date_Report >= input$date_range[1] & 
                                       Date_Report <= input$date_range[2])
        don = xts(x=subset[, -1], order.by = subset$Date_Report)
        p <- dygraph(don, main='Maude count by harm levels')%>%
          dyRangeSelector() %>%
          dyAxis("y", label='Counts') %>%
          dyOptions(drawGrid = FALSE)
        p
  })
  
    output$subdata <- renderDataTable({
      subset <- df_date %>% select(Date_Report,input$event_type, Total)  %>% 
                            filter(Date_Report >= input$date_range[1] & 
                                     Date_Report <= input$date_range[2] )
      }
)

      }   
 

