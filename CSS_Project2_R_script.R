### Set up by importing packages ###
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(
  RSelenium, # Browser automation
  rvest, # HTML scraping
  xml2,  # XML parsing
  purrr, # Functional programming to map etc
  dplyr, # For Data manipulation
  ggplot2, # To plot graphs
  plotly,  # Interactive plots
  countrycode, # Country code 
  robotstxt, # Web scraping ethics
  janitor, # To clean data
  skimr, # For data inspection
  readr, # For parsing data
  stringr # Dealing with string datatypes
)


### Connect to server browser ###
# Start a Selenium server with Firefox driver
rD <- rsDriver(browser = "firefox", port = 4555L)

# Open a remote driver client
remDr <- rD$client

# Check whether the path is allowed to scrape
paths_allowed(paths="https://www.amazon.com/")

# Open the amazon url in firefox
url <- "https://www.amazon.com/"
remDr$navigate(url)
Sys.sleep(3)  # wait for the page to load


### Set up a function to Perform a Search in the search box ###
get_amazon_search_gifts <- function(festival) {
  
  # Set the format for different search querys
  query <- sprintf("%s gifts", festival)
  
  # Find the search box and search gift
  search_box <- remDr$findElement(
    using = "css selector", 
    value = "#twotabsearchtextbox"
  )
  
  # Clear the text in the search box
  search_box$clearElement()
  
  # Enter the search query
  search_box$sendKeysToElement(list(query))
  
  # Press the search button
  search_button <- remDr$findElement(
    using = "css selector", 
    value = "#nav-search-submit-button"
  )
  search_button$clickElement()
  Sys.sleep(3)
  
  
  ### Scraping and create data set for different festivals: ###
  ## Extract Product's Information
  
  # Allow the page to be fully loaded
  Sys.sleep(5)
  
  # Find all product containers
  product_containers <- remDr$findElements(
    "xpath", 
    "//div[contains(@class, 'puis-card-container')]"
  )
  
  # Initialise an empty list to store product details
  product_details <- list()
  
  
  # Loop through each product container to extract product details
  for (i in seq_along(product_containers)) {
    # Extract product name
    product_name <- tryCatch(
      product_containers[[i]]$findChildElement(
        using="xpath", 
        value=".//div[@data-cy='title-recipe']/a/h2/span")$getElementText()[[1]],
      
      # If error occurs, return NA instead of stopping the function:
      error = function(e) NA
    )
    
    # Extract rating
    rating <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='reviews-block']/div[1]/span[1]//a"
      )$getElementAttribute("aria-label")[[1]],
      error = function(e) NA
    )
    
    rating_count <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='reviews-block']/div[1]/span[2]//a"
      )$getElementAttribute("aria-label")[[1]],
      error = function(e) NA
    )
    
    # Extract bought count
    bought_count <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='reviews-block']/div[2]//span"
      )$getElementText()[[1]],
      error = function(e) NA
    )
    
    # Extract price
    price <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='price-recipe']//span[contains(@class, 'a-price')]"
      )$getElementText()[[1]],
      error = function(e) NA
    )
    
    # Extract delivery information
    delivery_free <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='delivery-recipe']/div[1]/span[1]/span[1]"
      )$getElementText()[[1]],
      error = function(e) NA
    )
    delivery_date <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='delivery-recipe']/div[1]/span[1]/span[2]"
      )$getElementText()[[1]],
      error = function(e) NA
    )
    
    # Append to the list
    product_details <- append(product_details, list(
      list(
        Name = product_name,
        Rating = rating,
        RatingCount = rating_count,
        BoughtCount = bought_count,
        Price = price,
        DeliveryFree = delivery_free,
        DeliveryDate = delivery_date
      )
    ))
  }
  
  
  
  ### Press the next button ###
  next_button <- remDr$findElement(
    using = "css selector", 
    value = ".s-pagination-next"
  )
  next_button$clickElement()
  Sys.sleep(3)
  
 
  ### Perform Scraping process again on the next page ###
  Sys.sleep(5)
  
  # Find all product containers
  product_containers <- remDr$findElements(
    "xpath", 
    "//div[contains(@class, 'puis-card-container')]"
  )
  
  
  # Loop through each product container to extract product details
  for (i in seq_along(product_containers)) {
    # Extract product name
    product_name <- tryCatch(
      product_containers[[i]]$findChildElement(
        using="xpath", 
        value=".//div[@data-cy='title-recipe']/a/h2/span")$getElementText()[[1]],
      
      # If error occurs, return NA instead of stopping the function:
      error = function(e) NA
    )
    
    # Extract rating
    rating <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='reviews-block']/div[1]/span[1]//a"
      )$getElementAttribute("aria-label")[[1]],
      error = function(e) NA
    )
    
    rating_count <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='reviews-block']/div[1]/span[2]//a"
      )$getElementAttribute("aria-label")[[1]],
      error = function(e) NA
    )
    
    # Extract bought count
    bought_count <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='reviews-block']/div[2]//span"
      )$getElementText()[[1]],
      error = function(e) NA
    )
    
    # Extract price
    price <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='price-recipe']//span[contains(@class, 'a-price')]"
      )$getElementText()[[1]],
      error = function(e) NA
    )
    
    # Extract delivery information
    delivery_free <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='delivery-recipe']/div[1]/span[1]/span[1]"
      )$getElementText()[[1]],
      error = function(e) NA
    )
    delivery_date <- tryCatch(
      product_containers[[i]]$findChildElement(
        using = "xpath", 
        value = ".//div[@data-cy='delivery-recipe']/div[1]/span[1]/span[2]"
      )$getElementText()[[1]],
      error = function(e) NA
    )
    
    # Append to the list
    product_details <- append(product_details, list(
      list(
        Name = product_name,
        Rating = rating,
        RatingCount = rating_count,
        BoughtCount = bought_count,
        Price = price,
        DeliveryFree = delivery_free,
        DeliveryDate = delivery_date
      )
    ))
  }
  
  
  # Convert the list to a data frame
  product_df <- purrr::map_dfr(product_details, as_tibble)
  product_df$festival = festival
  
  return(product_df)
}



### Call scraping function: ###
## 1. Valentine's Day
df_valentine <- get_amazon_search_gifts("Valentine's Day")

## 2. Christmas
df_christmas <- get_amazon_search_gifts("Christmas")

## 3. New Year
df_newyear <- get_amazon_search_gifts("New Year")

# Combine and save scraped data ###
df_combined <- bind_rows(df_valentine, df_christmas, df_newyear)
write.csv(df_combined, "amazon_data.csv")


# Close the browser and stop the server when done
remDr$close()
rD$server$stop()  
  
  

##########################################################
### Data Wrangling ###
cleaned_data <- df_combined %>%
  
  # Only select those useful variables:
  select(!DeliveryDate) %>%
  
  # Extract numeric values from different variables:
  mutate(
    
    Rating = parse_number(Rating),
    
    RatingCount = parse_number(RatingCount),
    
    # ChatGPT suggestted this method by using regular expressions, so it keeps the decimals: Clean Price (handle format like "$9\n99" or "$103\n99")
    Price = as.numeric(str_remove_all(Price, "\\$|\\s|\\n")) / 100,
    
    # First parse the raw number, ignoring plus signs or other text.
    # e.g., "1K+" -> 1, "250+" -> 250, "2.5K+" -> 2.5, etc.
    count = parse_number(BoughtCount),
    
    # If the text contains 'K', multiply the parsed number by 1000, otherwise return itself.
    count = if_else(str_detect(BoughtCount, "K"), count * 1000, count),
    
    # Now bin into categories based on numeric thresholds
    BoughtCount = case_when(
      count >= 10000 ~ "Over 10000",
      count >= 1000 ~ "Over 1000",
      count >= 100  ~ "100-1000",
      TRUE ~ "Less than 100",
    )
  ) %>%
  
  # Remove rows with NA in Price or Rating:
  filter(!is.na(Price), !is.na(Rating))

write.csv(cleaned_data, "Cleaned_amazon_data.csv")

# Inspect the cleaned dataset
glimpse(cleaned_data) 
skim(cleaned_data)


  

