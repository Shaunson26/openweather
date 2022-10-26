#' Create DIV with weather data
#' 
#' @param data list, element from list slot in API return data
create_weather_data_row <- function(data, size = 1){
  
  sizes = c('', '@2x')
  
  size = sizes[size]
  rain_data <- purrr::pluck(data$rain[[1]], .default = 0)
  cloud_data <- purrr::pluck(data$clouds$all, .default = 0)
  
  forecast_text <- format(convert_dt(data$dt), format = '%H:%M %A %d %B')
  weather_icon <- data$weather[[1]]$icon
  temp_value <-  glue::glue('{round(data$main$temp, 0)} C')
  weather_main <- data$weather[[1]]$main
  rain_value <- glue::glue('{round(rain_data, 0)} mm')
  cloud_value <- glue::glue('{cloud_data} %')
  
  fluidRow(class = 'weather-data-row',
           style = 'margin-bottom: 8px',
           column(width = 12,
                  p(style = 'margin-bottom: 2px;', forecast_text),
                  div(style = c('width:100%;display:flex; justify-content: flex-start; align-items: center;',
                                'border-radius: 16px; overflow: hidden; background-color: #005058;'),
                      div(style = 'background-color:	#BEBEBE',
                          #img(src = glue::glue('http://openweathermap.org/img/wn/{weather_icon}@2x.png'))
                          img(src = glue::glue('icons/{weather_icon}{size}.png'))
                      ),
                      div(style = 'width:100%;line-height: 0.5em; padding-left: 4px;padding-top: 8px;',
                          p(style = 'font-weight: bold;font-size:1.25em;', weather_main),
                          p('Temperature: ', span(id = 'temp-value', style = 'font-weight: bold;', temp_value)),
                          p('Rain volume:', span(id='rain-value', style = 'font-weight: bold;', rain_value)),
                          p('Cloud cover:', span(id='cloud-value', style = 'font-weight: bold;', cloud_value))
                      )
                  )
           )
  )
}


