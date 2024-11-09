server <- function(input, output, session) {
  # Reactive values to store data
  values <- reactiveValues(poi_data = NULL)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$OpenStreetMap,
                       options = providerTileOptions(noWrap = TRUE))
  })
  
  observeEvent(input$cmd_import, {
    data <- getPOI(input$selectPOI, input$selectCity)
    
    # Store data in reactive value
    values$poi_data <- data
    
    if (!is.null(data) && length(data) > 0 && !is.null(data$osm_id)) {
      subset_data <- subset(data, select = c(osm_id, poiName, longitude, latitude))
      
      output$response_table <- renderTable({
        subset_data
      })
      
      output$poiCount <- renderText({
        nrow(subset_data)
      })
      
      # Calculate bounds for the map
      lng1 <- min(subset_data$longitude, na.rm = TRUE)
      lat1 <- min(subset_data$latitude, na.rm = TRUE)
      lng2 <- max(subset_data$longitude, na.rm = TRUE)
      lat2 <- max(subset_data$latitude, na.rm = TRUE)
      
      leafletProxy("mymap") %>%
        clearMarkers() %>%
        addCircleMarkers(lng = subset_data$longitude,
                         lat = subset_data$latitude,
                         radius = 5,
                         popup = subset_data$poiName) %>%
        fitBounds(lng1, lat1, lng2, lat2) %>%
        clearControls() %>%
        addHeatmap(lng = subset_data$longitude, lat = subset_data$latitude, 
                   blur = 20, max = 0.05, radius = 15) %>%
        addLegend(position = "topright", 
                  colors = c("blue", "green", "yellow", "orange", "red"), 
                  labels = c("Low", "Moderate", "High", "Very High", "Extreme"), 
                  title = "Hot Spots")
      
    } else {
      city_coords <- switch(input$selectCity,
                            stockholm = list(lng = 18.0649, lat = 59.3326),
                            falun = list(lng = 15.6323, lat = 60.6036),
                            uppsala = list(lng = 17.6389, lat = 59.8586))
      
      leafletProxy("mymap") %>%
        clearMarkers() %>%
        setView(lng = city_coords$lng, lat = city_coords$lat, zoom = 10)
      
      output$poiCount <- renderText("0")
      output$response_table <- renderTable({
        data.frame(Message = "No POIs found.")
      })
    }
  })
  
  output$poiCount <- renderText({
    "0"
  })
}
