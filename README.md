# My_CSS_Project2

# Amazon Festival Gifts Analysis

## Description:

This project involves analysing consumer behaviour and market trends for festival gifts on Amazon, focusing on three major festivals: **Christmas**, **New Year**, and **Valentine’s Day**. The analysis integrates web scraping, data wrangling, and interactive visualisations to provide insights into spending patterns, product ratings, and purchase popularity. The final deliverable includes a cleaned dataset, an R Shiny dashboard, and a comprehensive report detailing the findings.

## Conclusion:
Christmas stands out as the most significant gift-giving festival, driven by strong cultural and religious traditions, with diverse spending across price ranges reflecting its inclusive nature. New Year, by contrast, focuses more on symbolic and communal celebration, with minimal emphasis on material exchanges. Valentine’s Day highlights the emotional and symbolic value of gifting, with a greater focus on personal connections over monetary value. These patterns underline the importance of aligning product with the cultural and emotional dynamics of each festival, so businesses can improve strategies and meet consumer expectations effectively.

## Table of Contents:

1.  [Features](#features)
2.  [Dataset Overview](#dataset-overview)
3.  [Files and Structure](#files-and-structure)
4.  [Setup Instructions](#setup-instructions)
5.  [Using the Shiny App](#using-the-shiny-app)
6.  [Key Insights](#key-insights)
7.  [Acknowledgments](#acknowledgments)

------------------------------------------------------------------------

## 1. Features: {#features}

-   **Automated Web Scraping:**
    -   Extracts product details from Amazon for the selected festivals using RSelenium.
-   **Data Wrangling:**
    -   Cleans raw data by handling missing values, extracting numeric fields, and categorizing variables.
-   **Interactive Visualisations:**
    -   Provides an R Shiny dashboard with filters for festival selection and price range.
    -   Includes specific visualisations:
        -   Price Distribution by Festival
        -   Rating vs. Price Scatter Plot
        -   Product Popularity Bar Chart
-   **AI engagement:**
    -   Explores consumer behaviour through social and economic lenses.

------------------------------------------------------------------------

## 2. Dataset Overview: {#dataset-overview}

The **`Cleaned_amazon_data.csv`** file is the cleaned dataset used for analysis. The dataset includes the following variables:

| **Column Name** | **Description**                                                              |
|-----------------|-------------------------------------------------------|
| *Name*          | Name of the product.                                                         |
| *Rating*        | Average customer rating (out of 5).                                          |
| *RatingCount*   | Number of customer reviews for the product.                                  |
| *Price*         | Price of the product in GBP (£).                                             |
| *festival*      | Festival associated with the product (Christmas, New Year, Valentine’s Day). |
| *BoughtCount*   | Category of purchase frequency (e.g., Over 10,000, 100–1,000).               |
| *DeliveryFree*  | Indicates the price of the delivery or free delivery.                        |

------------------------------------------------------------------------

## 3. Files and Structure: {#files-and-structure}

### Main Files:

-   **`Cleaned_amazon_data.csv`**:
    -   The cleaned dataset containing the scraping data.
-   **`CSS_Project2_R_script.R`**:
    -   R script for automated web scraping using RSelenium.
-   **`app.R`**:
    -   R Shiny application script for interactive visualisation and analysis.
-   **`README.md`**:
    -   This documentation includes informations of the project.

------------------------------------------------------------------------

## 4. Setup Instructions: {#setup-instructions}

### Prerequisites:

1.  Install R and RStudio.

2.  Load the required R packages:

    ```{r}
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
      skimr # For data inspection
    )
    ```

### Running the Web Scraper:

1.  Run **CSS_Project2_R_script.R** to scrape data from Amazon on Firefox.

### Launching the Shiny App:

1.  load the `app.R` file.

2.  Execute the script to launch the app:

    ```{r}
    shinyApp(ui = ui, server = server)
    ```

3.  The app will run locally and can be accessed via the browser.

------------------------------------------------------------------------

## 5. Using the Shiny App: {#using-the-shiny-app}

1.  **Filters:**
    -   Select festivals of interest using the dropdown menu.
    -   Adjust the price range slider to refine the dataset.
2.  **Tabs:**
    -   **Price Distribution:** Compare the price ranges of gifts across festivals.
    -   **Rating vs. Price:** Explore the relationship between price and customer satisfaction.
    -   **Product Popularity:** View the distribution of products by purchase frequency.
    -   **Data Table:** Examine detailed information of the products.

------------------------------------------------------------------------

## 6. Key Insights: {#key-insights}

1.  **Christmas Dominates:**
    -   Highest product popularity and a diverse price range.
2.  **Valentine’s Day Emotional Value:**
    -   Gifts prioritise symbolic and emotional significance over cost.
3.  **New Year Modesty:**
    -   Limited spending and restrained popularity.

------------------------------------------------------------------------

## 7. Acknowledgments: {#acknowledgments}

This project was developed with support from ChatGPT for code refinement and technical problem-solving. The dataset was scraped from Amazon using RSelenium, and all analyses were conducted using R.

------------------------------------------------------------------------
