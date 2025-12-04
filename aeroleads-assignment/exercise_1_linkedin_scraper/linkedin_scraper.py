import sys
import os

# Fix for WinError 6 (The handle is invalid) with undetected-chromedriver
if sys.stdin is None:
    sys.stdin = open(os.devnull, 'r')

import csv
import time
import random
import undetected_chromedriver as uc
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Configuration
OUTPUT_FILE = 'linkedin_data.csv'
TARGET_COUNT = 20

def get_driver():
    try:
        options = uc.ChromeOptions()
        options.add_argument("--disable-blink-features=AutomationControlled")
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")
        
        # Randomize window size
        width = random.randint(1050, 1350)
        height = random.randint(800, 1000)
        options.add_argument(f"--window-size={width},{height}")
        
        # Fix for WinError 6
        driver = uc.Chrome(options=options, use_subprocess=True)
        return driver
    except Exception as e:
        print(f"Failed to initialize undetected-chromedriver: {e}")
        print("Falling back to standard Selenium...")
        from selenium import webdriver
        from selenium.webdriver.chrome.options import Options
        
        opts = Options()
        opts.add_argument("--disable-blink-features=AutomationControlled")
        opts.add_experimental_option("excludeSwitches", ["enable-automation"])
        opts.add_experimental_option('useAutomationExtension', False)
        driver = webdriver.Chrome(options=opts)
        return driver

def random_sleep(min_seconds=2, max_seconds=5):
    time.sleep(random.uniform(min_seconds, max_seconds))

def parse_google_result(result_element):
    """Extracts data from a Google search result element."""
    try:
        # Get URL
        link_elem = result_element.find_element(By.TAG_NAME, "a")
        url = link_elem.get_attribute("href")
        
        # Skip if not a profile
        if "linkedin.com/in/" not in url:
            return None
            
        # Get Title Text (usually "Name - Title - Location | LinkedIn")
        heading_elem = result_element.find_element(By.TAG_NAME, "h3")
        full_text = heading_elem.text
        
        # Parse the text
        # Format usually: "Name - Title - Location | LinkedIn"
        # Or: "Name - Job Title - Company | LinkedIn"
        
        parts = full_text.split(" - ")
        
        name = parts[0].strip() if len(parts) > 0 else "N/A"
        title = "N/A"
        location = "N/A"
        
        if len(parts) >= 3:
            title = parts[1].strip()
            # The last part often contains "| LinkedIn", remove it
            loc_part = parts[2].split("|")[0]
            location = loc_part.strip()
        elif len(parts) == 2:
            # Maybe just Name - Title | LinkedIn
            part2 = parts[1].split("|")[0]
            title = part2.strip()
            
        return {
            "url": url,
            "name": name,
            "title": title,
            "location": location,
            "status": "Success (From Google)"
        }
    except Exception as e:
        return None

def scrape_linkedin_via_google():
    driver = None
    data = []
    
    try:
        print("Starting SERP-only scraper (No Login Required)...")
        driver = get_driver()
        
        search_query = "Software Engineer site:linkedin.com/in/"
        driver.get("https://www.google.com")
        random_sleep(2, 4)
        
        try:
            search_box = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.NAME, "q"))
            )
            
            for char in search_query:
                search_box.send_keys(char)
                time.sleep(random.uniform(0.05, 0.2))
                
            search_box.send_keys(Keys.RETURN)
            random_sleep(3, 6)
            
            page = 1
            while len(data) < TARGET_COUNT:
                print(f"Scraping Google Page {page}...")
                
                # Use robust XPATH to find result containers or direct links
                # Strategy: Find all 'a' tags with href containing linkedin.com/in/
                links = driver.find_elements(By.XPATH, "//a[contains(@href, 'linkedin.com/in/')]")
                
                if not links:
                    print("No LinkedIn links found on this page.")
                    # Debug: Print a bit of page source to see what's going on
                    try:
                        print("Page Source Snippet:")
                        print(driver.page_source[:500])
                    except: pass
                    break
                    
                found_new_on_page = False
                for link in links:
                    try:
                        url = link.get_attribute("href")
                        if not url or "google.com" in url: continue
                        
                        # Avoid duplicates
                        if any(d['url'] == url for d in data): continue
                        
                        # Try to find the title text. Usually contained in an h3 inside the parent or near the link
                        # We can try to get the text of the link itself or a child h3
                        title_text = ""
                        try:
                            # Try finding h3 inside the link
                            h3 = link.find_element(By.TAG_NAME, "h3")
                            title_text = h3.text
                        except:
                            # If no h3, try the link text itself
                            title_text = link.text
                            
                        if not title_text: continue
                        
                        # Parse text
                        parts = title_text.split(" - ")
                        name = parts[0].strip() if len(parts) > 0 else "N/A"
                        title = "N/A"
                        location = "N/A"
                        
                        if len(parts) >= 3:
                            title = parts[1].strip()
                            loc_part = parts[2].split("|")[0]
                            location = loc_part.strip()
                        elif len(parts) == 2:
                            part2 = parts[1].split("|")[0]
                            title = part2.strip()
                            
                        info = {
                            "url": url,
                            "name": name,
                            "title": title,
                            "location": location,
                            "status": "Success (From Google)"
                        }
                        
                        print(f"  -> Found: {name} | {title}")
                        data.append(info)
                        found_new_on_page = True
                        
                        if len(data) >= TARGET_COUNT:
                            break
                    except Exception as e:
                        continue
                
                if len(data) >= TARGET_COUNT:
                    break
                    
                if not found_new_on_page:
                    print("No new profiles found on this page.")
                    break

                # Go to next page
                try:
                    # Try different selectors for "Next" button
                    next_button = None
                    try:
                        next_button = driver.find_element(By.ID, "pnnext")
                    except:
                        try:
                            next_button = driver.find_element(By.XPATH, "//a[contains(@id, 'pnnext') or contains(text(), 'Next')]")
                        except: pass
                    
                    if next_button:
                        next_button.click()
                        random_sleep(4, 7)
                        page += 1
                    else:
                        print("No next page button found.")
                        break
                except:
                    print("Error navigating to next page.")
                    break
                    
        except Exception as e:
            print(f"Error during scraping: {e}")
            
    except Exception as e:
        print(f"Critical error: {e}")
        
    finally:
        if driver:
            try:
                driver.quit()
            except:
                pass
        
    # Save to CSV
    if data:
        with open(OUTPUT_FILE, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=["url", "name", "title", "location", "status"])
            writer.writeheader()
            writer.writerows(data)
        print(f"Done. Saved {len(data)} records to {OUTPUT_FILE}")
    else:
        print("No data collected.")

if __name__ == "__main__":
    # Fix for multiprocessing on Windows
    if sys.platform.startswith('win'):
        import multiprocessing
        multiprocessing.freeze_support()
        
    scrape_linkedin_via_google()
