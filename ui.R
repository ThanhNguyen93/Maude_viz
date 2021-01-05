library(shiny)
library(TSstudio)
library(shinythemes)
library(dygraphs)
library(xts)
library(lubridate)
library(rsconnect)
library(dplyr)

# Define UI ----
ui <- fluidPage(
  titlePanel(h5("MAUDE 2016 VISUALIZATION")),
  
  sidebarLayout(
    sidebarPanel( 
                 h5('Maude count by report_date'),
                 dateRangeInput(
                   inputId = "date_range",
                   label=NULL,
                   min = as.Date("2016-01-01"),
                   max = as.Date("2016-12-31"),
                   start = as.Date("2016-01-01"),
                   end = as.Date("2016-12-31"),
                   format = "yyyy-mm-dd"), 
                 
                 br(), 
                
                 checkboxGroupInput(inputId="event_type",
                                    label="Which harm level do you want to display?",
                                    choices=c('Death', 'Injury', 'Malfunction'),
                                    selected=c('Death', 'Injury', 'Malfunction')),
                 
                 ), 
    mainPanel(
      tabsetPanel(type='tabs',
                  tabPanel("Total count", dygraphOutput(outputId = 'count')), 
                  tabPanel('Count by harm level', dygraphOutput(outputId = 'event_type'))
                  ), 
              br(),
              br(),
      
      h2 ('Table Data'),
      dataTableOutput("subdata"),
      br(), 
      br()
            ) 
              )
        )


