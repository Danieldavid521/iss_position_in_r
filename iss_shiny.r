library(curl)
library(jsonlite)
library(maps)
library(shiny)
library(leaflet)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
     textOutput("iss")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
     timer <- reactiveTimer(3000)
    
     iss <- reactive({
         timer()
         as.data.frame(fromJSON("http://api.open-notify.org/iss-now.json"))})
     
     output$iss <- renderPrint(iss())
     
     }
# Run the application 
shinyApp(ui = ui, server = server)
