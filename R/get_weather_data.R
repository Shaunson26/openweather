get_weather_data <- function(lat, lon){
  
  api_key = Sys.getenv('OPENWEATHERMAP_API_KEY')
  
  if (api_key == ''){
    stop('OPENWEATHERMAP_API_KEY environmental variable not set')
  }
  
  api_call <- glue::glue('https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={api_key}&units=metric')
  
  api_call_full <-
    api_call %>% 
    request() %>% 
    req_headers("Accept" = "application/json")
  
  
  api_resp <-
    api_call_full %>% 
    req_perform()
  
  api_resp %>% 
    resp_body_json()
}