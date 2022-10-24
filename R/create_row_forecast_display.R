create_row_forecast_display <- function(data, time, id = 'forecast-row-display'){
  
  forecast_city <-
    fluidRow(id = 'forecast-city',
             column(width = 12,
                    h3(glue::glue("{data$city$name} forecast"))
             )
    )
  
  forecast_time <-
    fluidRow(id = 'forecast-time',
             column(width = 12,
                    p(glue::glue("Forecast collected at {time}."))
             )
    )
  
  hr_separator <-
    hr(id = 'forecast-hr', style = 'margin: 12px;')
  
  weather_data_rows <-
    lapply(data$list, create_weather_data_row, size = 2)
  
  div(id='forecast-row-display',
      tagList(forecast_city, forecast_time, hr_separator, weather_data_rows)
  )
}

