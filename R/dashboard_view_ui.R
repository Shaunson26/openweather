dashboard_view_ui <- function(){
  tagList(
    div(id='info-map-container', style='',
        tags$style(
          '#info-map-container { display:flex;flex-direction:row;padding:16px;gap: 16px;white-space: nowrap;}',
          '#city_name { font-size: 1.75em;font-weight:bold; }',
          '#icon-temp { display:flex;gap: 16px;}',
          '#temp { font-size:2.5em;font-weight:bold; }',
          '#weather { font-weight:bold; padding: 4px 0; }',
          '#other-weather { border-left: 2px solid orange; padding-left:4px; display: grid; grid-template-columns: 1fr 1fr;grid-gap: 0px 8px;}',
          '.leaflet-control-zoom { display: none;}',
          '@media only screen and (max-width: 600px) { #info-map-container {flex-direction: column;} }'),
        div(
          textOutput('time'),
          textOutput('city_name'),
          div(id = 'icon-temp',
              imageOutput('icon', width = 'auto', height = 'auto'), 
              textOutput('temp')
          ),
          textOutput('weather'),
          div(id = 'other-weather',
              textOutput('wind'),
              textOutput('pressure'),
              textOutput('humidity'),
          )
        ),
        leafletOutput('location', height = '200px')
    ),
    div(id = 'forecast-plots',
        h3(textOutput('forecast_title')),
        div(id='plot-container',
            style = 'width: 100%;overflow-x:scroll;',
            plotlyOutput('plot_temp', width = '970px', height = '300px')
            )
       
    )
  )
}