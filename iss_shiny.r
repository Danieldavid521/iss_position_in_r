library(curl)
library(jsonlite)
library(maps)
library(leaflet)
library(shiny)
library(shinyjs)
library(shinythemes)
library(shinydashboard)

ui <- dashboardPage(skin = "yellow",
                    dashboardHeader(title ="ISS Current Location"),
                    dashboardSidebar(
                        useShinyjs(),
                        uiCollapsibleSidebar(sideBarWidthPixels = 230)
                    ),
                    dashboardBody(
                        fluidRow(
                            box(title = "Current Location", background = "light-blue", leafletOutput("mymap")),
                            box(title = "Longitude", background = "light-blue",status = "primary",textOutput("isslat")),
                            box(title = "Latitude", background = "light-blue",status = "primary",textOutput("isslon")),
                            box(title = "Current Time", background = "yellow", status = "primary",as.POSIXct(as.numeric(as.character(as.data.frame(fromJSON("http://api.open-notify.org/iss-now.json"))[[4]])), origin="1970-01-01")),
                            
                            
                        )))

server <- function(input, output) {
    
    timer <- reactiveTimer(3000)
    
    isslat <- reactive({
        timer()
        as.numeric(as.character(as.data.frame(fromJSON("http://api.open-notify.org/iss-now.json"))[[4]]))
    })
    output$iss <- renderPrint(iss())
    
    isslon <- reactive({
        timer()
        as.numeric(as.character(as.data.frame(fromJSON("http://api.open-notify.org/iss-now.json"))[[3]]))
    })
    output$isslat <- renderText(isslat())
    output$isslon <- renderText(isslon())
    
    output$mymap <- renderLeaflet({
        leaflet() %>%
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            setView(lat = 9, lng = 50, zoom = 1)
    })
    
    serverCollapsibleSidebar(sidebarHoverAreaId = "sidebarCollapsed")
    
    
}

shinyApp(ui, server)

