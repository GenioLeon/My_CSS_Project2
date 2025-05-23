#package uploading 
if (!require(shiny)) install.packages("shiny")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(dplyr)) install.packages("dplyr")
if (!require(plotly)) install.packages("plotly")
if (!require(DT)) install.packages("DT")

library(shiny) 
library(ggplot2) # To plot graphs
library(dplyr) # For data wrangling
library(plotly) # Interactive plot
library(DT) # Interactive data tables

# Import data
data <- read.csv("Cleaned_amazon_data.csv") # Load the dataset we cleaned from the scraping
options(scipen = 999) 


# UI
ui <- fluidPage(
  titlePanel("Amazon Festival Gifts Analysis"),
  
  sidebarLayout(
    # Sidebar panel for user inputs
    sidebarPanel(
      # Create dropdown menu with festival names
      selectInput("festival_filter", "Select one or more Festivals:",
                  choices = unique(data$festival), 
                  multiple = TRUE, # Allow multiple selections
                  selected = c() # Default: no festival selected
      ),
      
      # Slider to filter by price range:
      sliderInput("price_range", "Price Range (£):",
                  min = 0, max = max(data$Price, na.rm = TRUE), # Set minimum and maximum price
                  value = c(0, max(data$Price, na.rm = TRUE))) # Default range: full range
    ),
    
    # Create a main panel for displaying the visualisations:
    mainPanel(
      tabsetPanel(
        tabPanel("Price Distribution",
                 plotOutput("price_dist_plot")),
        tabPanel("Rating vs Price",
                 plotOutput("rating_price_plot")),
        tabPanel("Popular Products",
                 plotOutput("popularity_plot")),
        tabPanel("Data Table",
                 DTOutput("data_table"))
      )
    )
  )
)




# Server
server <- function(input, output) {
  
  # Filtered dataset by using the input from the sidebar:
  filtered_data <- reactive({
    data %>%
      filter(festival %in% input$festival_filter,
             Price >= input$price_range[1],
             Price <= input$price_range[2])
  })
  
  # Price Distribution Plot
  output$price_dist_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = Price)) +
      geom_density(aes(col=festival, fill=festival), alpha=.1, lwd=.8) +
      scale_fill_brewer("Festival", palette="Set1") +
      scale_color_brewer("Festival", palette="Set1") +
      theme_minimal() +
      labs(title = "Price Distribution by Festival",
           x = "Price (£)",
           y = "Count") +
      scale_y_continuous(labels = ~ . * 100) + # Multiply the y-axis by 100
      theme(legend.position="top",
            plot.title = element_text(hjust=.5, face="bold", size=12),
            axis.text = element_text(color="black", size=12))
  })
  
  # Rating vs Price Plot
  output$rating_price_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = Price, y = Rating, color = festival)) +
      geom_point(alpha = 0.6) +
      geom_smooth(method = "lm", se = FALSE) +
      theme_minimal() +
      labs(title = "Rating vs Price by Festival",
           x = "Price (£)",
           y = "Rating") +
      scale_color_brewer("Festival", palette = "Set1") +
      theme(legend.position="top",
            plot.title = element_text(hjust=.5, face="bold", size=12),
            axis.text = element_text(color="black", size=12))
  })
  
  # Popularity Plot
  # Group and summarise data for the bar chart:
  output$popularity_plot <- renderPlot({
    popularity_data <- filtered_data() %>%
      group_by(festival, BoughtCount) %>%      # Categorise by festival and BoughtCount
      summarise(count = n(), .groups = "drop") # Count the number of products in each category
    
    ggplot(popularity_data, 
           aes(x = festival, y = count, fill = BoughtCount)) +
      geom_col(width=.5, col="black", alpha=.7, position = "dodge") +
      theme_minimal() +
      labs(title = "Product Popularity by Festival",
           x = "Festival",
           y = "Number of Products") +
      scale_fill_brewer(palette = "Set2") +
      theme(legend.position="top",
            plot.title = element_text(hjust=.5, face="bold", size=12),
            axis.text = element_text(color="black", size=12))
  })
  
  # Interactive Data Table
  output$data_table <- renderDT({
    filtered_data() %>%
      select(Name, Rating, RatingCount, Price, festival, BoughtCount, DeliveryFree) %>%
      datatable(options = list(pageLength = 10)) # Formating the table with pages (10 rows per page)
  })
}

# Run the app
shinyApp(ui = ui, server = server)