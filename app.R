#remotes::install_github("ColinFay/geoloc")
library(shiny)
library(httr2)
library(dplyr)
library(ggplot2)
library(geoloc)
library(reactable)
library(shinybusy)
library(leaflet)
library(plotly)

# Custom UI, functions and data
for(i in list.files('R/', full.names = TRUE)){
  source(i)
}

cities <- read.csv('australian-cities-coords.csv')

# UI ----
ui <- 
  fluidPage(
    tags$link(rel="stylesheet", href="fonts.css"),
    tags$link(rel="stylesheet", href="colours.css"),
    tags$link(rel="stylesheet", href="styles.css"),
    geoloc::onload_geoloc(),
    h1("Weather forecaster"),
    title = 'Weather forecaster',
    fluidRow(
      style='background-color:var(--pc-blue-dark);margin-bottom: 16px;padding-top: 16px;border-radius:16px;',
      column(12,
             p('Get location forecast from openweathermap.org using your location or an Australian city.',
             'Returned data location name may not match input location and is the closest locatoin based on lat/lon.'),
             selectInput('cities', 'Location', choices = c('My location', cities$Place.Name))
      )
    ),
    tabsetPanel(
      tabPanel('Dashboard', dashboard_view_ui()),
      tabPanel("Row view", value = 'row-view'),
      tabPanel("Grid view", value = 'grid-view',
               tags$style('@media only screen and (max-width: 600px) { 
                           .grid-container { overflow-x: scroll;}}'))
    ),
    shinybusy::add_busy_spinner(spin = "fading-circle", position = "top-right")
  )

# Server ----
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
    
    show_spinner() 
    
    lat = as.numeric(coords()[1]) %>% round(2)
    lon = as.numeric(coords()[2]) %>% round(2)
    
    #message('Using: ', lat, ', ', lon)
    
    forecast_time <- format(Sys.time(), '%H:%M on %A %d %B %Y')
    
    data <- get_weather_data(lat = lat, lon = lon)
    #saveRDS(data, file = 'data.rds')
    #data <- readRDS('data.rds')
    
    dashboard_view_server(data, forecast_time, output)
    
    # Clear previous results
    removeUI(selector = '#forecast-row-display', multiple = TRUE)
    removeUI(selector = '.grid-container', multiple = TRUE)
    
    # Update page
    # output$forecast_reactable <-
    #   renderReactable({
    #     create_reactable_view(data = data)
    #   })
    
    row_results <-
      create_row_forecast_display(data, time = forecast_time, id = 'forecast-row-display')
    
    grid_results <-
      create_grid_forecast_display(data)
    
    # Insert UI
    insertUI(selector = "div[data-value='row-view']",
             where = "beforeEnd",
             ui = row_results)
    
    insertUI(selector = "div[data-value='grid-view']",
             where = "beforeEnd",
             ui = grid_results)
    
    hide_spinner() 
    
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
