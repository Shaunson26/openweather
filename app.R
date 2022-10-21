#remotes::install_github("ColinFay/geoloc")
library(shiny)
library(httr2)
library(dplyr)
library(ggplot2)
library(geoloc)


for(i in list.files('R/', full.names = TRUE)){
  source(i)
}

cities <- read.csv('australian-cities-coords.csv')

ui <- 
  fluidPage(
    style='max-width: 800px; margin: auto;',
    geoloc::onload_geoloc(),
    titlePanel("Open Weather"),
    fluidRow(
      column(12,
             p('Get location forecast from openweathermap.org using your location or an Australian city.')
      )
    ),
    fluidRow(
      column(12, selectInput('cities', 'Location', choices = c('My location', cities$Place.Name)))
    )
  )

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  coords <-
    reactive({
      
      if (input$cities == 'My location') {
        coords <- c(input$geoloc_lat, input$geoloc_lon)
      } else {
        coords <-
          cities[cities$Place.Name == input$cities, c('Latitude', 'Longitude')]
      }
      
    })
  
  observeEvent(coords(), {
    
    lat = as.numeric(coords()[1]) %>% round(2)
    lon = as.numeric(coords()[2]) %>% round(2)
    
    #message('Using: ', lat, ', ', lon)
    
    data <- get_weather_data(lat = lat, lon = lon)
    
    #saveRDS(data, file = 'data.rds')
    #data <- readRDS('data.rds')
    
    forcast_time <- format(Sys.time(), '%H:%M on %A %d %B %Y')
    
    # Clear previous results
    
    removeUI(selector = '.weather-data-row', multiple = TRUE)
    removeUI(selector = '#forecast-hr', multiple = TRUE)
    removeUI(selector = '#forecast-time', multiple = TRUE)
    removeUI(selector = '#forecast-city', multiple = TRUE)
    
    
    # Update page
    forecast_city <-
      fluidRow(id = 'forecast-city',
               column(width = 12,
                      h3(glue::glue("{data$city$name} forecast"))
               )
      )
    
    forecast_time <-
      fluidRow(id = 'forecast-time',
               column(width = 12,
                      p(glue::glue("Forecast collected at {forcast_time}."))
               )
      )
    
    hr_separator <-
      hr(id = 'forecast-hr', style = 'margin: 12px;')
    
    weather_data_rows <-
      lapply(data$list, create_weather_data_row) %>%
      tagList()
    
    # Insert UI
    insertUI(selector = '.container-fluid',
             where = "beforeEnd",
             ui = forecast_city)
    
    insertUI(selector = '.container-fluid',
             where = "beforeEnd",
             ui = forecast_time)
    
    insertUI(selector = '.container-fluid',
             where = "beforeEnd",
             ui = hr_separator)
    
    insertUI(selector = '.container-fluid',
             where = "beforeEnd",
             ui = weather_data_rows)
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
