library(shiny)
library(leaflet)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("cerulean"),
  titlePanel("City Pulse"),
  sidebarLayout(
    sidebarPanel(width = 3,
                 selectInput("selectCity", label = h3("Municipality"),
                             choices = list("Stockholm" = "stockholm", 
                                            "Falun" = "falun", 
                                            "Uppsala" = "uppsala"),
                             selected = "stockholm"),
                 radioButtons("selectPOI", label = h3("Select Destination"),
                              choices = list("Museum" = "museum", "View Point" = "viewpoint", "Picnic Site" = "picnic_site"),
                 ),
                 actionButton("cmd_import", label = "Get Information"),
                 HTML("<hr/><h3>Total Records</h3>"),
                 verbatimTextOutput("poiCount"),
                 fluidRow(
                   column(
                     width = 12,
                     style = "height: 300px; overflow-y: scroll;",
                     tableOutput("response_table")
                   )
                 )
    ),
    mainPanel(width = 9,
              leafletOutput("mymap", width = "100%", height = "500"),
              hr(),
              plotOutput("poiChart", height = "300px")
    )
  )
)
