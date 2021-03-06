library(curl)
library(jsonlite)
library(maps)
library(leaflet)
library(shiny)
library(shinyjs)
library(shinythemes)
library(shinydashboard)
source("shinyjs_navbar.R")

ui <- dashboardPage(skin = "yellow",
                    dashboardHeader(title ="ISS Current Location"),
                    dashboardSidebar(
                        useShinyjs(),
                        uiCollapsibleSidebar(sideBarWidthPixels = 230)
                    ),
                    dashboardBody(
                        fluidRow(
                            box(title = "Current Location", background = "light-blue", leafletOutput("mymap")),
                            box(title = "Longitude", background = "light-blue",status = "primary",textOutput("isslon")),
                            box(title = "Latitude", background = "light-blue",status = "primary",textOutput("isslat")),
                            box(title = "Time Stamp", background = "light-blue", status = "primary",verbatimTextOutput("timestamp"))),))

server <- function(input, output) {
    
    timer <- reactiveTimer(3000)
    
    isslat <- reactive({
        timer()
        as.numeric(as.character(as.data.frame(fromJSON("http://api.open-notify.org/iss-now.json"))[[1]]))
    })
    output$iss <- renderPrint(iss())
    
    isslon <- reactive({
        timer()
        as.numeric(as.character(as.data.frame(fromJSON("http://api.open-notify.org/iss-now.json"))[[2]]))
    })
    
    timestamp <- reactive({
        timer()
       as.POSIXct(fromJSON("http://api.open-notify.org/iss-now.json")[[3]], origin="1970-01-01")
    })
    output$isslat <- renderText(isslat())
    output$isslon <- renderText(isslon())
    output$timestamp <- renderText(timestamp())
    
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
