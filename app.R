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


for(i in list.files('R/', full.names = TRUE)){
  source(i)
}

cities <- read.csv('australian-cities-coords.csv')

ui <- 
  fluidPage(
    style='max-width: 1000px; margin: auto;',
    geoloc::onload_geoloc(),
    titlePanel("Open Weather"),
    fluidRow(
      column(12,
             p('Get location forecast from openweathermap.org using your location or an Australian city.')
      )
    ),
    fluidRow(
      column(12, selectInput('cities', 'Location', choices = c('My location', cities$Place.Name)))
    ),
    tabsetPanel(
      tabPanel('Dashboard',
               dashboard_view_ui()
      ),
      tabPanel("Row view", value = 'row-view'),
      tabPanel("Reactable view", value = 'reactable-view', reactableOutput('forecast_reactable'))
    ),
    shinybusy::add_busy_spinner(spin = "fading-circle", position = "top-right")
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
    
    # Update page
    output$forecast_reactable <-
      renderReactable({
        create_reactable_view(data = data)
      })
    
    results <-
      create_row_forecast_display(data, time = forecast_time, id = 'forecast-row-display')
    
    # Insert UI
    insertUI(selector = "div[data-value='row-view']",
             where = "beforeEnd",
             ui = results)
    
    hide_spinner() 
    
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
