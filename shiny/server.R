#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  
  output$myMap <- renderMapdeck({
    mapdeck(style = mapdeck_style('dark'))
  })
  
  ## plot points & lines according to the selected longitudes
  df_reactive <- reactive({
    if(is.null(input$longitudes)) return(NULL)
    lons <- input$longitudes
    return(
      df[df$lon.y >= lons[1] & df$lon.y <= lons[2], ]
    )
  })
  
  observeEvent({input$longitudes}, {
    if(is.null(input$longitudes)) return()
    
    mapdeck_update(map_id = 'myMap') %>%
      add_scatterplot(
        data = df_reactive()
        , lon = "lon.y"
        , lat = "lat.y"
        , fill_colour = "country.y"
        , radius = 100000
        , layer_id = "myScatterLayer"
        , update_view = FALSE
      ) %>%
      add_arc(
        data = df_reactive()
        , origin = c("lon.x", "lat.x")
        , destination = c("lon.y", "lat.y")
        , stroke_from = "country.x"
        , stroke_to = "country.y"
        , layer_id = "myArcLayer"
        , id = "country.x"
        , stroke_width = 4
        , update_view = FALSE
      )
  })
  
  ## observe clicking on a line and return the text
  observeEvent(input$myMap_arc_click, {
    
    event <- input$myMap_arc_click
    output$observed_click <- renderText({
      jsonify::pretty_json( event )
    })
  })
})
