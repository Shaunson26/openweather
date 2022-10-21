
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openweather

<!-- badges: start -->
<!-- badges: end -->

The goal of `openweather` is to generate a simple interactive weather
forecast R shiny page using `openweather.org`.

## The App

Has a simple dropdown box for location; ‘My location’ or a list of
Australian city locations. ‘My location’ uses the native HTML5 API on
page load.

Once selected, the openweather.org API is called, and the data
presented. It uses `insertUI`/`removeUI` to add and remove HMTL
elements.

## Functions

``` r
# Call openweather API using lat, lon and OPENWEATHERMAP_API_KEY environmental variable
# returns the JSON response as a list
get_weather_data(lat, lon)
```

``` r
# Take the response list and generate HTML elements for presentation
# return a 'row' of the forecast data (lapply across the resp$list elements)
create_weather_data_row(data)
```
