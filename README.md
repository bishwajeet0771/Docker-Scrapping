# Puppeteer Scraper + Flask Server

A multi-stage Docker application that scrapes a webpage using Puppeteer (Node.js) and serves the result via Flask (Python).

---

## Features

- Uses **Node.js** and **Chromium** to scrape web pages.
- Uses **Python Flask** to serve the data.
- Multi-stage **Dockerfile** for a lean image.
- Easy to configure with environment variables.

---

## How It Works
1. You provide a URL (via an environment variable at build time).

2. Node.js with Puppeteer:
   - Launches a headless Chromium browser.
   - Navigates to the given URL.
   - Extracts:
     - The <title> of the page.
     - The first <h1> element (if available).
     - Saves this info to scraped_data.json.

3. Python Flask App:
   - Reads that JSON file.
   - Serves it at http://localhost:5000/ as JSON over HTTP.

4. Docker Multi-Stage Build:
   - Keeps final image minimal by excluding Chromium/Puppeteer from the runtime.
## Example Test (Real URL)
Say you want to scrape https://www.bbc.com 

## Build the Image

```bash
docker build --build-arg SCRAPE_URL=https://www.bbc.com -t web-scraper-app .
```
