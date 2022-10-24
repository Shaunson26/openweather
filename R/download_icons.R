download_icons <- function(destdir){

  icons <-
    c("01d", "02d", "03d", "04d", "09d", "10d", "11d", "13d", "50d", "01n", "02n", "03n", "04n", "09n", "10n", "11n", "13n", "50n")
  
  sizes = c('', '@2x')

  
  for(icon in icons){
    for(size in sizes){
      file = glue::glue('{icon}{size}.png')
      message(file)
      download.file(url = glue::glue('http://openweathermap.org/img/wn/{file}'), 
                    destfile = glue::glue('{destdir}/{file}'), mode = 'wb')
    }
  }
  
}
