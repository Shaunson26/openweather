get_weather_data <- function(lat, lon){
  
  # current, forecast
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