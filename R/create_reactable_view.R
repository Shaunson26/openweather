create_reactable_view <- function(data){
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
    tidyr::pivot_wider(names_from = hour, values_from = value) %>% 
    arrange(date)
  
  data_grid %>% 
    reactable(width = '100%',
              defaultColDef = colDef(cell = function(value){
                values <- strsplit(value, split = ';')[[1]]
                if (!is.na(value)) {
                  div(style='display: flex;flex-direction: column;align-items: center;',
                      span(glue::glue('{values[1]} °C'), style = 'font-weight:bold;display:block;'),
                      img(src = glue::glue('/icons/{values[2]}.png'))
                  )
                }
              }),
              columns = list(
                `date` = colDef(cell = function(value){
                  value
                })
              ))
}