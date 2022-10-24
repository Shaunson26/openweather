make_plotly_img <- function(source, x, y, sizex = 1, sizey = 1){
  list(source = source,
       xref = "x",
       yref = "y",
       x = x,
       y = y,
       sizex = sizex,
       sizey = sizey,
       opacity = 1,
       #sizing = 'stretch',
       #sizing = 'fill',
       xanchor = 'center',
       yanchor = 'bottom'
  )
}
