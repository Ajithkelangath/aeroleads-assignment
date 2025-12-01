# Aeroleads Assignment

This repository contains the code for the Aeroleads assignment, divided into three exercises.

## Structure

*   **`exercise_1_linkedin_scraper`**: Contains the Python script for scraping LinkedIn profiles.
    *   **File:** `linkedin_scraper.py`
    *   **Output:** `linkedin_data.csv`
    *   **Method:** Uses SERP-only scraping (Google Search Results) to bypass LinkedIn's Auth Wall. No login required.
    *   **Usage:** `python linkedin_scraper.py`

*   **`exercise_2_autodialer`**: Contains the Ruby on Rails application with the Autodialer feature.
    *   **Features:** Manual Call, AI Prompt Call, CSV Upload.
    *   **Usage:** `rails server` -> Navigate to `/caller`

*   **`exercise_3_blog_generator`**: Contains the Ruby on Rails application with the AI Blog Generator feature.
    *   **Features:** Generates blog articles using Perplexity API.
    *   **Content:** Includes 10 pre-generated articles on Data Science topics.
    *   **Usage:** `rails server` -> Navigate to `/articles`

## Setup

1.  **LinkedIn Scraper:**
    *   Install dependencies: `pip install -r requirements.txt` (or `pip install selenium undetected-chromedriver`)
    *   Run: `python linkedin_scraper.py`

2.  **Rails Apps (Autodialer & Blog Generator):**
    *   Navigate to the folder.
    *   Install gems: `bundle install`
    *   Start server: `rails server`
