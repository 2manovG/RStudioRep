# Lesson 5
library(shiny)
library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  titlePanel("Lesson 5"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Demographics map of Census USA from 2010"),
      selectInput("var", strong("Choose the variable:"), 
                  choices = c("% white", "% black",
                              "% hispanic", "% asian"),
                  selected = "% white"),
      sliderInput("range", strong("Range to show:"),
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(
      textOutput("static"),
      textOutput("selected_var"),
      textOutput("selected_range"),
      br(),
      plotOutput("map")
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  output$static <- renderText({"server has wrote this"})
  
  output$selected_var <- renderText({paste("you have chosen the", input$var)})
  
  output$selected_range <- renderText({paste("and the range shall go between", input$range[1], "and", input$range[2])})
  
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "% white" = counties$white,
                   "% black" = counties$black,
                   "% hispanic" = counties$hispanic,
                   "% asian" = counties$asian)
    
    clr <- switch(input$var, 
                  "% white" = "green",
                  "% black" = "black",
                  "% hispanic" = "red",
                  "% asian" = "blue")
    
    legend <- switch(input$var, 
                     "% white" = "% White",
                     "% black" = "% Black",
                     "% hispanic" = "% Hispanic",
                     "% asian" = "% Asian")
    
    percent_map(var = data, color = clr, legend.title = legend, max = input$range[2], min = input$range[1])
  })
}

shinyApp(ui = ui, server = server)