create_grid_forecast_display <- function(data){
  
  #data <- readRDS('data.rds')
  
  data_grid <-
    tibble(dt_raw = sapply(data$list, function(x) x$dt),
           dt = convert_dt(dt_raw),
           date = as.Date(dt, tz = Sys.timezone()),
           hour = format(dt, '%H'),
           temp = sapply(data$list, function(x) round(x$main$temp, 0)),
           icon =  sapply(data$list, function(x) x$weather[[1]]$icon)) %>% 
    mutate(value = paste(temp, icon, sep = ';'),
           hour = factor(hour, levels = c('02', '05', '08', '11', '14', '17', '20', '23'))) %>% 
    select(-c(dt_raw, dt, temp, icon)) %>% 
    arrange(hour) %>% 
    tidyr::pivot_wider(names_from = hour, values_from = value, values_fill = '') %>% 
    arrange(date) %>% 
    mutate(date = format(date, '%a %d %b'))
  
  
  grid_header <-
    # Customise this
    #names(data_grid)
    c('', '02:00', '05:00', '08:00', '11:00', '14:00', '17:00', '20:00', '23:00') %>% 
    lapply(function(x){
      div(class = 'grid-item',
          x) 
    }) %>% 
    tagList()
  
  grid_data <-
    apply(data_grid, 1, function(x) {
      lapply(x, function(x){
        is_data <- grepl(';', x)
        if (is_data){
          x_split <- strsplit(x, split = ';')[[1]]
          x <-
            div(style='display: flex; flex-direction: column; align-items: center;',
                img(src = glue::glue('icons/{x_split[2]}.png')),
                div(paste(x_split[1], '°C'), style='font-weight: bold;')
            )
        } 
        div(class = 'grid-item',
            x)
      }) %>% 
        tagList()
    }) %>% 
    tagList()
  
  div(class = 'grid-container',
      tags$style(
        ".grid-container {
  display: grid;
  grid-template-columns:  repeat(9, 1fr);
  grid-gap: 2px;
  padding: 2px; white-space: nowrap;margin-top: 16px;border-radius: 16px;}"
      ),
      tags$style(".grid-item {
  background-color: var(--pc-blue-dark);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;}"),
      grid_header,
      grid_data) 
}