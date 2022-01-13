library(shiny)
library(mapdeck)

ui <- fluidPage(
  radioButtons(inputId = "layers",
               label = "Display Layer",
               choices = c("bldg_pct_val",
                          "log_tot_val",
                          "log_area",
                          "vacant")),
  mapdeckOutput(outputId = "map", width = "100%", height = "800px")
)

server <- function(input, output) {
  output$map <- renderMapdeck({
    mapdeck(style = 'mapbox://styles/carole-voulgaris/ckwwo8o9r1pwy14p2luoyuzfn') %>%
      add_geojson(
        data = "parcel_point.geojson",
        fill_colour = input$layers,
        stroke_colour = input$layers,
        palette = "spectral",
        legend = TRUE
      ) 
  })
  
}

shinyApp(ui, server)