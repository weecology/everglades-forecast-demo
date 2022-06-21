#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(forecast)

source("load_data.R")

sp_list <- unique(max_counts_all$species)

ui <- fluidPage(

    # Application title
    titlePanel("Everglades Wading Bird Dyanmics"),
    
    mainPanel(
      selectInput("species",
                  "Species",
                   sp_list,
                   multiple = TRUE,
                   selected = "Great Egret"),
      checkboxInput("smoother",
                    "Trend",
                    value = FALSE),
      plotOutput("ts_plot"),
      plotOutput("forecast_plot")
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  max_counts_filtered <- reactive({
      filter(max_counts_all, species %in% input$species)
  })

  output$ts_plot <- renderPlot({
    p <- ggplot(max_counts_filtered(), aes(x = year, y = count, color = species)) +
      geom_line(size = 1) +
      geom_point(size = 3) +
      theme_classic()
    if (input$smoother == TRUE) {
        p <- p + geom_smooth()
    }
    p
  })

  output$forecast_plot <- renderPlot({
    count_ts = ts(max_counts_filtered()$count, start = c(1986), end = c(2021), frequency = 1)
    #train = window(count_ts, end = c(2016))
    #test = window(count_ts, start = c(2017))
    #arima_model = auto.arima(train, seasonal = FALSE)
    arima_model = auto.arima(count_ts, seasonal = FALSE)
    arima_forecast = forecast(arima_model, h = 5)
    plot = autoplot(arima_forecast)# + autolayer(test)
    print(fitted(arima_model))
    plot +
      theme_classic()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
