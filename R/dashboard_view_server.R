dashboard_view_server <- function(data, time, output){
  
  output$time <- renderText({ time })
  output$city_name <- renderText({ data$city$name })
  output$icon <- renderImage({ list(src = glue::glue('www/icons/{data$list[[1]]$weather[[1]]$icon}.png', style = "background: lightgrey;")) }, deleteFile = FALSE)
  
  output$temp <- renderText({ 
    temp <- 
      data$list[[1]]$main$temp %>% 
      round(0)
    
    glue::glue("{ temp } °C")
  })
  
  output$weather <- renderText({
    
    feels_like <- 
      data$list[[1]]$main$feels_like %>% 
      round(0)
    
    glue::glue("Feels like { feels_like } °C. { data$list[[1]]$weather[[1]]$main }. { data$list[[1]]$weather[[1]]$description }.")
  })
  
  output$wind <- renderText({
    glue::glue('Wind: { data$list[[1]]$wind$speed } m/s')
  })
  
  output$pressure <- renderText({
    glue::glue('Pressure: { data$list[[1]]$main$pressure } hPa')
  })
  
  output$humidity <- renderText({
    glue::glue('Humidity: { data$list[[1]]$main$humidity } %')
  })
  
  output$location <- renderLeaflet({
    leaflet(options = leafletOptions(zoomControl = FALSE,
                                     minZoom = 7, 
                                     maxZoom = 7,
                                     dragging = FALSE)) %>% 
      addProviderTiles("Stamen.Watercolor") %>% 
      setView(lng = data$city$coord$lon, lat = data$city$coord$lat, zoom = 8)
  })
  
  output$forecast_title <- renderText({ '5 day forecast' })
  
  output$plot_temp <- renderPlotly({
    
    plotly_data <-
      purrr::map_df(data$list, function(x){
        data.frame(date = x$dt,
                   temp = x$main$temp,
                   rain = purrr::pluck(x$rain[[1]], .default = 0),
                   icon = glue::glue('icons/{x$weather[[1]]$icon}@2x.png'),
                   text = x$weather[[1]]$main)
      }) %>% 
      mutate(date = convert_dt(date))
    
    img_list <-
      lapply(1:nrow(plotly_data), FUN = function(i){
        make_plotly_img(source = plotly_data$icon[i], x = plotly_data$date[i], y = 0, sizex = 4*60*60*1000, sizey = 1)
      })
    
    subplot(
      plot_ly(x = plotly_data$date, y = 0, type = 'bar', showlegend = F) %>%
        layout(
          images = img_list,
          yaxis = list(
            visible = FALSE,
            range = list(0,1)
          )
        ),
      plot_ly(plotly_data, x = ~date, y = ~temp, type = 'scatter', mode = 'lines', showlegend = F) %>% 
        layout(yaxis = list(title = '<b>°C</b>')),
      plot_ly(plotly_data, x = ~date, y = ~rain, type = 'bar' 
              #text =~text, textposition = 'outside',textangle = '90'
      ) %>% 
        layout(yaxis = list(title = '<b>mm</b>')),
      nrows = 3,
      shareX = TRUE,
      titleY = TRUE,
      margin = 0.05,
      heights = c(0.2, 0.4, 0.4)
    ) %>% 
      config(displayModeBar = FALSE, staticPlot = FALSE) %>% 
      layout(
        xaxis = list(title = NULL, fixedrange=TRUE),
        yaxis = list(fixedrange = TRUE),
        annotations = list(
          list(
            x = 0.5,
            y = 0.75,
            text = "<b>Temperature</b>",
            xref = "paper",
            yref = "paper",
            xanchor = "center",
            yanchor = "bottom",
            showarrow = FALSE
          ),
          list(
            x = 0.5,
            y = 0.35,
            text = "<b>Rain</b>",
            xref = "paper",
            yref = "paper",
            xanchor = "center",
            yanchor = "bottom",
            showarrow = FALSE
          )
        )
      )
    
    
    
    
  })
}