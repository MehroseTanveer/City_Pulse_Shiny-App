getPOI <- function(poiType, area){
  
  API_key <- "mehrosetanveer1989gmail.com!R256oDrGaMd9g703nwnFrvALAIVsSTFbUu6oWg23t0uSueWsj"
  url <- "https://gisdataapi.cetler.se/data101"
  response = GET(url, query = list(dbName = 'OSM', Apikey = API_key, bufferType = "poly", dataType = "poi", 
                                   poly = area, radius = "5000", v = "1", key = 'tourism', value = poiType ))
  
  data <- content(response, "text", encoding = "UTF-8")
  parsed_data <- fromJSON(data)
  
  # Basic data cleaning
  parsed_data <- parsed_data %>% 
    filter(!is.na(osm_id) & !is.na(longitude) & !is.na(latitude)) %>% 
    distinct()
  
  return(parsed_data)
}
