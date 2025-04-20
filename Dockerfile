# Stage 1: Scraper
FROM node:18-slim AS scraper

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Install Chromium
RUN apt-get update && apt-get install -y \
  chromium chromium-common chromium-driver \
  fonts-liberation libappindicator3-1 libasound2 \
  libatk-bridge2.0-0 libatk1.0-0 libcups2 libdbus-1-3 \
  libgdk-pixbuf2.0-0 libnspr4 libnss3 libx11-xcb1 \
  libxcomposite1 libxdamage1 libxrandr2 xdg-utils \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package.json ./
RUN npm install
COPY scrape.js ./

# Run scraping using provided URL
ARG SCRAPE_URL
ENV SCRAPE_URL=${SCRAPE_URL}
RUN node scrape.js

# Stage 2: Python server
FROM python:3.10-slim AS server

WORKDIR /app

COPY --from=scraper /app/scraped_data.json .
COPY server.py .
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["python", "server.py"]


